#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
"""Build bootanimation.zip from a looping video.

    make_bootanimation.py <video> <out.zip> [--preview preview.mp4]

Catalyxx's: python3 bootanimation/make_bootanimation.py \
    bootanimation/bootanimation_source.mp4 bootanimation/bootanimation-<n>.zip
(animation by Dapper Dan & dro223; bootanimation_source.mp4 is theirs, muted).

The video plays once up to LOOP_START (part0), then LOOP_START..end loops while
the device boots (part1), then FADE_SECONDS of what would come next fade to
black (part2). Seconds counted at the video's own frame rate.

The loop's last CROSSFADE_SECONDS blend into the frames just before LOOP_START,
so the jump back to LOOP_START is invisible even though the video never returns
to the same frame on its own.

Frames are cropped to the screen's shape at the video's own resolution and
stored as JPEG: desc.txt carries the screen size and bootanimation draws every
frame stretched to it, so storing more pixels than the video has gains nothing.
JPEG keeps the gradients' full color at a fraction of a palette PNG's size;
bootanimation decodes frames with AImageDecoder, which reads JPEG.

Needs ffmpeg, Python 3 with Pillow and numpy, and zip.
"""
import argparse
import os
import shutil
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image

SCREEN_W, SCREEN_H = 1440, 3168     # OnePlus 13 (dodge): TARGET_SCREEN_WIDTH/HEIGHT
FPS = 24                            # the video's own rate
LOOP_START = 6.5                    # seconds: intro is [0, LOOP_START)
CROSSFADE_SECONDS = 0.75            # end of the loop blends into the frames before LOOP_START
FADE_SECONDS = 0.5                  # part2
JPEG_QUALITY = 93


def run(*cmd):
    subprocess.run(cmd, check=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("video")
    ap.add_argument("out")
    ap.add_argument("--preview")
    args = ap.parse_args()

    work = tempfile.mkdtemp(prefix="bootanim-")
    try:
        # Crop to the screen's aspect ratio at the video's height, centered.
        src = os.path.join(work, "src")
        os.mkdir(src)
        run("ffmpeg", "-nostdin", "-v", "error", "-i", args.video, "-an",
            "-vf", f"fps={FPS},crop=trunc(ih*{SCREEN_W}/{SCREEN_H}/2)*2:ih,format=rgb24",
            os.path.join(src, "f_%04d.png"))
        names = sorted(os.listdir(src))
        frames = [np.asarray(Image.open(os.path.join(src, n)), dtype=np.float32) for n in names]
        n = len(frames)
        a = round(LOOP_START * FPS)
        c = round(CROSSFADE_SECONDS * FPS)
        fade = round(FADE_SECONDS * FPS)
        loop_len = n - a
        if a < c or loop_len <= c or fade > loop_len:
            sys.exit(f"video too short: {n} frames for intro {a}, crossfade {c}, fade {fade}")

        intro = frames[:a]
        loop = []
        for k in range(loop_len):
            f = frames[a + k]
            j = k - (loop_len - c)          # >= 0 inside the crossfade
            if j >= 0:
                w = (j + 1) / (c + 1)       # never quite 1: the loop's last frame leads into frames[a]
                f = (1 - w) * f + w * frames[a + k - loop_len]
            loop.append(f)
        # After the loop comes frames[a] again: fade that continuation out.
        end = [frames[a + k] * (1 - (k + 1) / fade) for k in range(fade)]

        ba = os.path.join(work, "bootanimation")
        parts = [("part0", intro), ("part1", loop), ("part2", end)]
        for part, seq in parts:
            os.makedirs(os.path.join(ba, part))
            for i, f in enumerate(seq):
                img = Image.fromarray(np.clip(f + 0.5, 0, 255).astype(np.uint8), "RGB")
                img.save(os.path.join(ba, part, f"{i:04d}.jpg"), quality=JPEG_QUALITY,
                         optimize=True)
        # Unix line endings: bootanimation parses desc.txt line by line.
        with open(os.path.join(ba, "desc.txt"), "w", newline="\n") as d:
            d.write(f"{SCREEN_W} {SCREEN_H} {FPS}\nc 1 0 part0\nc 0 0 part1\nc 1 0 part2\n")

        # Stored, not compressed: bootanimation maps frames straight out of the zip.
        out = os.path.abspath(args.out)
        if os.path.exists(out):
            os.remove(out)
        subprocess.run(["zip", "-q", "-0", "-X", "-r", out, "desc.txt", "part0", "part1", "part2"],
                       cwd=ba, check=True)
        print(f"{args.out}: part0 {len(intro)}, part1 {len(loop)}, part2 {len(end)} frames, "
              f"{os.path.getsize(out) / 1048576:.1f} MB")

        if args.preview:
            # As it plays: intro, the loop three times, the fade.
            seq = [(p, i) for p, s in parts[:1] for i in range(len(s))]
            seq += [("part1", i) for _ in range(3) for i in range(len(loop))]
            seq += [("part2", i) for i in range(len(end))]
            lst = os.path.join(work, "preview.txt")
            with open(lst, "w") as fl:
                for p, i in seq:
                    fl.write(f"file '{os.path.join(ba, p, f'{i:04d}.jpg')}'\nduration {1 / FPS}\n")
            run("ffmpeg", "-nostdin", "-v", "error", "-y", "-f", "concat", "-safe", "0", "-i", lst,
                "-vf", f"scale={SCREEN_W // 2}:{SCREEN_H // 2},format=yuv420p", "-r", str(FPS),
                "-c:v", "libx264", "-crf", "18", args.preview)
            print(f"{args.preview}: preview at half the screen's size")
    finally:
        shutil.rmtree(work)


if __name__ == "__main__":
    main()

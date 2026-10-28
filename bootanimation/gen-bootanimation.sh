#!/bin/bash -e
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#
# Fit bootanimation.tar to the device's screen and zip it.
#
#     gen-bootanimation.sh <out.zip> <gendir> <bootanimation.tar> <soong_zip> <height> <width>
#
# bootanimation draws the animation at desc.txt's size, centered, and never fits
# it to the display. So desc.txt gets the screen's size, and each part's trim.txt
# draws every frame at the screen's height, centered: on a screen narrower than
# the frames their sides fall off the screen (a negative x, which bootanimation
# draws as is), on a wider one the sides stay black. A height or width of 0
# keeps the frames' own size.

OUT=$1
GENDIR=$2
TAR=$3
SOONG_ZIP=$4
HEIGHT=$5
WIDTH=$6

WORK=$GENDIR/intermediates
mkdir -p $WORK
tar xf $TAR -C $WORK

if [ "$HEIGHT" -gt 0 ] && [ "$WIDTH" -gt 0 ]; then
    {
        read -r FRAME_W FRAME_H FPS
        PARTS=$(cat)
    } < $WORK/desc.txt
    DRAW_W=$(( (HEIGHT * FRAME_W + FRAME_H / 2) / FRAME_H ))
    X=$(( (WIDTH - DRAW_W) / 2 ))
    printf '%s %s %s\n%s\n' $WIDTH $HEIGHT $FPS "$PARTS" > $WORK/desc.txt
    for PART in $WORK/part*/; do
        for FRAME in $PART*.jpg; do
            echo "${DRAW_W}x${HEIGHT}+${X}+0"
        done > ${PART}trim.txt
    done
fi

# Stored, not compressed: bootanimation maps frames straight out of the zip.
$SOONG_ZIP -L 0 -o $OUT -C $WORK -D $WORK

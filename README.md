# Project Catalyxx

Catalyxx is a ROM built on plain LineageOS 24.0 (Android 17). This repo is its
branding and defaults layer: it adds `catalyxx_<device>` products next to the
existing `lineage_<device>` ones. The LineageOS products are left untouched, so
one tree builds both.

This is the `lineage-24.0` branch. The `seventeen` branch is the earlier
version of the same layer on top of RisingOS-Revived.

## Building

```bash
. build/envsetup.sh
catalyze dodge          # lunch catalyxx_dodge-<release>-userdebug
m bacon
```

`catalyze <device> [user|userdebug|eng]` is defined in `vendorsetup.sh` and
works the way LineageOS's `breakfast` does for `lineage_<device>`. The
flashable zip comes out as
`out/target/product/<device>/Catalyxx-<version>-<date>-<type>-<device>.zip`.

## What it changes

| Where | What |
|---|---|
| System palette | Monet seed pinned to lavender `#874EFF`, style RAINBOW, set at first boot. It does not follow the wallpaper. |
| Boot animation | The Project Catalyxx logo: the intro once, a calm starfield looping while the device boots, a fade to black. `bootanimation/`, silent |
| Wallpaper | Purple-to-black gradient with the Catalyxx X, home and lock screen, set at first boot. `wallpaper/` |
| Volume slider | Gradient on, custom mode, `#CFBAFF` at the quiet end deepening to `#A100F1` at the loud end |
| Volume dialog | Media volume shown in percent under the slider |
| Settings | **Catalyxx Lab** ("Mix your own formula"), a card after Connected devices: switches and colors for all of the above. From `packages/apps/CatalyxxLab`. |
| About phone | "Project Catalyxx version" row reading `<version>-<codename>-<date>-<type>-<device>` (17.x is Chlorine, element 17) |
| Zip name | `Catalyxx-…zip` |
| Build type | `OFFICIAL` when signed with Project Catalyxx's release key (its certificate is `config/releasekey.x509.pem`), `UNOFFICIAL` otherwise |
| Updater | Reads `Project-Catalyxx/catalyxx_ota` instead of LineageOS's servers |
| GApps | RisingOS-Revived's `vendor/gms` (synced unforked through the local manifest), its full set less the Pixel-only, US-carrier and system extras listed in `gms/Android.mk`. LineageOS's package installer, avatar picker and NFC Tags app stay. `config/gms.mk`; `WITH_GMS := false` builds without |
| Properties | `ro.catalyxx.version`, `.codename`, `.build.version`, `.display.version`, `.maintainer` |

Brand colours: `#874EFF` is the system seed. `#A100F1`, the signature violet, is
used at full strength only where it is drawn directly (the volume gradient,
and later the logo and boot animation), because Monet would tone it down.

## Boot animation and wallpaper

Boot animation and wallpaper by **Dapper Dan** & **dro223**.

- `bootanimation/bootanimation-1.zip` replaces LineageOS's through `TARGET_BOOTANIMATION`.
  `bootanimation/make_bootanimation.py` builds it from `bootanimation_source.mp4` (their
  video, muted): 1440x3168 at 24 fps, frames stored as JPEG at the video's own resolution
  (bootanimation stretches each frame to the size in `desc.txt`), the intro to 6.5 s, the
  rest looping with its last 0.75 s crossfaded into the frames before the loop so the seam
  doesn't show.
- **To replace it, save the new zip under the next number** (`bootanimation-2.zip`) and
  point `TARGET_BOOTANIMATION` at it. LineageOS's genrule copies the file without tracking
  it, so a new zip under the same name would not be picked up.
- `wallpaper/catalyxx_wallpaper.jpg` (1440x3168) is installed to `/product/media/wallpaper/`
  and named by `ro.config.wallpaper`, which WallpaperManager opens before any built-in
  default. Its gradient is rebuilt at full size from the 768x1376 original, the X enlarged.

## Changes needed outside this repo

Catalyxx needs four small commits in `vendor/lineage`, carried in
`Project-Catalyxx/android_vendor_lineage`. None of them changes a LineageOS
build:

| Commit | Why |
|---|---|
| envsetup: Treat catalyxx_ products as Lineage builds | Without it, `LINEAGE_BUILD` is empty and the build skips BoardConfigLineage.mk (the kernel) and Lineage's sepolicy |
| config: Let a product set the version strings | `LINEAGE_VERSION` is assigned unconditionally, and a second `ro.lineage.version` is a build error |
| bacon: Let a product name its package | The zip is otherwise always `lineage-<version>.zip` |
| config: Accept OFFICIAL as a build type | Any type but RELEASE, NIGHTLY, SNAPSHOT and EXPERIMENTAL resets to UNOFFICIAL |

And these in `frameworks/base`, carried in `Project-Catalyxx/android_frameworks_base`.
The features are cherry-picked with their authors' names from RisingOS-Revived,
which carries them: Pranav Vashi's volume slider gradient and haptics toggle, and
Ghosuto's volume percentage:

| Commit | Why |
|---|---|
| SystemUI: Add volume slider gradient customization | The gradient and `Settings.System.VOLUME_SLIDER_GRADIENT` |
| SystemUI: Add custom gradient start/end color support for volume slider | Custom mode and its start and end colours |
| SystemUI: Fix up gradient related glitch in volume slider | |
| SettingsProvider: Load volume slider gradient defaults from resources | SystemUI hard-codes the defaults; this lets `CatalyxxSettingsProviderOverlay` set them |
| SystemUI: VolumeDialog: Add toggle for haptic feedback [1/2] | `Settings.Secure.VOLUME_DIALOG_HAPTIC_FEEDBACK`; the slider's haptics stay on unless it is 0 |
| SystemUI: Add volume percentage [1/2] | `Settings.System.SHOW_VOLUME_PERCENTAGE` and the percentage under the slider |
| SystemUI: Don't require the volume percentage view | Keeps SystemUI up if the horizontal dialog, which has no percentage view, is ever enabled |
| SettingsProvider: Load the volume percentage default from resources | So the overlay can turn the percentage on |

## First boot only

The palette, the wallpaper, the gradient and the percentage are first-boot defaults, like every SettingsProvider
`def_*` value. They apply after a clean flash, not when you dirty-flash over an
existing install. To get them on an existing install, run these from `adb shell`:

```sh
settings put secure theme_customization_overlay_packages '{"android.theme.customization.system_palette":"874EFF","android.theme.customization.accent_color":"874EFF","android.theme.customization.color_source":"preset","android.theme.customization.theme_style":"RAINBOW"}'
settings put system volume_slider_gradient 1
settings put system custom_gradient_color_mode 1
settings put system custom_gradient_start_color -3163393
settings put system custom_gradient_end_color -6225679
settings put system show_volume_percentage 1
```

The two negative numbers are `#FFCFBAFF` and `#FFA100F1` as signed 32-bit ints.
Catalyxx Lab, under Settings, turns each of these on and off. From adb:
`settings put system volume_slider_gradient 0`,
`settings put system show_volume_percentage 0`, and for the slider's vibration
`settings put secure volume_dialog_haptic_feedback 0`.

## Layout

```
config/version.mk     identity; included from each product's body, before its inherits
config/common.mk      the layer: overlays and ro.catalyxx.* props
products/             catalyxx_<device>.mk + AndroidProducts.mk
overlays/             runtime resource overlays (framework, lineage-sdk, SettingsProvider, Updater)
bootanimation/        boot animation zip, its source video and the script that builds it
wallpaper/            default wallpaper
vendorsetup.sh        catalyze
```

To add a device, copy `products/catalyxx_dodge.mk` to `catalyxx_<device>.mk`,
change the inherited `lineage_<device>.mk`, `PRODUCT_NAME` and maintainer, and
list it in `products/AndroidProducts.mk`. Keep anything device-specific out of
`config/` and `overlays/`, so every device gets the same Catalyxx.

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
| About phone | "Project Catalyxx version" row reading `<version>-<date>-<type>-<device>` |
| Zip name | `Catalyxx-…zip` |
| Build type | `OFFICIAL` when signed with Project Catalyxx's release key (its certificate is `config/releasekey.x509.pem`), `UNOFFICIAL` otherwise |
| Updater | Reads `Project-Catalyxx/catalyxx_ota` instead of LineageOS's servers |
| Properties | `ro.catalyxx.version`, `.build.version`, `.display.version`, `.maintainer` |

Brand colours: `#874EFF` is the system seed. `#A100F1`, the signature violet, is
used at full strength only where it is drawn directly (later the volume
gradient, logo and boot animation), because Monet would tone it down.

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

## First boot only

The palette is a first-boot default. It applies after a clean flash, not when
you dirty-flash over an existing install. To get it on an existing install, run
this from `adb shell`:

```sh
settings put secure theme_customization_overlay_packages '{"android.theme.customization.system_palette":"874EFF","android.theme.customization.accent_color":"874EFF","android.theme.customization.color_source":"preset","android.theme.customization.theme_style":"RAINBOW"}'
```

## Layout

```
config/version.mk     identity; included from each product's body, before its inherits
config/common.mk      the layer: overlays and ro.catalyxx.* props
products/             catalyxx_<device>.mk + AndroidProducts.mk
overlays/             runtime resource overlays (framework, lineage-sdk, Updater)
vendorsetup.sh        catalyze
```

To add a device, copy `products/catalyxx_dodge.mk` to `catalyxx_<device>.mk`,
change the inherited `lineage_<device>.mk`, `PRODUCT_NAME` and maintainer, and
list it in `products/AndroidProducts.mk`. Keep anything device-specific out of
`config/` and `overlays/`, so every device gets the same Catalyxx.

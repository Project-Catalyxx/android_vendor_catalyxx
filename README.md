# Project Catalyxx

Catalyxx is a branding and defaults layer that sits on top of a RisingOS-Revived
(LineageOS 24.0 / Android 17) tree. It adds `catalyxx_<device>` products next to
the existing `lineage_<device>` ones. The RisingOS products are left untouched,
so one tree builds both.

## Building

```bash
. build/envsetup.sh
catalyze dodge          # lunch catalyxx_dodge-<release>-userdebug
rise b
```

`catalyze <device> [user|userdebug|eng]` is defined in `vendorsetup.sh` and
works the way RisingOS's `riseup` does for `lineage_<device>`. The flashable
zip comes out as `out/target/product/<device>/Catalyxx-<version>-<date>-<type>-<device>.zip`,
next to RisingOS's own `-ota.zip` name for the same file.

## What it changes

| Where | What |
|---|---|
| System palette | Monet seed pinned to lavender `#874EFF`, style RAINBOW, set at first boot. It does not follow the wallpaper. |
| Volume slider | Gradient on, custom mode, `#CFBAFF` at the quiet end deepening to `#A100F1` at the loud end |
| About phone | "Catalyxx version" row reading `Catalyxx-<version>-<type>-<device>` |
| Zip name | `Catalyxx-…zip` |
| Updater | Reads `Project-Catalyxx/catalyxx_ota` instead of RisingOS's OTA repo |
| About card | Maintainer line reads "by Brian_OP13" instead of "unknown" |
| Properties | `ro.catalyxx.version`, `.build.version`, `.display.version`, `.maintainer` |

Brand colours: `#874EFF` is the system seed. `#A100F1`, the signature violet, is
used at full strength only where it is drawn directly (gradient, and later the
logo and boot animation), because Monet would tone it down.

## Changes needed outside this repo

Catalyxx needs three small commits in RisingOS projects. None of them changes a
RisingOS build:

| Project | Commit | Why |
|---|---|---|
| `vendor/lineage` | envsetup: Treat catalyxx_ products as Lineage builds | Without it, `LINEAGE_BUILD` is empty and the build skips BoardConfigLineage.mk and Lineage's sepolicy |
| `vendor/lineage` | config: Let a product set the version strings | `LINEAGE_VERSION` hard-codes `RisingOS-`, and a second `ro.lineage.version` is a build error |
| `frameworks/base` | SettingsProvider: Load volume slider gradient defaults from resources | SystemUI hard-codes the gradient defaults to 0 |

## First boot only

The palette and gradient are first-boot defaults, like every SettingsProvider
`def_*` value. They apply after a clean flash, not when you dirty-flash over an
existing install. To get them on an existing install, run these from `adb shell`:

```sh
settings put secure theme_customization_overlay_packages '{"android.theme.customization.system_palette":"874EFF","android.theme.customization.accent_color":"874EFF","android.theme.customization.color_source":"preset","android.theme.customization.theme_style":"RAINBOW"}'
settings put system volume_slider_gradient 1
settings put system custom_gradient_color_mode 1
settings put system custom_gradient_start_color -3163393
settings put system custom_gradient_end_color -6225679
```

The two negative numbers are `#FFCFBAFF` and `#FFA100F1` as signed 32-bit ints.
RisingOS has no settings screen for the gradient yet, so the way to turn it off
is `settings put system volume_slider_gradient 0`.

## Layout

```
config/version.mk     identity; included from each product's body, before its inherits
config/common.mk      the layer: overlays and ro.catalyxx.* props
products/             catalyxx_<device>.mk + AndroidProducts.mk
overlays/             runtime resource overlays (framework, Settings, SettingsProvider, lineage-sdk, Updater)
vendorsetup.sh        catalyze
```

To add a device, copy `products/catalyxx_dodge.mk` to `catalyxx_<device>.mk`,
change the inherited `lineage_<device>.mk`, `PRODUCT_NAME` and maintainer, and
list it in `products/AndroidProducts.mk`.

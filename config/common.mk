#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Catalyxx product layer, inherited by catalyxx_<device>.mk alongside the
# device's lineage_<device>.mk, so everything here lands on top of LineageOS.
#
# Inherited makefiles are imported in sorted path order (get-inherited-nodes in
# build/make/core/node_fns.mk), so device/... is read before this file and the
# LineageOS variables expanded below already exist.

# Device flags (TARGET_ENABLE_BLUR, SURFACE_FLINGER_BOOST, ...)
$(call inherit-product, vendor/catalyxx/config/flags.mk)

# Catalyxx Lab: the Catalyxx settings, a card on Settings' home screen
PRODUCT_PACKAGES += \
    CatalyxxLab

# GApps
$(call inherit-product, vendor/catalyxx/config/gms.mk)

# Fonts: the font overlays Catalyxx Lab's font picker offers, and their fonts
$(call inherit-product, packages/overlays/Lineage/fonts/fonts.mk)

# Weather for the lock screen clocks and widgets: OmniJaws, from RisingOS.
# It builds with sdk/ax_*, AxionOS's libraries from RisingOS's vendor/addons.
PRODUCT_PACKAGES += \
    OmniJaws

# Overlays
PRODUCT_PACKAGES += \
    CatalyxxFrameworkOverlay \
    CatalyxxLineageSdkOverlay \
    CatalyxxSettingsProviderOverlay \
    CatalyxxUpdaterOverlay

# Boot animation, in place of LineageOS's: bootanimation/Android.bp fits one set of
# frames to the device's TARGET_SCREEN_WIDTH/HEIGHT and overrides bootanimation.zip.
# It can't take that file's path (Soong writes an install rule for every module, so two
# modules can't share one), so ro.product.bootanim.file names it: bootanimation plays
# that file in /product/media/ in place of bootanimation.zip.
PRODUCT_PACKAGES += \
    catalyxx-bootanimation.zip

PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.bootanim.file=catalyxx-bootanimation.zip

# Full OTA payload in zstd instead of xz: recovery unpacks it several times faster
# when sideloading. The switch is read by Project Catalyxx's build/make.
TARGET_OTA_ENABLE_REPLACE_ZSTD := true

# Default wallpaper, home and lock screen: WallpaperManager opens the file named
# by ro.config.wallpaper before any built-in default.
PRODUCT_COPY_FILES += \
    vendor/catalyxx/wallpaper/catalyxx_wallpaper.jpg:$(TARGET_COPY_OUT_PRODUCT)/media/wallpaper/catalyxx_wallpaper.jpg

# Component overrides: hides the Settings entry of LineageOS Trust, which
# vendor/lineage no longer ships, and the setup wizard's LineageOS features page.
PRODUCT_COPY_FILES += \
    vendor/catalyxx/config/sysconfig/catalyxx-component-overrides.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/catalyxx-component-overrides.xml

# Properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.catalyxx.version=$(CATALYXX_VERSION) \
    ro.catalyxx.codename=$(CATALYXX_CODENAME) \
    ro.catalyxx.build.version=$(CATALYXX_BUILD_VERSION) \
    ro.catalyxx.display.version=$(CATALYXX_DISPLAY_VERSION) \
    ro.catalyxx.maintainer=$(CATALYXX_MAINTAINER) \
    ro.config.wallpaper=/product/media/wallpaper/catalyxx_wallpaper.jpg

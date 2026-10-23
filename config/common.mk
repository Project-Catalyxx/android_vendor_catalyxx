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

# Catalyxx Lab: the Catalyxx settings, a card on Settings' home screen
PRODUCT_PACKAGES += \
    CatalyxxLab

# GApps
$(call inherit-product, vendor/catalyxx/config/gms.mk)

# Overlays
PRODUCT_PACKAGES += \
    CatalyxxFrameworkOverlay \
    CatalyxxLineageSdkOverlay \
    CatalyxxSettingsProviderOverlay \
    CatalyxxUpdaterOverlay

# Boot animation, in place of LineageOS's: vendor/lineage/config/BoardConfigSoong.mk
# hands TARGET_BOOTANIMATION to the bootanimation.zip genrule as a prebuilt, which
# copies it without tracking it, so a new animation needs a new file name.
TARGET_BOOTANIMATION := vendor/catalyxx/bootanimation/bootanimation-1.zip

# Default wallpaper, home and lock screen: WallpaperManager opens the file named
# by ro.config.wallpaper before any built-in default.
PRODUCT_COPY_FILES += \
    vendor/catalyxx/wallpaper/catalyxx_wallpaper.jpg:$(TARGET_COPY_OUT_PRODUCT)/media/wallpaper/catalyxx_wallpaper.jpg

# Properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.catalyxx.version=$(CATALYXX_VERSION) \
    ro.catalyxx.codename=$(CATALYXX_CODENAME) \
    ro.catalyxx.build.version=$(CATALYXX_BUILD_VERSION) \
    ro.catalyxx.display.version=$(CATALYXX_DISPLAY_VERSION) \
    ro.catalyxx.maintainer=$(CATALYXX_MAINTAINER) \
    ro.config.wallpaper=/product/media/wallpaper/catalyxx_wallpaper.jpg

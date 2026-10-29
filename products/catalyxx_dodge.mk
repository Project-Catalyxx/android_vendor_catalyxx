#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Catalyxx for the OnePlus 13 (dodge): LineageOS's lineage_dodge with the
# Catalyxx layer on top. lineage_dodge itself is untouched, so a plain
# LineageOS build from the same tree comes out exactly as before.

# Part of this file's body, so it is read before any inherited makefile;
# see config/version.mk for why that matters.
include vendor/catalyxx/config/version.mk
CATALYXX_MAINTAINER := Brian_OP13

# Device flags; README.md lists them all
TARGET_ENABLE_BLUR := true
SURFACE_FLINGER_BOOST := true
# Dolby's app (packages/apps/LunarisDolby) replaces AudioFX
TARGET_EXCLUDES_AUDIOFX := true

$(call inherit-product, device/oneplus/dodge/lineage_dodge.mk)
$(call inherit-product, vendor/catalyxx/config/common.mk)

# About phone: the retail name, chip and cameras
PRODUCT_PACKAGE_OVERLAYS += vendor/catalyxx/products/overlay/dodge

PRODUCT_NAME := catalyxx_dodge

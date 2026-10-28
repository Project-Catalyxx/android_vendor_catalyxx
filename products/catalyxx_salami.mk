#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Catalyxx for the OnePlus 11 (salami): LineageOS's lineage_salami with the
# Catalyxx layer on top. lineage_salami itself is untouched, so a plain
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

$(call inherit-product, device/oneplus/salami/lineage_salami.mk)
$(call inherit-product, vendor/catalyxx/config/common.mk)

PRODUCT_NAME := catalyxx_salami

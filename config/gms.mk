#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# GApps: RisingOS-Revived's vendor/gms, its full set, less the apps listed in
# vendor/catalyxx/gms/Android.mk. Set WITH_GMS := false in the product makefile
# for a build without them.
#
# WITH_GMS also tells vendor/lineage/config/BoardConfigReservedSize.mk not to
# hold back the ~1.9 GB of free product space it keeps for flashing GApps later.
WITH_GMS ?= true

ifeq ($(WITH_GMS),true)

# Pixel back-tap: no OnePlus has the sensor. gms_full.mk sets it with ?=, and
# this file's body is read before the makefiles it inherits.
TARGET_SUPPORTS_QUICK_TAP := false

$(call inherit-product, vendor/gms/gms_full.mk)

PRODUCT_PACKAGES += \
    CatalyxxGmsRemovals

# vendor/gms's makefiles list optional <uses-library> entries that some of its
# APKs don't declare (org.apache.http.legacy on TurboPrebuilt, for one), which
# fails the build's manifest check. Rising relaxes the check for GApps too:
# a mismatched app just isn't compiled ahead of time.
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# Google's apps update themselves from the Play Store, which throws away
# anything compiled for them at build time, so don't spend product space on it.
DONT_DEXPREOPT_PREBUILTS := true

endif

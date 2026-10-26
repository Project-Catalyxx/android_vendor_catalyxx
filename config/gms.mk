#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# GApps: exactly what RisingOS-Revived's vendor/lineage/config/common.mk turns
# on with WITH_GMS, minus Rising's own SettingsGoogle and SystemUIGoogle (its
# Settings and SystemUI rebuilt from source, which don't build on LineageOS).
# WITH_GMS is set in config/version.mk.
#
# WITH_GMS also tells vendor/lineage/config/BoardConfigReservedSize.mk not to
# hold back the ~1.9 GB of free product space it keeps for flashing GApps later.

ifeq ($(WITH_GMS),true)

$(call inherit-product, vendor/gms/gms_full.mk)

# Pixel Launcher's themed icons
$(call inherit-product, vendor/google/overlays/ThemeIcons/config.mk)

# The props Pixel setup reads at start (it crashes without them), and the
# Google apps' overlays, sounds and vibrations
$(call inherit-product, vendor/pixel-style/config/common.mk)

# pixel-style's setup wizard overlay names the OS risingOS ("risingOS Setup",
# "Finish setting up risingOS"); this one, on top of it, says Catalyxx
PRODUCT_PACKAGES += \
    CatalyxxSetupWizardOverlay

# Settings' search bar, pointed at Google's SettingsIntelligence
PRODUCT_PACKAGES += \
    CatalyxxSettingsGmsOverlay

# QuickSwitch: the Pixel Launcher stays the default home app; Launcher3
# and Lawnchair can be picked in Catalyxx Lab > User interface > Home app
PRODUCT_PACKAGES += \
    Lawnchair \
    LawnchairOverlay \
    Lawnicons

PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.default_launcher=1 \
    persist.sys.quickswitch_pixel_shipped=1 \
    persist.sys.quickswitch_lawnchair_shipped=1

# vendor/gms's makefiles list optional <uses-library> entries that some of its
# APKs don't declare (org.apache.http.legacy on TurboPrebuilt, for one), which
# fails the build's manifest check. Rising relaxes the check for GApps too:
# a mismatched app just isn't compiled ahead of time.
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# Google's apps update themselves from the Play Store, which throws away
# anything compiled for them at build time, so don't spend product space on it.
DONT_DEXPREOPT_PREBUILTS := true

# Catalyxx's own removals (vendor/catalyxx/gms/Android.mk) are off, so the set
# is Rising's, which is known to set up and boot on dodge. To leave those apps
# out again, add CatalyxxGmsRemovals to PRODUCT_PACKAGES, after checking that
# nothing it removes is something Pixel setup or Android depends on.

endif

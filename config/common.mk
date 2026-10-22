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

# Overlays
PRODUCT_PACKAGES += \
    CatalyxxFrameworkOverlay \
    CatalyxxLineageSdkOverlay \
    CatalyxxSettingsProviderOverlay \
    CatalyxxUpdaterOverlay

# Properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.catalyxx.version=$(CATALYXX_VERSION) \
    ro.catalyxx.build.version=$(CATALYXX_BUILD_VERSION) \
    ro.catalyxx.display.version=$(CATALYXX_DISPLAY_VERSION) \
    ro.catalyxx.maintainer=$(CATALYXX_MAINTAINER)

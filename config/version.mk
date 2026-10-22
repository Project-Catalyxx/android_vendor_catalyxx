#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Catalyxx identity.
#
# Included from each catalyxx_<device>.mk body, not inherited. The build reads
# a product makefile's own body before anything it inherits, so these values
# are already set when vendor/lineage/config/version.mk and
# vendor/lineage/build/tasks/bacon.mk reach their ?= hooks.
#
# The version strings use '=' rather than ':=' on purpose.
# LINEAGE_VERSION_SUFFIX (<date>-<buildtype>-<device>) is defined by
# vendor/lineage/config/version.mk, which is read later; '=' expands it when
# it is used, by which point it exists.

CATALYXX_VERSION := 1.0

CATALYXX_BUILD_VERSION = $(CATALYXX_VERSION)-$(LINEAGE_VERSION_SUFFIX)
CATALYXX_DISPLAY_VERSION = $(CATALYXX_BUILD_VERSION)

# Settings > About phone > Android version shows ro.lineage.version, under the
# "Project Catalyxx version" title from CatalyxxLineageSdkOverlay
LINEAGE_VERSION = $(CATALYXX_BUILD_VERSION)
LINEAGE_DISPLAY_VERSION = $(CATALYXX_DISPLAY_VERSION)

# The flashable zip: Catalyxx-<version>-<date>-<buildtype>-<device>.zip
LINEAGE_TARGET_PACKAGE = $(PRODUCT_OUT)/Catalyxx-$(LINEAGE_VERSION).zip

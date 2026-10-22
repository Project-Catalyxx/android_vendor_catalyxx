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

# <Android version>.<Catalyxx release>: 17.0 is the first Catalyxx on Android 17.
# Bump the second number for each Catalyxx release (17.1, 17.2, ...), and move
# to <next Android>.0 when the base moves to the next Android version.
CATALYXX_VERSION := 17.0

# OFFICIAL only when the build is signed with Project Catalyxx's own release
# key: the tree's keys (make-keys.sh writes them to vendor/lineage-priv/keys)
# must hold the certificate published here. Any other build of this source,
# including one with someone else's keys, stays UNOFFICIAL. The certificate is
# public: it is inside every signed app and zip anyway.
CATALYXX_RELEASE_CERT := vendor/catalyxx/config/releasekey.x509.pem
ifneq ($(shell cmp -s $(CATALYXX_RELEASE_CERT) vendor/lineage-priv/keys/releasekey.x509.pem && echo yes),)
    LINEAGE_BUILDTYPE := OFFICIAL
endif

CATALYXX_BUILD_VERSION = $(CATALYXX_VERSION)-$(LINEAGE_VERSION_SUFFIX)
CATALYXX_DISPLAY_VERSION = $(CATALYXX_BUILD_VERSION)

# Settings > About phone > Android version shows ro.lineage.version, under the
# "Project Catalyxx version" title from CatalyxxLineageSdkOverlay
LINEAGE_VERSION = $(CATALYXX_BUILD_VERSION)
LINEAGE_DISPLAY_VERSION = $(CATALYXX_DISPLAY_VERSION)

# The flashable zip: Catalyxx-<version>-<date>-<buildtype>-<device>.zip
LINEAGE_TARGET_PACKAGE = $(PRODUCT_OUT)/Catalyxx-$(LINEAGE_VERSION).zip

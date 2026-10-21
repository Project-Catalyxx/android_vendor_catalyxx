#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Catalyxx identity.
#
# Included from each catalyxx_<device>.mk body, not inherited. The build reads
# a product makefile's own body before anything it inherits, so these values
# are already set when vendor/lineage/config/version.mk reaches its ?= hooks.
#
# The version strings use '=' rather than ':=' on purpose. RISING_BUILD_DATE,
# RISING_PACKAGE_TYPE and CURRENT_DEVICE are defined by
# vendor/rising/config/version.mk, which is read later; '=' expands them when
# they are used, by which point they exist.

CATALYXX_VERSION := 1.0

CATALYXX_BUILD_VERSION = $(CATALYXX_VERSION)-$(RISING_BUILD_DATE)-$(RISING_PACKAGE_TYPE)-$(CURRENT_DEVICE)
CATALYXX_DISPLAY_VERSION = $(CATALYXX_VERSION)-$(RISING_PACKAGE_TYPE)-$(CURRENT_DEVICE)

# Settings > About phone, and the flashable zip's name (vendor/lineage bacon.mk)
LINEAGE_VERSION = Catalyxx-$(CATALYXX_BUILD_VERSION)
LINEAGE_DISPLAY_VERSION = Catalyxx-$(CATALYXX_DISPLAY_VERSION)

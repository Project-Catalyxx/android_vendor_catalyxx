#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# Device flags: switches a device sets in the body of its catalyxx_<device>.mk,
# which is read before this file. They keep the names RisingOS and other
# LineageOS-based ROMs use, so the settings in those device trees carry over.
# Every flag here is read by something; README.md lists them, together with
# the ones LineageOS and vendor/gms read themselves.

# Blur behind the notification shade, quick settings and dialogs. SurfaceFlinger
# draws it, and SystemUI turns it on when SurfaceFlinger reports it can.
TARGET_ENABLE_BLUR ?= false
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.supports_background_blur=1
endif

# SurfaceFlinger boost: SurfaceFlinger asks the kernel scheduler for at least
# 135 of 1024 CPU performance for itself, so frames aren't composed on cores
# clocked down to idle.
SURFACE_FLINGER_BOOST ?= false
ifeq ($(SURFACE_FLINGER_BOOST),true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.uclamp.min=135
endif

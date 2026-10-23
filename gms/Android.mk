#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

# The GApps Catalyxx leaves out of vendor/gms's full set (config/gms.mk).
# vendor/gms is used unforked, so instead of editing its lists this module
# overrides those apps: the build drops every module that a module in
# PRODUCT_PACKAGES overrides (module-overrides in build/make/core/main.mk).
#
# Matched against vendor/gms's folder names, which are its module names, so an
# app that comes back under a new version number is still left out.
catalyxx_gms_removed := \
    AndroidGlassesCoreStub \
    AvatarPickerGoogle \
    CarrierLocation \
    CarrierMetrics \
    CbrsNetworkMonitor \
    DevicePolicyPrebuilt* \
    DreamlinerDreamsPrebuilt* \
    DreamlinerPrebuilt* \
    DreamlinerUpdater \
    FamilySpacePrebuilt* \
    GooglePackageInstaller \
    KidsSupervisionStub \
    PulsePrebuilt \
    RelationshipsPrebuilt* \
    SearchSelectorPrebuilt \
    TagGoogle \
    Tycho \
    YourWidgetsStub

# Installs nothing; base_rules.mk only lets ETC, EXECUTABLES and
# SHARED_LIBRARIES modules carry LOCAL_OVERRIDES_MODULES.
include $(CLEAR_VARS)
LOCAL_MODULE := CatalyxxGmsRemovals
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := CatalyxxGmsRemovals.txt
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_OVERRIDES_MODULES := \
    $(notdir $(foreach m,$(catalyxx_gms_removed),$(wildcard vendor/gms/*/packages/*/$(m))))
include $(BUILD_PREBUILT)

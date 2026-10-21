#
# SPDX-FileCopyrightText: 2026 Project Catalyxx
# SPDX-License-Identifier: Apache-2.0
#

# catalyze <device> [user|userdebug|eng]
#
# Lunch catalyxx_<device>, the way LineageOS's breakfast lunches
# lineage_<device>. Build afterwards with 'm bacon'.
function catalyze() {
    local device="$1"
    local build_type="${2:-userdebug}"
    local aosp_target_release

    if [[ -z "$device" ]]; then
        echo "Usage: catalyze <device> [user|userdebug|eng]"
        return 1
    fi

    case "$build_type" in
        user|userdebug|eng)
            ;;
        *)
            echo "Invalid build type '$build_type'. Use user, userdebug or eng."
            return 1
            ;;
    esac

    source "$(gettop)/vendor/lineage/vars/aosp_target_release"
    lunch "catalyxx_${device}-${aosp_target_release}-${build_type}"
}

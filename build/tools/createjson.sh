#!/bin/bash
#
# Copyright (C) 2019-2025 crDroid Android Project
# Copyright (C) 2023-2024 AlphaDroid
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#$1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=FILE_NAME
DEVICE=$1
OUT=$2
FILENAME=$3

existingOTAjson=./vendor/OTA/$DEVICE.json
output=$OUT/$DEVICE.json
buildprop="$OUT/system/build.prop"

# Cleanup old file
if [ -f $output ]; then
    rm $output
fi

# Helper function to extract field from JSON
extract_field() {
    grep -m 1 "\"$1\":" "$existingOTAjson" | sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | xargs
}

# Helper function to extract prop from prop file
extract_prop() {
    grep -m 1 "$1" "$buildprop" | cut -d'=' -f2
}

# Generate JSON fields
VERSION=$(extract_prop "ro.alpha.build.version")
BUILDTYPE=$(extract_prop "ro.alpha.release.type")
BUILDVARIANT=$(extract_prop "ro.alpha.build.variant")
MAINTAINER=$(extract_prop "ro.alpha.maintainer")
TIMESTAMP=$(extract_prop "ro.system.build.date.utc")
MD5=$(md5sum "$OUT/$FILENAME" | cut -d' ' -f1)
SHA256=$(sha256sum "$OUT/$FILENAME" | cut -d' ' -f1)
SIZE=$(stat -c "%s" "$OUT/$FILENAME")

if [ -f $existingOTAjson ]; then
    # Extract fields from existing JSON or leave empty
    OEM=$(extract_field "oem")
    FORUM=$(extract_field "forum")
    GAPPS=$(extract_field "gapps")
    FIRMWARE=$(extract_field "firmware")
    MODEM=$(extract_field "modem")
    BOOTLOADER=$(extract_field "bootloader")
    RECOVERY=$(extract_field "recovery")
    PAYPAL=$(extract_field "paypal")
    TELEGRAM=$(extract_field "telegram")
    DT=$(extract_field "dt")
    COMMON_DT=$(extract_field "common-dt")
    KERNEL=$(extract_field "kernel")
fi

# Generate JSON output
cat <<EOF >$output
{
    "response": [
        {
            "maintainer": "${MAINTAINER:-}",
            "oem": "${OEM:-}",
            "device": "$DEVICE",
            "filename": "$FILENAME",
            "download": "https://sourceforge.net/projects/alphadroid-project/files/$DEVICE/$FILENAME/download",
            "timestamp": $TIMESTAMP,
            "md5": "$MD5",
            "sha256": "$SHA256",
            "size": $SIZE,
            "version": "$VERSION",
            "buildtype": "$BUILDTYPE",
            "buildvariant": "$BUILDVARIANT",
            "forum": "${FORUM:-}",
            "gapps": "${GAPPS:-}",
            "firmware": "${FIRMWARE:-}",
            "modem": "${MODEM:-}",
            "bootloader": "${BOOTLOADER:-}",
            "recovery": "${RECOVERY:-}",
            "paypal": "${PAYPAL:-}",
            "telegram": "${TELEGRAM:-}",
            "dt": "${DT:-}",
            "common-dt": "${COMMON_DT:-}",
            "kernel": "${KERNEL:-}"
        }
    ]
}
EOF

if [ ! -f $existingOTAjson ]; then
    echo 'There is no official support for this device yet'
    echo 'Consider adding official support by reading the documentation at https://github.com/alphadroid-devices/OTA/blob/alpha-15.1/README.md'
else
    echo ""
    cat $output
    echo ""
fi

echo "JSON file generation completed"

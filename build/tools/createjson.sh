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
existingOTAjson=./vendor/OTA/$1.json
output=$2/$1.json

# Cleanup old file
if [ -f $output ]; then
    rm $output
fi

echo "Generating JSON file data for OTA support..."

# Helper function to extract field from JSON
extract_field() {
    grep "\"$1\":" "$existingOTAjson" | sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | xargs
}

if [ -f $existingOTAjson ]; then
    # Extract fields from existing JSON or leave empty
    MAINTAINER=$(extract_field "maintainer")
    OEM=$(extract_field "oem")
    DEVICE=$(extract_field "device")
    BUILDTYPE=$(extract_field "buildtype")
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

# Generate JSON fields
FILENAME=$3
VERSION=$(awk '{ sub(/v/, ""); sub(/\.zip/, ""); print }' <<< `echo "$3" | cut -d'-' -f6`)

BUILDPROP="$2/system/build.prop"
TIMESTAMP=$(grep "ro.system.build.date.utc" "$BUILDPROP" | cut -d'=' -f2)
MD5=$(md5sum "$2/$3" | cut -d' ' -f1)
SHA256=$(sha256sum "$2/$3" | cut -d' ' -f1)
SIZE=$(stat -c "%s" "$2/$3")

# Generate JSON output
cat <<EOF >$output
{
    "response": [
        {
            "maintainer": "${MAINTAINER:-}",
            "oem": "${OEM:-}",
            "device": "${DEVICE:-}",
            "filename": "$3",
            "download": "https://sourceforge.net/projects/alphadroid-project/files/$1/$3/download",
            "timestamp": $TIMESTAMP,
            "md5": "$MD5",
            "sha256": "$SHA256",
            "size": $SIZE,
            "version": "$VERSION",
            "buildtype": "${BUILDTYPE:-}",
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
fi

echo "JSON file generation completed"

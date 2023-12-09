# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)
$(call inherit-product-if-exists, vendor/addons/config.mk)
$(call inherit-product, vendor/alpha/config/features.mk)
$(call inherit-product, vendor/alpha/config/properties.mk)
$(call inherit-product, vendor/alpha/config/packages.mk)
$(call inherit-product, vendor/alpha/config/audio.mk)
$(call inherit-product-if-exists, vendor/pixel-framework/config.mk)

ifeq ($(WITH_PIXEL_OVERLAYS),true)
-include vendor/pixeloverlays/config.mk
endif


PRODUCT_BRAND ?= AlphaDroid
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Speed profile services and wifi-service to reduce RAM and storage
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/config/boot-image-profile.txt

PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
WITH_DEXPREOPT_DEBUG_INFO := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true
FULL_SYSTEM_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Text classifier
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/textclassifier/actions_suggestions.universal.model \
    system/etc/textclassifier/lang_id.model \
    system/etc/textclassifier/textclassifier.en.model \
    system/etc/textclassifier/textclassifier.universal.model

# Updater
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/etc/init/init.alpha-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.alpha-updater.rc

# Boadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/alpha/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Init rc files
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/etc/init/init.alpha-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.alpha-system_ext.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Permissions
PRODUCT_COPY_FILES += \
    vendor/alpha/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.android.xml \
    vendor/alpha/config/permissions/com.android.angle.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.android.angle.xml

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
  # Lineage SDK
  include vendor/alpha/config/lineage_sdk_common.mk
endif

PRODUCT_COPY_FILES += \
  vendor/alpha/prebuilt/common/etc/init/init.alpha-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.alpha-updater.rc

# OpenSSH
PRODUCT_COPY_FILES += \
    vendor/alpha/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

ifeq ($(TARGET_ENABLE_EPPE),true)
  # Require all requested packages to exist
  $(call enforce-product-packages-exist-internal,$(wildcard device/*/$(LINEAGE_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

ifneq ($(TARGET_BUILD_VARIANT),user)
  PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep \
    Lawnchair \
    Settings \
    SystemUI

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/alpha/overlay/no-rro
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/alpha/overlay/common \
    vendor/alpha/overlay/no-rro

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/alpha/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/alpha/overlay/dictionaries

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/crowdin/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/crowdin/overlay

# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/alpha/build/target/product/security/lineage

include vendor/alpha/config/version.mk
-include $(WORKSPACE)/build_env/image-auto-bits.mk

# Inherit from rro_overlays config
$(call inherit-product, vendor/lineage/config/rro_overlays.mk)
# Inherit from rro_overlays config
$(call inherit-product, vendor/lineage/config/telephony.mk)

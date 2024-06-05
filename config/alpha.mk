PRODUCT_BRAND ?= Alpha

PRODUCT_PACKAGES += \
    bootanimation.zip

ifeq ($(TARGET_INCLUDE_MATLOG),true)
  PRODUCT_PACKAGES += \
    MatLog
endif

# Privapp-permissions whitelist mode
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Disable blur on app launch
PRODUCT_PRODUCT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0

# TARGET_BUILD_PACKAGE options:
# 1 - vanilla (default)
# 2 - microg
# 3 - gapps

  BUILD_GMS_OVERLAYS_AND_PROPS := true
  $(call inherit-product, vendor/gms/gms_full.mk)



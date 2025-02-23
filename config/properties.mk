# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true \
    dalvik.vm.systemuicompilerfilter=speed

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    debug.sf.enable_transaction_tracing=false
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
  # Disable ADB authentication
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
  # Enable ADB authentication
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

  # Disable extra StrictMode features on all non-engineering builds
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true

  # Disable debug and verbose logging by default
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += log.tag=I
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# Additional props
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    drm.service.enabled=true \
    persist.sys.dun.override=0 \
    persist.sys.disable_rescue=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Workaround AOSP AM crash
PRODUCT_PROPERTY_OVERRIDES += \
    sys.fflag.override.settings_enable_monitor_phantom_procs=false

# Blurs
ifeq ($(TARGET_ENABLE_BLUR), true)
  PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

# Disable async MTE on a few processes
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.process.system_server=off

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Privapp-permissions whitelist mode
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Disable blur on app launch
PRODUCT_PRODUCT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0

# Disable default frame rate limit for games
PRODUCT_PRODUCT_PROPERTIES += \
    debug.graphics.game_default_frame_rate.disabled=true

# Pif
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_BRAND?=google \
    persist.sys.pihooks_MANUFACTURER?=Google \
    persist.sys.pihooks_DEVICE?=tokay \
    persist.sys.pihooks_PRODUCT?=tokay_beta \
    persist.sys.pihooks_DEVICE_INITIAL_SDK_INT?=21 \
    persist.sys.pihooks_SECURITY_PATCH?=2025-02-05 \
    persist.sys.pihooks_ID?=BP22.250124.009 \
    persist.sys.pihooks_FINGERPRINT?=google/tokay_beta/tokay:Baklava/BP22.250124.009/13034193:user/release-keys \
    persist.sys.pihooks_MODEL?=Pixel 9

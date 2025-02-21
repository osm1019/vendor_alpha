
# Apps
PRODUCT_PACKAGES += \
    Backgrounds \
    BatteryStatsViewer \
    Eleven \
    Etar \
    ExactCalculator \
    GameSpace \
    Glimpse \
    Jelly \
    LatinIME \
    Launcher3QuickStep \
    LineageParts \
    LineageSettingsProvider \
    LineageSetupWizard \
    LMOFreeform \
    LMOFreeformSidebar \
    OmniJaws \
    OmniStyle \
    Profiles \
    QuickAccessWallet \
    Recorder \
    Seedvault \
    ThemePicker \
    ThemesStub \
    Updater

ifneq ($(PRODUCT_NO_CAMERA),true)
  PRODUCT_PACKAGES += \
    Aperture
endif

ifneq ($(TARGET_EXCLUDES_AUDIOFX),true)
  PRODUCT_PACKAGES += \
    AudioFX
endif

ifeq ($(TARGET_INCLUDE_MATLOG),true)
  PRODUCT_PACKAGES += \
    MatLog
endif

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# Charger animation
PRODUCT_PACKAGES += \
    charger_res_images \
    alpha_charger_animation \
    alpha_charger_animation_vendor

# Overlays
PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    NetworkStackOverlay \
    NavigationBarMode2ButtonOverlay \
    WallpaperPickerOverlayAndroid \
    WallpaperPickerOverlaySettings

# Build Manifest
PRODUCT_PACKAGES += \
    build-manifest

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Root
PRODUCT_PACKAGES += \
    adb_root

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

# Extra tools
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd

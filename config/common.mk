# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/bootleggers/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/bootleggers/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/bootleggers/prebuilt/common/bin/50-bootleggers.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-bootleggers.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/bootleggers/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/bootleggers/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/bootleggers/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# system mount
PRODUCT_COPY_FILES += \
    vendor/bootleggers/build/tools/system-mount.sh:install/bin/system-mount.sh

# priv-app whitelist
PRODUCT_COPY_FILES += \
    vendor/bootleggers/prebuilt/common/etc/permissions/privapp-permissions-bootleg.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-bootleg.xml \
    vendor/bootleggers/prebuilt/common/etc/permissions/privapp-permissions-bootleg.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-bootleg.xml

# our sysconfig
PRODUCT_COPY_FILES += \
    vendor/bootleggers/config/permissions/bootleg-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/bootleg-sysconfig.xml

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/bootleggers/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# Copy all Bootleggers-specific init rc files
$(foreach f,$(wildcard vendor/bootleggers/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/bootleggers/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/bootleggers/config/permissions/bootleg-power-whitelist.xml:system/etc/sysconfig/bootleg-power-whitelist.xml

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/bootleggers/config/permissions/privapp-permissions-recorder.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-recorder.xml \
    vendor/bootleggers/config/permissions/bootleggers-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/bootleggers-hiddenapi-package-whitelist.xml \
    vendor/bootleggers/config/permissions/privapp-permissions-recorder.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-recorder.xml \
    vendor/bootleggers/config/permissions/bootleggers-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/bootleggers-hiddenapi-package-whitelist.xml

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

PRODUCT_PACKAGES += \
    FaceUnlockOverlay

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/bootleggers/config/twrp.mk
endif

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Extra tools in Bootleggers
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    htop \
    lib7z \
    libsepol \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    nano \
    pigz \
    powertop \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Extra cmdline tools
PRODUCT_PACKAGES += \
    zstd

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# exFAT tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

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

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Disable rescue party
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep

# Some props that we need for the google stuff we're adding
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.ime.height_ratio=1.05 \
    ro.com.google.ime.emoji_key=false

# Gesture Overlays
PRODUCT_PACKAGES += \
  ImmersiveNavigationOverlay

# Enable one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Enable SystemUIDialog volume panel
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    sys.fflag.override.settings_volume_panel_in_systemui=true

PRODUCT_PACKAGE_OVERLAYS += vendor/bootleggers/overlay/common

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/bootleggers/config/partner_gms.mk

ifeq ($(TARGET_PROVIDES_TELEPHONY_EXT),)
ifeq ($(TARGET_REQUIRES_TELEPHONY_EXT),true)
include vendor/bootleggers/config/caf_fw.mk
endif
endif

include vendor/bootleggers/config/btlg_main.mk

# RRO Overlays
PRODUCT_PACKAGES += \
    NavigationBarModeGesturalOverlayFS

# Artifact path requirements
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-bootleggers.sh \
    system/app/MiXplorerPrebuilt/MiXplorerPrebuilt.apk \
    system/app/NfcNci/NfcNci.apk \
    system/app/NfcNci/lib/arm64/libnfc_nci_jni.so \
    system/app/NoCutoutOverlay/NoCutoutOverlay.apk \
    system/app/NotallyPrebuilt/NotallyPrebuilt.apk \
    system/app/PrebuiltAuxioOverlay/PrebuiltAuxioOverlay.apk \
    system/app/QPGallery/QPGallery.apk \
    system/app/StitchImage-res/StitchImage-res.apk \
    system/app/StitchImage-sceditor/StitchImage-sceditor.apk \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_postinstall.sh \
    system/bin/curl \
    system/etc/default-permissions/com.android.providers.weather.xml \
    system/etc/default-permissions/default_permissions_co.aospa.sense.xml \
    system/etc/init/bootleggers-adb.rc \
    system/etc/init/bootleggers-init.rc \
    system/etc/init/bootleggers-iosched.rc \
    system/etc/init/bootleggers-livedisplay.rc \
    system/etc/init/bootleggers-radio.rc \
    system/etc/init/bootleggers-ssh.rc \
    system/etc/init/bootleggers-system.rc \
    system/etc/init/bootleggers-tcp.rc \
    system/etc/libnfc-nci.conf \
    system/etc/permissions/android.hardware.biometrics.face.xml \
    system/etc/permissions/android.software.sip.voip.xml \
    system/etc/permissions/bootleggers-hiddenapi-package-whitelist.xml \
    system/etc/permissions/com.android.providers.weather.xml \
    system/etc/permissions/org.lineageos.livedisplay.xml \
    system/etc/permissions/privapp-permissions-bootleg.xml \
    system/etc/permissions/privapp-permissions-recorder.xml \
    system/etc/permissions/privapp_whitelist_co.aospa.sense.xml \
    system/etc/sensitive_pn.xml \
    system/etc/sysconfig/backup.xml \
    system/etc/sysconfig/bootleg-power-whitelist.xml \
    system/etc/sysconfig/bootleg-sysconfig.xml \
    system/etc/sysconfig/hiddenapi-whitelist-co.aospa.sense.xml \
    system/lib/content-types.properties \
    system/lib/libRSSupport.so \
    system/lib/libblasV8.so \
    system/lib/librsjni.so \
    system/lib/libsepol.so \
    system/lib64/android.hardware.nfc-V1-ndk.so \
    system/lib64/android.hardware.nfc@1.0.so \
    system/lib64/android.hardware.nfc@1.1.so \
    system/lib64/android.hardware.nfc@1.2.so \
    system/lib64/libFaceDetectCA.so \
    system/lib64/libMegviiUnlock-jni-1.2.so \
    system/lib64/libMegviiUnlock.so \
    system/lib64/libRSSupport.so \
    system/lib64/libblasV8.so \
    system/lib64/libmegface.so \
    system/lib64/libnfc-nci.so \
    system/lib64/libnfc_nci_jni.so \
    system/lib64/librsjni.so \
    system/lib64/libsepol.so \
    system/lib64/libstatslog_nfc.so \
    system/priv-app/ParanoidSense/ParanoidSense.apk \
    system/priv-app/StitchImage/StitchImage.apk \
    system/usr/keylayout/Vendor_045e_Product_0719.kl \
    system/xbin/wget

# Certification
-include vendor/certification/config.mk

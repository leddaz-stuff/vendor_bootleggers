PRODUCT_BRAND ?= Bootleggers

# Versioning System
# Bootleggers version over here.
PRODUCT_VERSION_MAJOR = Urubino
PRODUCT_VERSION_MINOR = niceparse.O
BOOTLEGGERS_VERSION_NUMBER := 7.9-Testing
BOOTLEGGERS_SONGCODEURL = https://cutt.ly/zwE3JaNb
BOOTLEGGERS_EPOCH := $(shell date +%s)
BOOTLEGGERS_POSTFIX := -$(shell date -d @$(BOOTLEGGERS_EPOCH) +"%Y%m%d-%H%M%S")

# Build type, unofficial by default
BOOTLEGGERS_BUILD_TYPE ?= Unshishufied

ifeq ($(BOOTLEGGERS_BUILD_APPS_BUNDLE),true)
    ifeq ($(WITH_GAPPS),true)
        BOOTLEGGERS_RELEASE_TYPE := $(BOOTLEGGERS_BUILD_TYPE)-GApps
    else ifeq ($(WITH_MICROG),true)
        BOOTLEGGERS_RELEASE_TYPE := $(BOOTLEGGERS_BUILD_TYPE)-MicroG
    else
        BOOTLEGGERS_RELEASE_TYPE := $(BOOTLEGGERS_BUILD_TYPE)-Vanilla
    endif
else
    ifeq ($(WITH_GAPPS),true)
        BOOTLEGGERS_RELEASE_TYPE := $(BOOTLEGGERS_BUILD_TYPE)-MiniGApps
    else
        BOOTLEGGERS_RELEASE_TYPE := $(BOOTLEGGERS_BUILD_TYPE)-Minimal
    endif
endif

ifdef BOOTLEGGERS_BUILD_EXTRA
    BOOTLEGGERS_POSTFIX := -$(BOOTLEGGERS_BUILD_EXTRA)
    BOOTLEGGERS_MOD_SHORT := BootleggersROM-$(PRODUCT_VERSION_MAJOR)4$(BOOTLEGGERS_BUILD)-$(BOOTLEGGERS_RELEASE_TYPE)$(BOOTLEGGERS_POSTFIX)
else
    BOOTLEGGERS_MOD_SHORT := BootleggersROM-$(PRODUCT_VERSION_MAJOR)4$(BOOTLEGGERS_BUILD)-$(BOOTLEGGERS_RELEASE_TYPE)
endif

BOOTLEGGERS_VERSION := BootleggersROM-$(PRODUCT_VERSION_MAJOR)4$(BOOTLEGGERS_BUILD).$(BOOTLEGGERS_VERSION_NUMBER)-$(BOOTLEGGERS_RELEASE_TYPE)$(BOOTLEGGERS_POSTFIX)

#PRODUCT_PACKAGES += \
#    bootanimation.zip

ifneq ($(TARGET_USE_SINGLE_BOOTANIMATION),true)
    PRODUCT_PACKAGES += \
        bootanimation2.zip \
        bootanimation3.zip
endif

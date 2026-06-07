#
# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_m.mk)

# Inherit some common aosp stuff
$(call inherit-product, vendor/aosp/config/common_full_phone.mk)

# Inherit from shamrock device
$(call inherit-product, $(LOCAL_PATH)/device.mk)

## Android One Experience required flags
# if your build is ready to release:
#CUSTOM_BUILD_TYPE := release
PRODUCT_CUSTOM_MODEL := GM5P
TARGET_GAPPS_ARCH=arm64

# Gallery2
PRODUCT_PACKAGES += \
    Gallery2

## Android One Experience Required Flags end

PRODUCT_BRAND := GM
PRODUCT_DEVICE := shamrock
PRODUCT_MANUFACTURER := General Mobile
PRODUCT_NAME := aosp_shamrock
PRODUCT_MODEL := GM 5 Plus

PRODUCT_GMS_CLIENTID_BASE := android-gm
TARGET_VENDOR := GM
TARGET_VENDOR_PRODUCT_NAME := shamrock
PRODUCT_BUILD_PROP_OVERRIDES += PRIVATE_BUILD_DESC="mata-user 8.1.0 OPM1.180104.092 224 release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := essential/mata/mata:8.1.0/OPM1.180104.092/224:user/release-keys
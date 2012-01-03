DEVICE_PACKAGE_OVERLAYS += device/lge/p500/overlay

PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/kernel:kernel

PRODUCT_PACKAGES += \
    librs_jni \
    libmm-omxcore \
    libOmxCore \
    gps.p500 \
    lights.p500 \
    copybit.p500 \
    gralloc.p500 \
    bdaddr_read \
    gadget_id \
    bash

PRODUCT_PACKAGES += \
    flash_image \
    dump_image \
    erase_image \
    e2fsck \
    SpareParts

PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    VisualizationWallpapers \
    SystemTransparent

DISABLE_DEXPREOPT := false

# Kernel Related
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/modules/wireless.ko:system/lib/modules/wireless.ko \
    device/lge/p500/prebuilt/modules/tun.ko:system/lib/modules/tun.ko \
#    device/lge/p500/prebuilt/modules/cifs.ko:system/lib/modules/cifs.ko \

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

# Offline Charging
PRODUCT_COPY_FILES += \
    device/lge/p500/bootlogo/bootlogo:root/sbin/bootlogo \
    device/lge/p500/bootlogo/ftm_power:root/sbin/ftm_power \
    device/lge/p500/bootlogo/bootimages/opening_01.rle:root/bootimages/opening_01.rle \
    device/lge/p500/bootlogo/bootimages/opening_02.rle:root/bootimages/opening_02.rle \
    device/lge/p500/bootlogo/bootimages/opening_03.rle:root/bootimages/opening_03.rle \
    device/lge/p500/bootlogo/bootimages/opening_04.rle:root/bootimages/opening_04.rle \
    device/lge/p500/bootlogo/bootimages/opening_05.rle:root/bootimages/opening_05.rle \
    device/lge/p500/bootlogo/bootimages/opening_06.rle:root/bootimages/opening_06.rle \
    device/lge/p500/bootlogo/bootimages/opening_07.rle:root/bootimages/opening_07.rle \
    device/lge/p500/bootlogo/bootimages/opening_08.rle:root/bootimages/opening_08.rle \
    device/lge/p500/chargemode/chargerlogo:root/sbin/chargerlogo \
    device/lge/p500/chargemode/chargerimages/black_bg.rle:root/chargerimages/black_bg.rle \
    device/lge/p500/chargemode/chargerimages/battery_bg.rle:root/chargerimages/battery_bg.rle \
    device/lge/p500/chargemode/chargerimages/battery_ani_01.rle:root/chargerimages/battery_ani_01.rle \
    device/lge/p500/chargemode/chargerimages/battery_ani_02.rle:root/chargerimages/battery_ani_02.rle \
    device/lge/p500/chargemode/chargerimages/battery_ani_03.rle:root/chargerimages/battery_ani_03.rle \
    device/lge/p500/chargemode/chargerimages/battery_ani_04.rle:root/chargerimages/battery_ani_04.rle \
    device/lge/p500/chargemode/chargerimages/battery_ani_05.rle:root/chargerimages/battery_ani_05.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_01.rle:root/chargerimages/battery_charging_01.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_02.rle:root/chargerimages/battery_charging_02.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_03.rle:root/chargerimages/battery_charging_03.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_04.rle:root/chargerimages/battery_charging_04.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_05.rle:root/chargerimages/battery_charging_05.rle \
    device/lge/p500/chargemode/chargerimages/battery_charging_06.rle:root/chargerimages/battery_charging_06.rle \
    device/lge/p500/chargemode/chargerimages/battery_wait_ani_01.rle:root/chargerimages/battery_wait_ani_01.rle \
    device/lge/p500/chargemode/chargerimages/battery_wait_ani_02.rle:root/chargerimages/battery_wait_ani_02.rle \
#    vendor/lge/p500/proprietary/init:root/init \

# Audio
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/etc/AudioFilter.csv:system/etc/AudioFilter.csv \
    vendor/lge/p500/proprietary/etc/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
    vendor/lge/p500/proprietary/lib/liba2dp.so:system/lib/liba2dp.so \
    vendor/lge/p500/proprietary/lib/libaudioeq.so:system/lib/libaudioeq.so \

# Bluetooth
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/bin/BCM4325D1_004.002.004.0218.0248.hcd:system/bin/BCM4325D1_004.002.004.0218.0248.hcd \


# Board-specific init (does not support charging in "power off" state yet)
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/init.thunderg.rc:root/init.thunderg.rc \
    device/lge/p500/prebuilt/initlogo.rle:root/initlogo.rle \
    device/lge/p500/prebuilt/ueventd.thunderg.rc:root/ueventd.thunderg.rc \

# Camera
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/lib/liboemcamera.so:system/lib/liboemcamera.so \
    vendor/lge/p500/proprietary/lib/libmmipl.so:system/lib/libmmipl.so \
    vendor/lge/p500/proprietary/lib/libmmjpeg.so:system/lib/libmmjpeg.so \

# Graphics-2D (using proprietary because of poor perfomance of open source libs)
#PRODUCT_COPY_FILES += \
#    vendor/lge/p500/proprietary/lib/hw/gralloc.default.so:system/lib/hw/gralloc.default.so \
#    vendor/lge/p500/proprietary/lib/hw/gralloc.p500.so:system/lib/hw/gralloc.p500.so \

# Graphics-3D
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/lib/egl/libEGL_adreno200.so:system/lib/egl/libEGL_adreno200.so \
    vendor/lge/p500/proprietary/lib/egl/libGLESv1_CM_adreno200.so:system/lib/egl/libGLESv1_CM_adreno200.so \
    vendor/lge/p500/proprietary/lib/egl/libGLESv2_adreno200.so:system/lib/egl/libGLESv2_adreno200.so \
    vendor/lge/p500/proprietary/lib/egl/libq3dtools_adreno200.so:system/lib/egl/libq3dtools_adreno200.so \
    vendor/lge/p500/proprietary/lib/libgsl.so:system/lib/libgsl.so \
    vendor/lge/p500/proprietary/etc/firmware/yamato_pfp.fw:system/etc/firmware/yamato_pfp.fw \
    vendor/lge/p500/proprietary/etc/firmware/yamato_pm4.fw:system/etc/firmware/yamato_pm4.fw \

# Keylayouts
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/usr/keychars/thunder_keypad.kcm.bin:system/usr/keychars/thunder_keypad.kcm.bin \
    vendor/lge/p500/proprietary/usr/keylayout/thunder_keypad.kl:system/usr/keylayout/thunder_keypad.kl \
    vendor/lge/p500/proprietary/usr/keylayout/7k_handset.kl:system/usr/keylayout/7k_handset.kl \

# LGE services
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/bin/qmuxd:system/bin/qmuxd \
    vendor/lge/p500/proprietary/lib/libdsutils.so:system/lib/libdsutils.so \
#    vendor/lge/p500/proprietary/lib/libnetmgr.so:system/lib/libnetmgr.so \
#    vendor/lge/p500/proprietary/bin/netmgrd:system/bin/netmgrd \
#    vendor/lge/p500/proprietary/bin/port-bridge:system/bin/port-bridge \
#    vendor/lge/p500/proprietary/bin/rmt_storage:system/bin/rmt_storage \
#    vendor/lge/p500/proprietary/bin/wiperiface:system/bin/wiperiface \

# Media Profiles
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/etc/media_profiles.xml:system/etc/media_profiles.xml

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \

# RIL
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/lib/libauth.so:system/lib/libauth.so \
    vendor/lge/p500/proprietary/lib/libbcmwl.so:system/lib/libbcmwl.so \
    vendor/lge/p500/proprietary/lib/libcm.so:system/lib/libcm.so \
    vendor/lge/p500/proprietary/lib/libdiag.so:system/lib/libdiag.so \
    vendor/lge/p500/proprietary/lib/libdll.so:system/lib/libdll.so \
    vendor/lge/p500/proprietary/lib/libdsm.so:system/lib/libdsm.so \
    vendor/lge/p500/proprietary/lib/libdss.so:system/lib/libdss.so \
    vendor/lge/p500/proprietary/lib/libgsdi_exp.so:system/lib/libgsdi_exp.so \
    vendor/lge/p500/proprietary/lib/libgstk_exp.so:system/lib/libgstk_exp.so \
    vendor/lge/p500/proprietary/lib/liblgdrm.so:system/lib/liblgdrm.so \
    vendor/lge/p500/proprietary/lib/liblgdrmwbxml.so:system/lib/liblgdrmwbxml.so \
    vendor/lge/p500/proprietary/lib/liblgeat.so:system/lib/liblgeat.so \
    vendor/lge/p500/proprietary/lib/liblgerft.so:system/lib/liblgerft.so \
    vendor/lge/p500/proprietary/lib/libmmgsdilib.so:system/lib/libmmgsdilib.so \
    vendor/lge/p500/proprietary/lib/libnv.so:system/lib/libnv.so \
    vendor/lge/p500/proprietary/lib/liboem_rapi.so:system/lib/liboem_rapi.so \
    vendor/lge/p500/proprietary/lib/liboncrpc.so:system/lib/liboncrpc.so \
    vendor/lge/p500/proprietary/lib/libpbmlib.so:system/lib/libpbmlib.so \
    vendor/lge/p500/proprietary/lib/libqmi.so:system/lib/libqmi.so \
    vendor/lge/p500/proprietary/lib/libqueue.so:system/lib/libqueue.so \
    vendor/lge/p500/proprietary/lib/libril-qc-1.so:system/lib/libril-qc-1.so \
    vendor/lge/p500/proprietary/lib/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so \
    vendor/lge/p500/proprietary/lib/libsnd.so:system/lib/libsnd.so \
    vendor/lge/p500/proprietary/lib/libwms.so:system/lib/libwms.so \
    vendor/lge/p500/proprietary/lib/libwmsts.so:system/lib/libwmsts.so \
    vendor/lge/p500/proprietary/bin/rild:system/bin/rild \

# propietary libril
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/lib/libril.so:system/lib/libril.so \

# SD Card
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/etc/vold.fstab:system/etc/vold.fstab \

# Sensors
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/bin/ami304d:system/bin/ami304d \
    vendor/lge/p500/proprietary/lib/hw/sensors.p500.so:system/lib/hw/sensors.p500.so \
    vendor/lge/p500/proprietary/lib/libsensorservice.so:system/lib/libsensorservice.so \

# Touchscreen firmware updater
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/bin/tsdown:system/bin/tsdown \
    vendor/lge/p500/proprietary/etc/MELFAS_FIRM.bin:system/etc/MELFAS_FIRM.bin \

# Wifi
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    device/lge/p500/prebuilt/etc/dhcpd/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
    vendor/lge/p500/proprietary/etc/wl/nvram.txt:system/etc/wl/nvram.txt \
    vendor/lge/p500/proprietary/etc/wl/rtecdc.bin:system/etc/wl/rtecdc.bin \
    vendor/lge/p500/proprietary/etc/wl/rtecdc-apsta.bin:system/etc/wl/rtecdc-apsta.bin \
    vendor/lge/p500/proprietary/etc/wl/rtecdc-mfgtest.bin:system/etc/wl/rtecdc-mfgtest.bin

## OMX
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/lib/libOmxAacDec.so:system/lib/libOmxAacDec.so \
    vendor/lge/p500/proprietary/lib/libOmxAacEnc.so:system/lib/libOmxAacEnc.so \
    vendor/lge/p500/proprietary/lib/libOmxAdpcmDec.so:system/lib/libOmxAdpcmDec.so \
    vendor/lge/p500/proprietary/lib/libOmxAmrDec.so:system/lib/libOmxAmrDec.so \
    vendor/lge/p500/proprietary/lib/libOmxAmrEnc.so:system/lib/libOmxAmrEnc.so \
    vendor/lge/p500/proprietary/lib/libOmxAmrRtpDec.so:system/lib/libOmxAmrRtpDec.so \
    vendor/lge/p500/proprietary/lib/libOmxAmrwbDec.so:system/lib/libOmxAmrwbDec.so \
    vendor/lge/p500/proprietary/lib/libOmxEvrcDec.so:system/lib/libOmxEvrcDec.so \
    vendor/lge/p500/proprietary/lib/libOmxEvrcEnc.so:system/lib/libOmxEvrcEnc.so \
    vendor/lge/p500/proprietary/lib/libOmxEvrcHwDec.so:system/lib/libOmxEvrcHwDec.so \
    vendor/lge/p500/proprietary/lib/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
    vendor/lge/p500/proprietary/lib/libOmxMp3Dec.so:system/lib/libOmxMp3Dec.so \
    vendor/lge/p500/proprietary/lib/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
    vendor/lge/p500/proprietary/lib/libOmxOn2Dec.so:system/lib/libOmxOn2Dec.so \
    vendor/lge/p500/proprietary/lib/libOmxQcelpDec.so:system/lib/libOmxQcelpDec.so \
    vendor/lge/p500/proprietary/lib/libOmxQcelp13Enc.so:system/lib/libOmxQcelp13Enc.so \
    vendor/lge/p500/proprietary/lib/libOmxQcelpHwDec.so:system/lib/libOmxQcelpHwDec.so \
    vendor/lge/p500/proprietary/lib/libOmxVidEnc.so:system/lib/libOmxVidEnc.so \
    vendor/lge/p500/proprietary/lib/libOmxWmaDec.so:system/lib/libOmxWmaDec.so \
    vendor/lge/p500/proprietary/lib/libOmxWmvDec.so:system/lib/libOmxWmvDec.so \
    vendor/lge/p500/proprietary/lib/libmm-adspsvc.so:system/lib/libmm-adspsvc.so \
    vendor/lge/p500/proprietary/lib/libdivxdrmdecrypt.so:system/lib/libdivxdrmdecrypt.so

PRODUCT_LOCALES += mdpi

# Enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1

# Extended JNI checks
# The extended JNI checks will cause the system to run more slowly, but they can spot a 
# variety of nasty bugs before they have a chance to cause problems.
# Default=true for development builds, set by android buildsystem.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.kernel.android.checkjni=0 \
    dalvik.vm.checkjni=false

# RIL properties
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libargs=-d/dev/smd0 \
    rild.libpath=/system/lib/libril-qc-1.so \
    ro.telephony.default_network=0 \
    ro.telephony.call_ring.delay=0 \
    ro.telephony.call_ring.multiple=false

# Networking properties
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=60

# Performance & graphics properties
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-flags=m=y \
    dalvik.vm.dexopt-data-only=1 \
    dalvik.vm.heapsize=32m \
    dalvik.vm.execution-mode=int:jit \
    ro.opengles.version=131072 \
    windowsmgr.max_events_per_sec=260 \
    persist.cust.tel.eons=1 
#    persist.sys.use_16bpp_alpha=1 \
#    persist.sys.purgeable_assets=1 \

# Vibrator amp default value
PRODUCT_PROPERTY_OVERRIDES += \
    DEVICE_PROVISIONED=1 \
    ro.sf.lcd_density=160 \
    ro.lge.vibrator_amp=125

PRODUCT_NAME := p500
PRODUCT_DEVICE := p500
PRODUCT_MODEL := LG Optimus One


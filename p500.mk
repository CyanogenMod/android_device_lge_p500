DEVICE_PACKAGE_OVERLAYS += device/lge/p500/overlay

PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/kernel:kernel

PRODUCT_PACKAGES += \
    librs_jni \
    libmm-omxcore \
    libOmxCore \
    gps.thunderg \
    lights.thunderg \
    copybit.thunderg \
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
    device/lge/p500/prebuilt/modules/cifs.ko:system/lib/modules/cifs.ko \
    device/lge/p500/prebuilt/modules/tun.ko:system/lib/modules/tun.ko \

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

# Offline Charging
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/sbin/bootlogo:root/sbin/bootlogo \
    vendor/lge/p500/proprietary/sbin/chargerlogo:root/sbin/chargerlogo \
    vendor/lge/p500/proprietary/sbin/ftm_power:root/sbin/ftm_power \
    vendor/lge/p500/proprietary/bootimages/opening_01.rle:root/bootimages/opening_01.rle \
    vendor/lge/p500/proprietary/bootimages/opening_02.rle:root/bootimages/opening_02.rle \
    vendor/lge/p500/proprietary/bootimages/opening_03.rle:root/bootimages/opening_03.rle \
    vendor/lge/p500/proprietary/bootimages/opening_04.rle:root/bootimages/opening_04.rle \
    vendor/lge/p500/proprietary/bootimages/opening_05.rle:root/bootimages/opening_05.rle \
    vendor/lge/p500/proprietary/bootimages/opening_06.rle:root/bootimages/opening_06.rle \
    vendor/lge/p500/proprietary/bootimages/opening_07.rle:root/bootimages/opening_07.rle \
    vendor/lge/p500/proprietary/bootimages/opening_08.rle:root/bootimages/opening_08.rle \
    vendor/lge/p500/proprietary/chargerimages/black_bg.rle:root/chargerimages/black_bg.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_bg.rle:root/chargerimages/battery_bg.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_ani_01.rle:root/chargerimages/battery_ani_01.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_ani_02.rle:root/chargerimages/battery_ani_02.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_ani_03.rle:root/chargerimages/battery_ani_03.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_ani_04.rle:root/chargerimages/battery_ani_04.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_ani_05.rle:root/chargerimages/battery_ani_05.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_01.rle:root/chargerimages/battery_charging_01.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_02.rle:root/chargerimages/battery_charging_02.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_03.rle:root/chargerimages/battery_charging_03.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_04.rle:root/chargerimages/battery_charging_04.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_05.rle:root/chargerimages/battery_charging_05.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_charging_06.rle:root/chargerimages/battery_charging_06.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_wait_ani_01.rle:root/chargerimages/battery_wait_ani_01.rle \
    vendor/lge/p500/proprietary/chargerimages/battery_wait_ani_02.rle:root/chargerimages/battery_wait_ani_02.rle \
#    vendor/lge/p500/proprietary/system/init:root/init \

# Audio
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/etc/AudioFilter.csv:system/etc/AudioFilter.csv \
    vendor/lge/p500/proprietary/system/etc/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
    vendor/lge/p500/proprietary/system/lib/liba2dp.so:system/lib/liba2dp.so \
    vendor/lge/p500/proprietary/system/lib/libaudioeq.so:system/lib/libaudioeq.so \

# Bluetooth
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/bin/BCM4325D1_004.002.004.0218.0248.hcd:system/bin/BCM4325D1_004.002.004.0218.0248.hcd \


# Board-specific init (does not support charging in "power off" state yet)
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/init.thunderg.rc:root/init.thunderg.rc \
    device/lge/p500/prebuilt/initlogo.rle:root/initlogo.rle \
    device/lge/p500/prebuilt/ueventd.thunderg.rc:root/ueventd.thunderg.rc \

# Camera
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/lib/liboemcamera.so:system/lib/liboemcamera.so \
    vendor/lge/p500/proprietary/system/lib/libmmipl.so:system/lib/libmmipl.so \
    vendor/lge/p500/proprietary/system/lib/libmmjpeg.so:system/lib/libmmjpeg.so \

# Graphics-2D (using proprietary because of poor perfomance of open source libs)
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/lib/hw/gralloc.default.so:system/lib/hw/gralloc.default.so \
    vendor/lge/p500/proprietary/system/lib/hw/gralloc.thunderg.so:system/lib/hw/gralloc.thunderg.so \

# Graphics-3D
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/lib/egl/libEGL_adreno200.so:system/lib/egl/libEGL_adreno200.so \
    vendor/lge/p500/proprietary/system/lib/egl/libGLESv1_CM_adreno200.so:system/lib/egl/libGLESv1_CM_adreno200.so \
    vendor/lge/p500/proprietary/system/lib/egl/libGLESv2_adreno200.so:system/lib/egl/libGLESv2_adreno200.so \
    vendor/lge/p500/proprietary/system/lib/egl/libq3dtools_adreno200.so:system/lib/egl/libq3dtools_adreno200.so \
    vendor/lge/p500/proprietary/system/lib/libgsl.so:system/lib/libgsl.so \
    vendor/lge/p500/proprietary/system/etc/firmware/yamato_pfp.fw:system/etc/firmware/yamato_pfp.fw \
    vendor/lge/p500/proprietary/system/etc/firmware/yamato_pm4.fw:system/etc/firmware/yamato_pm4.fw \

# Keylayouts
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/usr/keychars/thunder_keypad.kcm.bin:system/usr/keychars/thunder_keypad.kcm.bin \
    vendor/lge/p500/proprietary/system/usr/keylayout/thunder_keypad.kl:system/usr/keylayout/thunder_keypad.kl \
    vendor/lge/p500/proprietary/system/usr/keylayout/7k_handset.kl:system/usr/keylayout/7k_handset.kl \

# LGE services
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/bin/netmgrd:system/bin/netmgrd \
    vendor/lge/p500/proprietary/system/bin/port-bridge:system/bin/port-bridge \
    vendor/lge/p500/proprietary/system/bin/qmuxd:system/bin/qmuxd \
    vendor/lge/p500/proprietary/system/bin/rmt_storage:system/bin/rmt_storage \
    vendor/lge/p500/proprietary/system/bin/wiperiface:system/bin/wiperiface \
    vendor/lge/p500/proprietary/system/lib/libdsutils.so:system/lib/libdsutils.so \
    vendor/lge/p500/proprietary/system/lib/libnetmgr.so:system/lib/libnetmgr.so \

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
    vendor/lge/p500/proprietary/system/lib/libauth.so:system/lib/libauth.so \
    vendor/lge/p500/proprietary/system/lib/libbcmwl.so:system/lib/libbcmwl.so \
    vendor/lge/p500/proprietary/system/lib/libcm.so:system/lib/libcm.so \
    vendor/lge/p500/proprietary/system/lib/libdiag.so:system/lib/libdiag.so \
    vendor/lge/p500/proprietary/system/lib/libdll.so:system/lib/libdll.so \
    vendor/lge/p500/proprietary/system/lib/libdsm.so:system/lib/libdsm.so \
    vendor/lge/p500/proprietary/system/lib/libdss.so:system/lib/libdss.so \
    vendor/lge/p500/proprietary/system/lib/libgsdi_exp.so:system/lib/libgsdi_exp.so \
    vendor/lge/p500/proprietary/system/lib/libgstk_exp.so:system/lib/libgstk_exp.so \
    vendor/lge/p500/proprietary/system/lib/liblgdrm.so:system/lib/liblgdrm.so \
    vendor/lge/p500/proprietary/system/lib/liblgdrmwbxml.so:system/lib/liblgdrmwbxml.so \
    vendor/lge/p500/proprietary/system/lib/liblgeat.so:system/lib/liblgeat.so \
    vendor/lge/p500/proprietary/system/lib/liblgerft.so:system/lib/liblgerft.so \
    vendor/lge/p500/proprietary/system/lib/libmmgsdilib.so:system/lib/libmmgsdilib.so \
    vendor/lge/p500/proprietary/system/lib/libnv.so:system/lib/libnv.so \
    vendor/lge/p500/proprietary/system/lib/liboem_rapi.so:system/lib/liboem_rapi.so \
    vendor/lge/p500/proprietary/system/lib/liboncrpc.so:system/lib/liboncrpc.so \
    vendor/lge/p500/proprietary/system/lib/libpbmlib.so:system/lib/libpbmlib.so \
    vendor/lge/p500/proprietary/system/lib/libqmi.so:system/lib/libqmi.so \
    vendor/lge/p500/proprietary/system/lib/libqueue.so:system/lib/libqueue.so \
    vendor/lge/p500/proprietary/system/lib/libril-qc-1.so:system/lib/libril-qc-1.so \
    vendor/lge/p500/proprietary/system/lib/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so \
    vendor/lge/p500/proprietary/system/lib/libsnd.so:system/lib/libsnd.so \
    vendor/lge/p500/proprietary/system/lib/libwms.so:system/lib/libwms.so \
    vendor/lge/p500/proprietary/system/lib/libwmsts.so:system/lib/libwmsts.so \
    vendor/lge/p500/proprietary/system/bin/rild:system/bin/rild \

# propietary libril
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/lib/libril.so:system/lib/libril.so \

# SD Card
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/etc/vold.fstab:system/etc/vold.fstab \

# Sensors
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/bin/ami304d:system/bin/ami304d \
    vendor/lge/p500/proprietary/system/lib/hw/sensors.thunderg.so:system/lib/hw/sensors.thunderg.so \
#    vendor/lge/p500/proprietary/system/lib/libsensorservice.so:system/lib/libsensorservice.so \

# Touchscreen firmware updater
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/bin/tsdown:system/bin/tsdown \
    vendor/lge/p500/proprietary/system/etc/MELFAS_FIRM.bin:system/etc/MELFAS_FIRM.bin \

# Wifi
PRODUCT_COPY_FILES += \
    device/lge/p500/prebuilt/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    device/lge/p500/prebuilt/etc/dhcpd/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
    vendor/lge/p500/proprietary/system/etc/wl/nvram.txt:system/etc/wl/nvram.txt \
    vendor/lge/p500/proprietary/system/etc/wl/rtecdc.bin:system/etc/wl/rtecdc.bin \
    vendor/lge/p500/proprietary/system/etc/wl/rtecdc-apsta.bin:system/etc/wl/rtecdc-apsta.bin \
    vendor/lge/p500/proprietary/system/etc/wl/rtecdc-mfgtest.bin:system/etc/wl/rtecdc-mfgtest.bin

# OMX
PRODUCT_COPY_FILES += \
    vendor/lge/p500/proprietary/system/lib/libmm-adspsvc.so:system/lib/libmm-adspsvc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAacDec.so:system/lib/libOmxAacDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAacEnc.so:system/lib/libOmxAacEnc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAdpcmDec.so:system/lib/libOmxAdpcmDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAmrDec.so:system/lib/libOmxAmrDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAmrEnc.so:system/lib/libOmxAmrEnc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAmrRtpDec.so:system/lib/libOmxAmrRtpDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxAmrwbDec.so:system/lib/libOmxAmrwbDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxEvrcDec.so:system/lib/libOmxEvrcDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxEvrcEnc.so:system/lib/libOmxEvrcEnc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxMp3Dec.so:system/lib/libOmxMp3Dec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxQcelp13Enc.so:system/lib/libOmxQcelp13Enc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxQcelpDec.so:system/lib/libOmxQcelpDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxVidEnc.so:system/lib/libOmxVidEnc.so \
    vendor/lge/p500/proprietary/system/lib/libOmxWmaDec.so:system/lib/libOmxWmaDec.so \
    vendor/lge/p500/proprietary/system/lib/libOmxWmvDec.so:system/lib/libOmxWmvDec.so \

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

#    vendor/lge/p500/proprietary/system/lib/libomx_aacdec_sharedlibrary.so:system/lib/libomx_aacdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_amrdec_sharedlibrary.so:system/lib/libomx_amrdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_amrenc_sharedlibrary.so:system/lib/libomx_amrenc_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_avcdec_sharedlibrary.so:system/lib/libomx_avcdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_m4vdec_sharedlibrary.so:system/lib/libomx_m4vdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_mp3dec_sharedlibrary.so:system/lib/libomx_mp3dec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_nextreaming_divxdec_sharedlibrary.so:system/lib/libomx_nextreaming_divxdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_nextreaming_wmadec_sharedlibrary.so:system/lib/libomx_nextreaming_wmadec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_nextreaming_wmvdec_sharedlibrary.so:system/lib/libomx_nextreaming_wmvdec_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libomx_sharedlibrary.so:system/lib/libomx_sharedlibrary.so \
#    vendor/lge/p500/proprietary/system/lib/libopencore_author.so:system/lib/libopencore_author.so \
#    vendor/lge/p500/proprietary/system/lib/libopencore_player.so:system/lib/libopencore_player.so \
#    vendor/lge/p500/proprietary/system/lib/libopencore_mp4local.so:system/lib/libopencore_mp4local.so \
#    vendor/lge/p500/proprietary/system/lib/libopencore_mp4localreg.so:system/lib/libopencore_mp4localreg.so \
#    vendor/lge/p500/proprietary/system/lib/libopencorehw.so:system/lib/libopencorehw.so \

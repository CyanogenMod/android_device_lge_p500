#!/bin/sh

# Copyright (C) 2011 The CyanogenMod Project
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

VENDOR=lge
DEVICE=p500

rm -rf ../../../vendor/$VENDOR/$DEVICE
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/flex
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw

## RIL

adb pull /system/lib/libgstk_exp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libgstk_exp.so
adb pull /system/lib/libqmi.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libqmi.so
adb pull /system/lib/libpbmlib.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libpbmlib.so
adb pull /system/lib/libmmgsdilib.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libmmgsdilib.so
adb pull /system/lib/libril-qcril-hook-oem.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libril-qcril-hook-oem.so
adb pull /system/lib/libdsm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libdsm.so
adb pull /system/lib/liboncrpc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/liboncrpc.so
adb pull /system/lib/libril-qc-qmi-1.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libril-qc-qmi-1.so
adb pull /system/lib/libnv.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libnv.so
adb pull /system/lib/libauth.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libauth.so
adb pull /system/lib/libwms.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libwms.so
adb pull /system/lib/libgsl.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libgsl.so
adb pull /system/lib/libdiag.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libdiag.so
adb pull /system/lib/liboem_rapi.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/liboem_rapi.so
adb pull /system/lib/libgsdi_exp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libgsdi_exp.so
adb pull /system/lib/libril-qc-1.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libril-qc-1.so
adb pull /system/lib/liblgeat.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/liblgeat.so
adb pull /system/lib/libcm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libcm.so
adb pull /system/lib/libqueue.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libqueue.so
adb pull /system/lib/liblgerft.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/liblgerft.so
adb pull /system/lib/libdll.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libdll.so
adb pull /system/lib/libdss.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libdss.so
adb pull /system/lib/libbcmwl.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libbcmwl.so
adb pull /system/lib/libwmsts.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libwmsts.so
adb pull /system/lib/libdsutils.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libdsutils.so
adb pull /system/lib/libidl.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libidl.so
adb pull /system/lib/liblgdrm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/liblgdrm.so
adb pull /system/lib/libsnd.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libsnd.so
adb pull /system/lib/libril.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libril.so
adb pull /system/bin/qmuxd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin/qmuxd
adb pull /system/bin/rild ../../../vendor/$VENDOR/$DEVICE/proprietary/bin/rild
adb pull /system/etc/flex/flex.xml ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/flex/flex.xml

## Audio

adb pull /system/lib/libaudioeq.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libaudioeq.so

## HAL
adb pull /system/lib/hw/sensors.thunderg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw/sensors.thunderg.so
adb pull /system/lib/hw/gralloc.thunderg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw/

## EGL
adb pull /system/lib/egl/libGLESv2_adreno200.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl/libGLESv2_adreno200.so
adb pull /system/lib/egl/libGLESv1_CM_adreno200.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl/libGLESv1_CM_adreno200.so
adb pull /system/lib/egl/libq3dtools_adreno200.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl/libq3dtools_adreno200.so
adb pull /system/lib/egl/libEGL_adreno200.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl/libEGL_adreno200.so
adb pull /system/etc/firmware/yamato_pfp.fw ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/firmware/yamato_pfp.fw
adb pull /system/etc/firmware/yamato_pm4.fw ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/firmware/yamato_pm4.fw
adb pull /system/bin/ami304d ../../../vendor/$VENDOR/$DEVICE/proprietary/bin/ami304d

## Camera
adb pull /system/lib/libcamera.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/liboemcamera.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libmmjpeg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libmmipl.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/

## OMX
adb pull /system/lib/libOmxAacDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAacEnc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAdpcmDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAmrDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAmrEnc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAmrRtpDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxAmrwbDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxEvrcEnc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxEvrcHwDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxH264Dec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxMp3Dec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxMpeg4Dec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxOn2Dec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxQcelp13Enc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxQcelpHwDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxVidEnc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxWmaDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libOmxWmvDec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libmm-adspsvc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/
adb pull /system/lib/libdivxdrmdecrypt.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/

## BT
adb pull /system/etc/firmware/BCM4325D1_004.002.004.0218.0248.hcd ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/firmware/

## Wifi
adb pull /system/etc/wl/rtecdc-apsta.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl/
adb pull /system/etc/wl/rtecdc.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl/

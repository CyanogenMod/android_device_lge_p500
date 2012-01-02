/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "AudioPolicyManager"
//#define LOG_NDEBUG 0
#include <utils/Log.h>
#include "AudioPolicyManager.h"
#include <media/mediarecorder.h>

namespace android {



// ----------------------------------------------------------------------------
// AudioPolicyManager for msm7k platform
// Common audio policy manager code is implemented in AudioPolicyManagerBase class
// ----------------------------------------------------------------------------

// ---  class factory


extern "C" AudioPolicyInterface* createAudioPolicyManager(AudioPolicyClientInterface *clientInterface)
{
    return new AudioPolicyManager(clientInterface);
}

extern "C" void destroyAudioPolicyManager(AudioPolicyInterface *interface)
{
    delete interface;
}

AudioPolicyManager::AudioPolicyManager(AudioPolicyClientInterface *clientInterface)
                : AudioPolicyManagerBase(clientInterface)
{
    mAvailableOutputDevices |= DEVICE_OUT_SPEAKER_IN_CALL;
    mAvailableOutputDevices |= DEVICE_OUT_SPEAKER_RING;  
}

uint32_t AudioPolicyManager::getDeviceForStrategy(routing_strategy strategy, bool fromCache)
{
    uint32_t device = 0;

    if (fromCache) {
        LOGV("getDeviceForStrategy() from cache strategy %d, device %x", strategy, mDeviceForStrategy[strategy]);
        return mDeviceForStrategy[strategy];
    }

    int availableOutputDevices = mAvailableOutputDevices;
    if (availableOutputDevices & AudioSystem::DEVICE_OUT_WIRED_HEADSET) {
        availableOutputDevices |= AudioSystem::DEVICE_OUT_WIRED_HEADPHONE;
    }

    switch (strategy) {
    case STRATEGY_DTMF:
        if (!isInCall()) {
            // when off call, DTMF strategy follows the same rules as MEDIA strategy
            device = getDeviceForStrategy(STRATEGY_MEDIA, false);
            break;
        }
        // when in call, DTMF and PHONE strategies follow the same rules
        // FALL THROUGH

    case STRATEGY_PHONE:
        // for phone strategy, we first consider the forced use and then the available devices by order
        // of priority
        switch (mForceUse[AudioSystem::FOR_COMMUNICATION]) {
        case AudioSystem::FORCE_BT_SCO:
            if (!isInCall() || strategy != STRATEGY_DTMF) {
                device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_SCO_CARKIT;
                if (device) break;
            }
            device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_SCO_HEADSET;
            if (device) break;
            device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_SCO;
            if (device) break;
            // if SCO device is requested but no SCO device is available, fall back to default case
            // FALL THROUGH

        default:    // FORCE_NONE
            device = availableOutputDevices & AudioSystem::DEVICE_OUT_WIRED_HEADPHONE;
            if (device) break;
            device = availableOutputDevices & AudioSystem::DEVICE_OUT_WIRED_HEADSET;
            if (device) break;
#ifdef WITH_A2DP
            // when not in a phone call, phone strategy should route STREAM_VOICE_CALL to A2DP
            if (!isInCall()) {
                device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP;
                if (device) break;
                device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP_HEADPHONES;
                if (device) break;
            }
#endif
            device = availableOutputDevices & AudioSystem::DEVICE_OUT_EARPIECE;
            if (device == 0) {
                LOGE("getDeviceForStrategy() earpiece device not found");
            }
            break;

        case AudioSystem::FORCE_SPEAKER:
            if (!isInCall() || strategy != STRATEGY_DTMF) {
                device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_SCO_CARKIT;
                if (device) break;
            }
#ifdef WITH_A2DP
            // when not in a phone call, phone strategy should route STREAM_VOICE_CALL to
            // A2DP speaker when forcing to speaker output
            if (!isInCall()) {
                device = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP_SPEAKER;
                if (device) break;
            }
#endif
            device = availableOutputDevices & DEVICE_OUT_SPEAKER_IN_CALL;
            if (device) break;

            device = availableOutputDevices & AudioSystem::DEVICE_OUT_SPEAKER;
            if (device == 0) {
                LOGE("getDeviceForStrategy() speaker device not found");
            }
            break;
        }
    break;

    case STRATEGY_SONIFICATION:
    case STRATEGY_MEDIA_SONIFICATION:

        // If incall, just select the STRATEGY_PHONE device: The rest of the behavior is handled by
        // handleIncallSonification().
        if (isInCall()) {
            device = getDeviceForStrategy(STRATEGY_PHONE, false);
            break;
        }
        if (strategy == STRATEGY_SONIFICATION) {
            device = mAvailableOutputDevices & DEVICE_OUT_SPEAKER_RING;
            if (device == 0) {
                LOGE("getDeviceForStrategy() speaker device not found");
            }
        }
        // The second device used for sonification is the same as the device used by media strategy
        // FALL THROUGH

    case STRATEGY_MEDIA: {
#ifdef HAVE_FM_RADIO
        uint32_t device2 = 0;
        if (mForceUse[AudioSystem::FOR_MEDIA] == AudioSystem::FORCE_SPEAKER) {
            device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_SPEAKER;
        }
        if (device2 == 0) {
            device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_AUX_DIGITAL;
        }
#else
        uint32_t device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_AUX_DIGITAL;
#endif
        if (device2 == 0) {
            device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_WIRED_HEADSET;
        }
        if (device2 == 0) {
            device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_WIRED_HEADPHONE;
        }
#ifdef WITH_A2DP
        if (mA2dpOutput != 0) {
            if (strategy == STRATEGY_SONIFICATION && !a2dpUsedForSonification()) {
                break;
            }
            if (device2 == 0) {
                device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP;
            }
            if (device2 == 0) {
                device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP_HEADPHONES;
            }
            if (device2 == 0) {
                device2 = availableOutputDevices & AudioSystem::DEVICE_OUT_BLUETOOTH_A2DP_SPEAKER;
            }
        }
#endif
        if (device2 == 0) {
            device2 = mAvailableOutputDevices & AudioSystem::DEVICE_OUT_SPEAKER;
        }

        // device is DEVICE_OUT_SPEAKER if we come from case STRATEGY_SONIFICATION, 0 otherwise
        device |= device2;
        if (device == 0) {
            LOGE("getDeviceForStrategy() speaker device not found");
        }
        } break;

    default:
        LOGW("getDeviceForStrategy() unknown strategy: %d", strategy);
        break;
    }

    LOGV("getDeviceForStrategy() strategy %d, device %x", strategy, device);
    return device;
}

status_t AudioPolicyManager::setDeviceConnectionState(AudioSystem::audio_devices device,
                                                  AudioSystem::device_connection_state state,
                                                  const char *device_address)
{
#ifdef HAVE_FM_RADIO
    if(!strcmp(device_address,"fm_reset") && AudioSystem::isFmDevice(device)) {
        if(state == AudioSystem::DEVICE_STATE_AVAILABLE) {
            resetFm(device);
            return NO_ERROR;
        } else {
            return NO_ERROR;
        }
    }
#endif

    LOGV("setDeviceConnectionState() device: %x, state %d, address %s", device, state, device_address);

    // connect/disconnect only 1 device at a time
    if (AudioSystem::popCount(device) != 1) return BAD_VALUE;

    if (strlen(device_address) >= MAX_DEVICE_ADDRESS_LEN) {
        LOGE("setDeviceConnectionState() invalid address: %s", device_address);
        return BAD_VALUE;
    }

    // handle output devices
    if (AudioSystem::isOutputDevice(device)) {

#ifndef WITH_A2DP
        if (AudioSystem::isA2dpDevice(device)) {
            LOGE("setDeviceConnectionState() invalid device: %x", device);
            return BAD_VALUE;
        }
#endif

        switch (state)
        {
        // handle output device connection
        case AudioSystem::DEVICE_STATE_AVAILABLE:
            if (mAvailableOutputDevices & device) {
                LOGW("setDeviceConnectionState() device already connected: %x", device);
                return INVALID_OPERATION;
            }
            LOGV("setDeviceConnectionState() connecting device %x", device);

            // register new device as available
            mAvailableOutputDevices |= device;

#ifdef WITH_A2DP
            // handle A2DP device connection
            if (AudioSystem::isA2dpDevice(device)) {
                status_t status = handleA2dpConnection(device, device_address);
                if (status != NO_ERROR) {
                    mAvailableOutputDevices &= ~device;
                    return status;
                }
            } else
#endif
            {
                if (AudioSystem::isBluetoothScoDevice(device)) {
                    LOGV("setDeviceConnectionState() BT SCO  device, address %s", device_address);
                    // keep track of SCO device address
                    mScoDeviceAddress = String8(device_address, MAX_DEVICE_ADDRESS_LEN);
                }
            }
#ifdef HAVE_FM_RADIO
            if (AudioSystem::isFmDevice(device)) {
                AudioOutputDescriptor *hwOutputDesc = mOutputs.valueFor(mHardwareOutput);
                hwOutputDesc->mRefCount[AudioSystem::FM] = 1;
                AudioParameter param = AudioParameter();
                param.addInt(String8(AudioParameter::keyFmOn), mAvailableOutputDevices);
                mpClientInterface->setParameters(mHardwareOutput, param.toString());
            }
#endif
            break;
        // handle output device disconnection
        case AudioSystem::DEVICE_STATE_UNAVAILABLE: {
            if (!(mAvailableOutputDevices & device)) {
                LOGW("setDeviceConnectionState() device not connected: %x", device);
                return INVALID_OPERATION;
            }

            LOGV("setDeviceConnectionState() disconnecting device %x", device);
            // remove device from available output devices
            mAvailableOutputDevices &= ~device;

#ifdef WITH_A2DP
            // handle A2DP device disconnection
            if (AudioSystem::isA2dpDevice(device)) {
                status_t status = handleA2dpDisconnection(device, device_address);
                if (status != NO_ERROR) {
                    mAvailableOutputDevices |= device;
                    return status;
                }
            } else
#endif
            {
                if (AudioSystem::isBluetoothScoDevice(device)) {
                    mScoDeviceAddress = "";
                }
            }
#ifdef HAVE_FM_RADIO
            if (AudioSystem::isFmDevice(device)) {
                AudioOutputDescriptor *hwOutputDesc = mOutputs.valueFor(mHardwareOutput);
                hwOutputDesc->mRefCount[AudioSystem::FM] = 0;
                AudioParameter param = AudioParameter();
                param.addInt(String8(AudioParameter::keyFmOff), mAvailableOutputDevices);
                mpClientInterface->setParameters(mHardwareOutput, param.toString());
            }
#endif
            } break;

        default:
            LOGE("setDeviceConnectionState() invalid state: %x", state);
            return BAD_VALUE;
        }

        // request routing change if necessary
        uint32_t newDevice = getNewDevice(mHardwareOutput, false);
#ifdef WITH_A2DP
        checkOutputForAllStrategies();
        // A2DP outputs must be closed after checkOutputForAllStrategies() is executed
        if (state == AudioSystem::DEVICE_STATE_UNAVAILABLE && AudioSystem::isA2dpDevice(device)) {
            closeA2dpOutputs();
        }
        checkA2dpSuspend();
#endif
        updateDeviceForStrategy();
        setOutputDevice(mHardwareOutput, newDevice);

        if (device == AudioSystem::DEVICE_OUT_WIRED_HEADSET) {
            device = AudioSystem::DEVICE_IN_WIRED_HEADSET;
        } else if (device == AudioSystem::DEVICE_OUT_BLUETOOTH_SCO ||
                   device == AudioSystem::DEVICE_OUT_BLUETOOTH_SCO_HEADSET ||
                   device == AudioSystem::DEVICE_OUT_BLUETOOTH_SCO_CARKIT) {
            device = AudioSystem::DEVICE_IN_BLUETOOTH_SCO_HEADSET;
        } else {
            return NO_ERROR;
        }
    }
    // handle input devices
    if (AudioSystem::isInputDevice(device)) {

        switch (state)
        {
        // handle input device connection
        case AudioSystem::DEVICE_STATE_AVAILABLE: {
            if (mAvailableInputDevices & device) {
                LOGW("setDeviceConnectionState() device already connected: %d", device);
                return INVALID_OPERATION;
            }
            mAvailableInputDevices |= device;
            }
            break;

        // handle input device disconnection
        case AudioSystem::DEVICE_STATE_UNAVAILABLE: {
            if (!(mAvailableInputDevices & device)) {
                LOGW("setDeviceConnectionState() device not connected: %d", device);
                return INVALID_OPERATION;
            }
            mAvailableInputDevices &= ~device;
            } break;

        default:
            LOGE("setDeviceConnectionState() invalid state: %x", state);
            return BAD_VALUE;
        }

        audio_io_handle_t activeInput = getActiveInput();
        if (activeInput != 0) {
            AudioInputDescriptor *inputDesc = mInputs.valueFor(activeInput);
            uint32_t newDevice = getDeviceForInputSource(inputDesc->mInputSource);
            if (newDevice != inputDesc->mDevice) {
                LOGV("setDeviceConnectionState() changing device from %x to %x for input %d",
                        inputDesc->mDevice, newDevice, activeInput);
                inputDesc->mDevice = newDevice;
                AudioParameter param = AudioParameter();
                param.addInt(String8(AudioParameter::keyRouting), (int)newDevice);
                mpClientInterface->setParameters(activeInput, param.toString());
            }
        }

        return NO_ERROR;
    }

    LOGW("setDeviceConnectionState() invalid device: %x", device);
    return BAD_VALUE;
}

#ifdef HAVE_FM_RADIO
void AudioPolicyManager::resetFm(AudioSystem::audio_devices device)
{
    mAvailableOutputDevices |= device;
    AudioOutputDescriptor *hwOutputDesc = mOutputs.valueFor(mHardwareOutput);
    hwOutputDesc->mRefCount[AudioSystem::FM] = 1;
    AudioParameter param = AudioParameter();
    param.addInt(String8(AudioParameter::keyFmOn), mAvailableOutputDevices);
    mpClientInterface->setParameters(mHardwareOutput, param.toString());
    uint32_t newDevice = getNewDevice(mHardwareOutput, false);
    updateDeviceForStrategy();
    setOutputDevice(mHardwareOutput, newDevice);
}
#endif

status_t AudioPolicyManager::checkAndSetVolume(int stream, int index, audio_io_handle_t output, uint32_t device, int delayMs, bool force)
{

    // do not change actual stream volume if the stream is muted
    if (mOutputs.valueFor(output)->mMuteCount[stream] != 0) {
        LOGV("checkAndSetVolume() stream %d muted count %d", stream, mOutputs.valueFor(output)->mMuteCount[stream]);
        return NO_ERROR;
    }

    // do not change in call volume if bluetooth is connected and vice versa
    if ((stream == AudioSystem::VOICE_CALL && mForceUse[AudioSystem::FOR_COMMUNICATION] == AudioSystem::FORCE_BT_SCO) ||
        (stream == AudioSystem::BLUETOOTH_SCO && mForceUse[AudioSystem::FOR_COMMUNICATION] != AudioSystem::FORCE_BT_SCO)) {
        LOGV("checkAndSetVolume() cannot set stream %d volume with force use = %d for comm",
             stream, mForceUse[AudioSystem::FOR_COMMUNICATION]);
        return INVALID_OPERATION;
    }

    float volume = computeVolume(stream, index, output, device);
    // We actually change the volume if:
    // - the float value returned by computeVolume() changed
    // - the force flag is set
    if (volume != mOutputs.valueFor(output)->mCurVolume[stream] || 
            force) {
        mOutputs.valueFor(output)->mCurVolume[stream] = volume;
        LOGV("setStreamVolume() for output %d stream %d, volume %f, delay %d", output, stream, volume, delayMs);
        if (stream == AudioSystem::VOICE_CALL ||
            stream == AudioSystem::DTMF ||
            stream == AudioSystem::BLUETOOTH_SCO) {
            // offset value to reflect actual hardware volume that never reaches 0
            // 1% corresponds roughly to first step in VOICE_CALL stream volume setting (see AudioService.java)
            volume = 0.01 + 0.99 * volume;
        }

        mpClientInterface->setStreamVolume((AudioSystem::stream_type)stream, volume, output, delayMs);
    }

    if (stream == AudioSystem::VOICE_CALL ||
        stream == AudioSystem::BLUETOOTH_SCO) {
        float voiceVolume;
        // Force voice volume to max for bluetooth SCO as volume is managed by the headset
        if (stream == AudioSystem::VOICE_CALL) {
            voiceVolume = (float)index/(float)mStreams[stream].mIndexMax;
        } else {
            voiceVolume = 1.0;
        }
        if (voiceVolume != mLastVoiceVolume && output == mHardwareOutput) {
            mpClientInterface->setVoiceVolume(voiceVolume, delayMs);
            mLastVoiceVolume = voiceVolume;
        }
    }

#ifdef HAVE_FM_RADIO
    float fmVolume = -1.0;
    fmVolume = computeVolume(stream, index, output, device);
    mpClientInterface->setFmVolume(fmVolume, delayMs);
#endif


    return NO_ERROR;
}

}; // namespace android

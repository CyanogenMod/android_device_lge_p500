#!/system/bin/sh

BLUETOOTH_SLEEP_PATH=/proc/bluetooth/sleep/proto
LOG_TAG="qcom-bluetooth"
LOG_NAME="${0}:"

hciattach_pid=""

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

failed ()
{
  loge "$1: exit code $2"
  exit $2
}

start_hciattach ()
{
  echo 1 > $BLUETOOTH_SLEEP_PATH
  /system/bin/hciattach -n /dev/ttyHS0 any 3000000 flow &
  hciattach_pid=$!
  logi "start_hciattach: pid = $hciattach_pid"
}

kill_hciattach ()
{
  logi "kill_hciattach: pid = $hciattach_pid"
  ## careful not to kill zero or null!
  kill -TERM $hciattach_pid
  echo 0 > $BLUETOOTH_SLEEP_PATH
  # this shell doesn't exit now -- wait returns for normal exit
}

/system/bin/brcm_patchram_plus -d --patchram /etc/firmware/BCM4325D1_004.002.004.0218.0248.hcd /dev/ttyHS0
logi "Setting baudrate..."
/system/bin/brcm_patchram_plus -d -baudrate 3000000 /dev/ttyHS0 
exit_code_hci_qcomm_download=$?

case $exit_code_hci_qcomm_download in
  0) logi "Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS";;
  *) failed "Bluetooth QSoC firmware download failed" $exit_code_hci_qcomm_download;;
esac

# init does SIGTERM on ctl.stop for service
trap "kill_hciattach" TERM INT

start_hciattach

# Give hciattach time to settle
sleep 1
logi "Fixing PCM setting..."
/system/xbin/hcitool cmd 0x3f 0x1c 0x00 0x04 0x00 0x00 0x00 || loge "FAILED"
logi "Writing Sleep mode setting..."
/system/xbin/hcitool cmd 0x3f 0x27 0x01 0x01 0x10 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 || loge "FAILED"

wait $hciattach_pid

logi "Bluetooth stopped"

exit 0

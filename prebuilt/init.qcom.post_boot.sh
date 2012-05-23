#!/system/bin/sh

target=`getprop ro.board.platform`
case "$target" in
    "msm7x27")
     # cpufreq ondemand gov
	 #echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	 #echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	 #echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
	 #chown system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	 #echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	 #echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
	 #chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	 #chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	 #chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
     #echo 320000 > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_max_freq
    ;;
esac

usb_config=`getprop persist.sys.usb.config`
case "$usb_config" in
    "") #USB persist config not set, select default configuration
        setprop persist.sys.usb.config mass_storage,adb
    ;;
esac


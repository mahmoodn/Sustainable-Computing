#!/bin/bash

# Run `cpupower frequency-info` to see information about policies
MIN_FREQ=`sudo cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_min_freq`

MAX_FREQ=`sudo cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq`
# cpuinfo_max_freq seems to be the turboboost frequency. So, it may not work.
if [ -f "/sys/devices/system/cpu/cpufreq/policy0/bios_limit" ]; then
  MAX_FREQ=`sudo cat /sys/devices/system/cpu/cpufreq/policy0/bios_limit`
fi
if [ $1 = "powersave" ]; then
  echo "Minimum frequency is $MIN_FREQ Hz"
  sudo cpupower frequency-set -d $MIN_FREQ
  sudo cpupower frequency-set -u $MIN_FREQ
elif [ $1 = "performance" ]; then
  echo "Maximum frequency is $MAX_FREQ Hz"
  sudo cpupower frequency-set -d $MAX_FREQ
  sudo cpupower frequency-set -u $MAX_FREQ
elif [ $1 = "balance" ]; then
  echo "Frequency range is $MIN_FREQ - $MAX_FREQ"
  sudo cpupower frequency-set -d $MIN_FREQ
  sudo cpupower frequency-set -u $MAX_FREQ
else
  echo "Wrong argument. Use powersave or performance or balance"
fi




#!/bin/bash

echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

# reset llc ways
sudo pqos -R

# reset cpu frequency
sudo cpupower frequency-set -d 3.10GHz

# enable hardware prefetcher
sudo wrmsr -a 0x1a4 0

# enable ht by default
echo on | sudo tee /sys/devices/system/cpu/smt/control

# unset LD_PRELOAD
unset LD_PRELOAD
unset IODLR_USE_EXPLICIT_HP

#unset script specific binary and args
unset BIN
unset ARGS

# 4096 hugepages
echo "4096" | sudo tee /proc/sys/vm/nr_hugepages

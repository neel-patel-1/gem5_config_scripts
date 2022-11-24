#!/bin/bash
./default_config.sh

mkdir -p no_hw_preftch_boot_exit
sudo wrmsr -a 0x1a4 f

taskset -c 5 ./run-single1.sh no_hw_preftch_boot_exit

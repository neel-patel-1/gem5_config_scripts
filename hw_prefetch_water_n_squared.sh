#!/bin/bash
./default_config.sh

mkdir -p no_hw_preftch
sudo wrmsr -a 0x1a4 f

taskset -c 5 ./run-single1.sh no_hw_preftch

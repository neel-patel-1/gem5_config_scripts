#!/bin/bash
./default_config.sh

mkdir -p no_hw_preftch_water_n_squared
sudo wrmsr -a 0x1a4 f

taskset -c 5 ./run-single.sh no_hw_preftch_water_n_squared

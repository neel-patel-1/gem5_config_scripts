#!/bin/bash
./default_config.sh

echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

mkdir -p turbo_boost_atomic_parsec

taskset -c 5 ./run-single.sh turbo_boost_atomic_parsec


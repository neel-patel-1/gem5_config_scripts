#!/bin/bash
./default_config.sh

echo off | sudo tee /sys/devices/system/cpu/smt/control

mkdir -p enable_HT_atomic_parsec

taskset -c 5 ./run-single.sh enable_HT_atomic_parsec


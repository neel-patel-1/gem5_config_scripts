#!/bin/bash
./default_config.sh

echo off |  tee /sys/devices/system/cpu/smt/control

mkdir -p disable_HT_atomic_parsec

taskset -c 5 ./run-single.sh disable_HT_atomic_parsec


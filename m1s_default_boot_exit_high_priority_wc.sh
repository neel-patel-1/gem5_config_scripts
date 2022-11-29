#!/bin/bash

mkdir -p m1s_default_atomic_boot_exit_high_priority_wc

sudo nice -n -20 ./run-single1-a.sh m1s_default_atomic_boot_exit_high_priority_wc

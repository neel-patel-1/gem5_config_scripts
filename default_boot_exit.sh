#!/bin/bash
./default_config.sh

mkdir -p default_boot_exit

taskset -c 5 ./run-single1.sh default_boot_exit


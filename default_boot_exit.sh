#!/bin/bash
./default_config.sh

mkdir -p default_minor_boot_exit

taskset -c 5 ./run-single1.sh default_minor_boot_exit


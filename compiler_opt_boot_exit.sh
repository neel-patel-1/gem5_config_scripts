#!/bin/bash

./default_config.sh

mkdir -p compiler_opt_minor_boot_exit

taskset -c 5 ./run-single1.sh compiler_opt_minor_boot_exit

#!/bin/bash
./default_config.sh

mkdir -p default_water_n_squared

taskset -c 5 ./run-single.sh default_water_n_squared


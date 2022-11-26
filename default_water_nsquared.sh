#!/bin/bash
./default_config.sh

mkdir -p default_atomic_water_nsquared

taskset -c 5 ./run-single-wn.sh default_atomic_water_nsquared


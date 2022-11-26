#!/bin/bash
./default_config.sh

mkdir -p default_atomic_ocean_cp

taskset -c 5 ./run-single-oc.sh default_atomic_ocean_cp



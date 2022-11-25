#!/bin/bash
./default_config.sh

mkdir -p default_atomic_ocean_ncp

taskset -c 5 ./run-single-on.sh default_atomic_ocean_ncp


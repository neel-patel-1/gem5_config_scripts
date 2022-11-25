#!/bin/bash
./default_config.sh

mkdir -p default_atomic_water_spatial

taskset -c 5 ./run-single-ws.sh default_atomic_water_spatial


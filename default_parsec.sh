#!/bin/bash
./default_config.sh

mkdir -p default_timing_parsec

taskset -c 5 ./run-single.sh default_timing_parsec


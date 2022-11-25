#!/bin/bash
./default_config.sh

mkdir -p default_atomic_fmm

taskset -c 5 ./run-single-fmm.sh default_atomic_fmm


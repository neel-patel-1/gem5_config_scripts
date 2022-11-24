#!/bin/bash
./default_config.sh

mkdir -p default

taskset -c 5 ./run-single1.sh default


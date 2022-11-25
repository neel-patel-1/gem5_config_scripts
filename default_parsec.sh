#!/bin/bash
./default_config.sh

mkdir -p default_o3_parsec

taskset -c 5 ./run-single.sh default_o3_parsec


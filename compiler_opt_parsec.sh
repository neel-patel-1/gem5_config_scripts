#!/bin/bash

./default_config.sh

mkdir -p compiler_opt_minor_parsec

taskset -c 5 ./run-single.sh compiler_opt_minor_parsec

#!/bin/bash

mkdir -p m1p_default_atomic_parsec_high_priority

sudo nice -n -20 ./run-single-a.sh m1p_default_atomic_parsec_high_priority


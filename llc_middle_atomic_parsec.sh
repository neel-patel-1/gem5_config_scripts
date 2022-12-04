#!/bin/bash
./default_config.sh

# set core 5 to use middle llc way
 pqos -R 
 pqos -e "llc:0=0x0020"
 pqos -a "llc:0=0-10"


taskset -c 5 ./run-single.sh middle_llc_way_atomic_parsec

#!/bin/bash
./default_config.sh

# set core 5 to use middle llc way
sudo pqos -R 
sudo pqos -e "llc:0=0x0020"
sudo pqos -a "llc:0=0-10"


taskset -c 5 ./run-single.sh middle_llc_way_atomic_parsec

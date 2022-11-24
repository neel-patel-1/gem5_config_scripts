#!/bin/bash
./default_config.sh

# set core 5 to use middle llc way
sudo pqos -R 
sudo pqos -e "llc:1=0x020;" 
sudo pqos -a "cos:1=5;" 


taskset -c 5 ./run-single.sh middle_llc_way_atomic_parsec

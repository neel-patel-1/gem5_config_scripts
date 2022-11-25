#!/bin/bash
./default_config.sh

# set core 5 to use last llc way
sudo pqos -R 
sudo pqos -e "llc:1=0x0001;" 
sudo pqos -a "cos:1=5;" 


taskset -c 5 ./run-single1.sh last_llc_way_atomic_boot_exit

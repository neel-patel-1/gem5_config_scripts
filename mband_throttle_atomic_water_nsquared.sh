#!/bin/bash
./default_config.sh

# set core 5 to use last llc way
 pqos -R 
 pqos -e 'mba_max:1=10;'
 pqos -a 'cos:1=5'


taskset -c 5 ./atomic_water_nsquared.sh mband_throttle_10MBs_atomic_water_nsquared

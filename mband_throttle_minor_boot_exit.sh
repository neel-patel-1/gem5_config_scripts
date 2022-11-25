#!/bin/bash
./default_config.sh

[ -z "${1}" ] && echo "No MB/s Specified" && exit

# set core 5 to use last llc way
sudo pqos -R 
sudo pqos -e 'mba_max:1=10;'
sudo pqos -a 'cos:1=5'


taskset -c 5 ./run-single1.sh no_hw_preftch_boot_exit

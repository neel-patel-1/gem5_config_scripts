#!/bin/bash
./default_config.sh


 pqos -R 
 pqos -e 'mba_max:1=10;'
 pqos -a 'cos:1=5'

taskset -c 5 ./run-single1.sh max_mem_10MB_atomic_boot_exit

#!/bin/bash

[ -z "${1}" ] && echo "No Config File Specified -- usage: ./run_all_sim_eff.sh <config_file>" && exit
log=${1}_log

echo -n "" > $log
for i in simulation_efficiency/o3*; do
	echo "./${i} ${1}" | tee -a $log
	./${i} ${1}
done

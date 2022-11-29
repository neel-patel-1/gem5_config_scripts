#!/bin/bash
[ -z "${1}" ] && echo "No Config File Specified -- usage: ./profile_cpus.sh <config_file>" && exit
log=${1}_cpu_log
echo -n "" > $log

for i in runnable_cpu_profile/*; do
	yes | cp app_profiling/$(basename ${i}) ./runnable_cpu_profile #update
	yes | cp ${i} ./ #update
	echo "./$(basename ${i}) ${1} "  | tee -a $log 
	./$(basename ${i}) ${1} | tee -a $log
done
	

#!/bin/bash

[ -z "${1}" ] && echo "No Config File Specified -- usage: ./run_all_bench.sh <config_file>" && exit
log=${1}_log

echo -n "" > $log
for i in runnable/*; do
	yes | cp source_benchs/$(basename ${i}) ${i}
	yes | cp ${i} ./
	echo "./$(basename ${i}) ${1} "  | tee -a $log 
	./$(basename ${i}) ${1} | tee -a $log
done

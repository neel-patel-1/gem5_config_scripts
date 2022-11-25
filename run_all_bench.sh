#!/bin/bash

[ -z "${1}" ] && echo "No Config File Specified -- usage: ./run_all_bench.sh <config_file>" && exit
log=${1}_log

echo -n "" > $log
for i in source_benchs/*; do
	echo "./$(basename ${i}) ${1} | tee -a $log  "
	./$(basename ${i}) ${1} | tee -a $log
done

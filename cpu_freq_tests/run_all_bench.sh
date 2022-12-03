#!/bin/bash

[ -z "${1}" ] && echo "No Config File Specified -- usage: ./cpu_freq_test_all.sh <config_file>" && exit
log=${1}_log

echo -n "" > $log
for i in cpu_freq_tests/*; do
	./${i} | tee -a $log
done

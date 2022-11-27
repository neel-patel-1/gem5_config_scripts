#!/bin/bash


for i in ${1}*/; do
	echo "${i}: "; 
	if [ -f "${i}/stats.txt" ]; then 
		2>/dev/null ./avg_mem.sh ${i}/mem_llc ${i}/stats.txt; 
	else 
		2>/dev/null ./avg_mem.sh ${i}/mem_llc ;  
	fi 
	echo ""
done

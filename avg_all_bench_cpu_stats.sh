#!/bin/bash
ROOT=/home/n869p538/process_cpus

echo "BENCH CPU HOST_SECONDS MEM_BAND_AVG(MB/s) LLC_OCCUPANCY(KB) AVG_IPC AVG_CACHE_MISSES(Thousands)"
for i in ${1}*/; do
	echo -n "${i} " | awk -F_ '{printf("%s%s ", $1,$2) ; for ( i=3; i<=NF; i++) printf("%s", $i);};' 
	if [ -f "${i}/stats.txt" ] && [ ! -z "$(cat ${i}/stats.txt)" ]; then 
		if [ ! -z "$(grep 'hostSeconds' ${i}/stats.txt | awk '{print $2}')" ]; then
			echo -n "$(grep 'hostSeconds' ${i}/stats.txt | awk '{print $2}') "
		fi
		2>/dev/null $ROOT/avg_mem.sh ${i}/mem_llc ${i}/stats.txt; 
	else 
		fd=$( date -d "$(grep TIME ${i}/mem_llc | head -n 1 | awk '{printf("%s %s\n",$2,$3);}')" +%s )
		ld=$( date -d "$(grep TIME ${i}/mem_llc | tail -n 1 | awk '{printf("%s %s\n",$2,$3);}')" +%s )
		echo -n "$(( ${ld} - ${fd} ))"
		2>/dev/null $ROOT/avg_mem.sh ${i}/mem_llc ;  
	fi 
done

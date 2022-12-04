#!/bin/bash

if [ ! -z "${2}" ]; then
	runtime=$( grep hostSeconds ${2} | awk '{print $2}' )
	start_time=$(awk '$1~/TIME/ {printf("%s %s\n", $2, $3); exit;}' ${1})
	max_time=$( date '+%T' --date="$start_time + ${runtime} seconds")
	max_date=$( date '+%Y-%m-%d' --date="$start_time + ${runtime} seconds")

	>&2 echo "monitoring $start_time -- $max_date $max_time using ${2} and ${1}"

	# while < max_date , aggregate ++ update max 
	awk -v max_date="$max_date" -v max_time="${max_time}" '$0~/NOTE/{n=NR+7} NR<n{next} $1~/TIME/ && ($2 > max_date || $3 > max_time) {printf("%f %f %f %f \n", msum/ml, lsum/ll, ipcsum/il, cmsum/cl ); exit } $1~/[0-9][0-9][0-9]+/{msum+=$6; ml+=1; lsum+=$5; ll+=1; ipcsum+=$3; il+=1; cmsum+=$4; cl+=1;} END{printf("%f %f %f %f \n", msum/ml, lsum/ll, ipcsum/il, cmsum/cl ); exit }' ${1}
else
	awk -v max_date="$max_date" -v max_time="${max_time}" '$0~/NOTE/{n=NR+7} NR<n{next} END {printf("%f %f %f %f \n", msum/ml, lsum/ll, ipcsum/il, cmsum/cl ); exit } $1~/[0-9][0-9][0-9]+/{msum+=$6; ml+=1; lsum+=$5; ll+=1; ipcsum+=$3; il+=1; cmsum+=$4; cl+=1;} END{printf("%f %f %f %f \n", msum/ml, lsum/ll, ipcsum/il, cmsum/cl ); exit }' ${1}
fi

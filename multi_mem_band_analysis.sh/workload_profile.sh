#!/bin/bash

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=${OUTDIR}_workload_monitor
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1

#1 - proc to monitor cpu utilization
cpu_mon(){
	while [ "1" ]; do
		time=$(printf '%(%H:%M:%S)T')
		cpu_util=$( top -b -n 1 -p ${1} | grep -A2 PID )
		echo "${time}" >> $OUTDIR/cpu_util
		echo "${cpu_util}" >> $OUTDIR/cpu_util
		sleep 0.1
	done

}

#1 - proc to monitor memory bandwidth of
spec_mon(){
	while [ "1" ] ; do
		 pqos -t 1 -i 1 -I -p "mbl:${1};llc:${1}" >> $OUTDIR/mem_llc
	done
}

mkdir -p $OUTDIR
rm -f $OUTDIR/*

 pqos -R 

${BIN} ${ARGS} &
w_pid=$!

spec_mon  ${w_pid} &
s_pid=$!

cpu_mon ${w_pid} &
c_pid=$!

wait $w_pid

 kill -KILL $s_pid
 kill -KILL $c_pid

echo "output directory:${OUTDIR}"

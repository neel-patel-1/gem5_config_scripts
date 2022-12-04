#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/gem5_library/x86-parsec-benchmarks.py

export VTUNE_WAIT=$(( 60  ))
export MON_DELAY=$(( 10 ))

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$BENCH" ] && echo "No BENCHMARK provided {eg. raytrace}" && exit -1
[ -z "$SIZE" ] && echo "No Size provided {eg. simsmall}" && exit -1
OUTDIR=fs_o3_res/${BENCH}_${SIZE}
#BENCHMARK

pqos -I -R mbaCtrl-on

spec_mon(){
	while [ "1" ] ; do
		echo "monitoring ${w_pid}" >> $OUTDIR/mem_llc
		pqos -t 1 -i 1 -I -p all:${w_pid} >> $OUTDIR/mem_llc
	done
}

taskset -c 5 $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
					--benchmark ${BENCH} \
					--size ${SIZE} &

export w_pid=$!

echo "1)monitoring ${w_pid}" | tee $OUTDIR/mem_llc
spec_mon  &
s_pid=$!

wait $w_pid

kill -KILL $s_pid

echo "output directory:${OUTDIR}" 

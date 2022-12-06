#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/gem5_library/x86-o3-parsec-benchmarks.py

export VTUNE_WAIT=$(( 60  ))
export MON_DELAY=$(( 10 ))

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$BENCH" ] && echo "No BENCHMARK provided {eg. raytrace}" && exit -1
[ -z "$SIZE" ] && echo "No Size provided {eg. simsmall}" && exit -1
OUTDIR=se_fs_sys_comparison/${OUTDIR}_o3_fs_gem5_monitoring
#BENCHMARK

spec_mon(){
	while [ "1" ] ; do
		echo "monitoring ${w_pid}" >> $OUTDIR/mem_llc
		pqos -t 1 -i 1 -I -p all:${w_pid} >> $OUTDIR/mem_llc
	done
}

taskset -c 5 $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
					--benchmark ${BENCH} \
					--size ${SIZE} |& tee ${OUTDIR}/output.txt  &

export w_pid=$!

echo "" > ${OUTDIR}/mem_llc
spec_mon  ${w_pid} &
s_pid=$!

perf stat -p ${w_pid} \
	-e 'LLC-load-misses' \
	-e 'LLC-loads' \
	-e 'LLC-store-misses' \
	-e 'LLC-stores' \
	-o ${OUTDIR}/LLC_Stats.txt

wait $w_pid

kill -KILL $s_pid

echo "output directory:${OUTDIR}" 

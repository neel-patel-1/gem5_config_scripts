#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=se_fs_sys_comparison/${OUTDIR}_o3cpu_gem5_monitoring
#CheckPoint=${RESTORE_CPOINT}/
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
[ -z "$MAXTIME" ] && echo "No MAX Hosttime Specified" && exit -1

mkdir -p $OUTDIR
#1 - proc to monitor memory bandwidth of
spec_mon(){
	while [ "1" ] ; do
		 pqos -t 1 -i 1 -I -p "mbl:${1};llc:${1}" >> $OUTDIR/mem_llc
	done
}


pqos -R 

taskset -c 5 $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
                    --cpu-type=O3CPU	\
                    --num-cpus=4               \
					--mem-channels=1			\
					--cpu-clock=4GHz			    \
					--sys-clock=4GHz			    \
					--mem-type=DDR3_1600_8x8	\
					--mem-channels=1		    \
					--mem-size=2GB				\
					--caches					\
					--l1i_size=32kB				\
					--l1i_assoc=2				\
					--l1d_size=64kB				\
					--l1d_assoc=2				\
					--l2_size=2MB				\
					--l2_assoc=16				\
					--bp-type=BiModeBP			\
					--bp-type=BiModeBP			\
					--cmd=${BIN}			\
					--maxtime=${MAXTIME}			\
					--options="${ARGS}" &
w_pid=$!

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
 kill -KILL $c_pid

echo "output directory:${OUTDIR}"

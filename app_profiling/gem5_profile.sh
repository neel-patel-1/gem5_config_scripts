#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/workload_mon_cpoint

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=${OUTDIR}_atomicpu_gem5_monitoring
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1

mkdir -p $OUTDIR
rm -f $OUTDIR/*

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
		sudo pqos -t 1 -i 1 -I -p "mbl:${1};llc:${1}" >> $OUTDIR/mem_llc
	done
}


sudo pqos -R 

taskset -c 5 $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
                    --cpu-type=AtomicSimpleCPU	\
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
					--checkpoint-dir=$CheckPoint \
					--cmd=${BIN}			\
					--rel-max-tick=${SIM_TICKS}  \
					--options="${ARGS}" &
w_pid=$!

spec_mon  ${w_pid} &
s_pid=$!

cpu_mon ${w_pid} &
c_pid=$!

wait $w_pid

sudo kill -KILL $s_pid
sudo kill -KILL $c_pid

echo "output directory:${OUTDIR}"

#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/workload_mon_cpoint
CORES=( "1" )
W_PIDS=( )
C_PIDS=( )

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=${OUTDIR}_atomicpu_5_instance_single_way_gem5_monitoring
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
[ -z "$MAXTIME" ] && echo "No MAX Hosttime Specified" && exit -1

mkdir -p $OUTDIR
rm -rf $OUTDIR/*

#1 - proc to monitor cpu utilization
cpu_mon(){
	while [ "1" ]; do
		time=$(printf '%(%H:%M:%S)T')
		cpu_util=$( top -b -n 1 -p ${1} | grep -A2 PID )
		echo "${time}" >> $OUTDIR/cpu_util_${1}
		echo "${cpu_util}" >> $OUTDIR/cpu_util_${1}
		sleep 0.1
	done

}

#1 - proc to monitor memory bandwidth of
spec_mon(){
	while [ "1" ] ; do
		sudo pqos -t 1 -i 1 -I -p "mbl:${1};llc:${1}" >> $OUTDIR/mem_llc_${1}
	done
}


# limit 5 gemt's to 1st LLC Way
sudo pqos -R 
#sudo pqos -a "cos:0=1-5;" 
#sudo pqos -e "llc:0=0x001;" 

for core in "${CORES[@]}"; do
	taskset -c ${core} \
		$GEM5_EXE --outdir=${OUTDIR}_$core $SE_PATH 	\
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
						--maxtime=${MAXTIME}			\
						--options="${ARGS}" &
	w_pid=$!
	W_PIDS+=( "${w_pid}" )

	spec_mon  ${w_pid} &
	s_pid=$!
	S_PIDS+=( "${s_pid}" )

	cpu_mon ${w_pid} &
	c_pid=$!
	C_PIDS+=( "${c_pid}" )
done

wait ${W_PIDS[*]}

xargs sudo kill -KILL ${S_PIDS[*]}
xargs sudo kill -KILL ${C_PIDS[*]}

echo "output directory:${OUTDIR}"

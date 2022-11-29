#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
RESTORE=$(pwd)/atomic_cpoint

export VTUNE_WAIT=$(( 10 * 60 ))
#CORES=( "1" "2" "3" "4" "5"  )
CORES=( "1" )
W_PIDS=( )
C_PIDS=( )

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
[ -z "$MAXTIME" ] && echo "No MAX Hosttime Specified" && exit -1
OUTDIR=${OUTDIR}_vtune_atomic

mkdir -p $OUTDIR
[ -d "$OUTDIR" ] &&  rm -rf $OUTDIR/*

for core in "${CORES[@]}"; do
	taskset -c ${core} $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
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
						--cmd=${BIN}			\
						--maxtime=3600			\
						--options="${ARGS}" &
	w_pid=$!
	W_PIDS+=( "${w_pid}" )
done

#start vtune analysis

for i in ${W_PIDS[@]};
do
	VT_PIDSTR+="--target-pid $i "
done

echo ${W_PIDS[*]} 

./bg_killer.sh ${W_PIDS[@]} &

 vtune -collect-with runsa -result-dir $OUTDIR/VTUNE -knob event-config=MEM_LOAD_RETIRED.FB_HIT_PS,MEM_LOAD_RETIRED.FB_HIT,MEM_LOAD_RETIRED.L1_MISS,MEM_LOAD_RETIRED.L1_HIT,MEM_LOAD_RETIRED.L1_MISS_PS,MEM_LOAD_RETIRED.L1_HIT_PS,MEM_LOAD_RETIRED.L2_MISS,MEM_LOAD_RETIRED.L2_HIT,MEM_LOAD_RETIRED.L2_MISS_PS,MEM_LOAD_RETIRED.L2_HIT_PS,MEM_LOAD_RETIRED.L3_MISS,MEM_LOAD_RETIRED.L3_HIT,MEM_LOAD_RETIRED.L3_MISS_PS,MEM_LOAD_RETIRED.L3_HIT_PS,DTLB_LOAD_MISSES.ANY,ITLB_MISSES.ANY \
	-knob collectMemBandwidth=false -knob dram-bandwidth-limits=false -knob collectMemObjects=false \
	-call-stack-mode all \
	${VT_PIDSTR}
 vtune -format=csv -report hw-events -group-by function -r $OUTDIR/VTUNE > $OUTDIR/VTUNE_RES.csv
scp $OUTDIR/VTUNE_RES.csv mercs:~/$(printf '%(%H:%M:%S_%d-%m-%Y)T')_VTUNE_RES.csv

wait ${W_PIDS[*]}


echo "output directory:${OUTDIR}"

#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
#RESTORE=$(pwd)/atomic_cpoint 
export VTUNE_WAIT=$(( 600  ))
export MON_DELAY=$(( 10 ))
#CORES=( "1" "2" "3" "4" "5"  )
CORES=( "1" )

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
[ -z "$MAXTIME" ] && echo "No MAX Hosttime Specified" && exit -1
OUTDIR=${OUTDIR}_vtune_o3

mkdir -p $OUTDIR
[ -d "$OUTDIR" ] &&  rm -rf $OUTDIR/*

for core in "${CORES[@]}"; do
	taskset -c ${core} $GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
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
						--maxtime=3600			\
						--options="${ARGS}" &
	w_pid=$!
	W_PIDS+=( "${w_pid}" )
done

#start vtune analysis 
for i in ${W_PIDS[@]};
do
	VT_PIDSTR+="--pid $i "
done

echo ${W_PIDS[*]} 

sleep $MON_DELAY

./bg_killer.sh ${W_PIDS[@]} &

EVENTS_A=dtlb_load_misses.stlb_hit,dtlb_load_misses.miss_causes_a_walk,dtlb_store_misses.stlb_hit,dtlb_store_misses.miss_causes_a_walk,iTLB-load-misses,iTLB-loads
EVENTS_B=mem_load_retired.fb_hit,mem_load_retired.l1_miss,mem_load_retired.l1_hit,mem_load_retired.l2_miss,mem_load_retired.l2_hit,mem_load_retired.l3_miss,mem_load_retired.l3_hit
EVENTS_C=ITLB_MISSES.MISS_CAUSES_A_WALK,ITLB_MISSES.STLB_HIT,ITLB_MISSES.WALK_ACTIVE,ITLB_MISSES.WALK_COMPLETED,ITLB_MISSES.WALK_COMPLETED_1G,ITLB_MISSES.WALK_COMPLETED_2M_4M,ITLB_MISSES.WALK_COMPLETED_4K,ITLB_MISSES.WALK_PENDING,FRONTEND_RETIRED.ITLB_MISS,ITLB.ITLB_FLUSH

perf record -e "$EVENTS_A,$EVENTS_B,$EVENTS_C" ${VT_PIDSTR} -o ${OUTDIR}/perf.data
perf report -f -s sample ${OUTDIR}/perf.data >  ${OUTDIR}/events.txt


wait ${W_PIDS[*]}


echo "output directory:${OUTDIR}"

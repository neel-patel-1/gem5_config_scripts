#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py

export VTUNE_WAIT=$(( 60  ))
export MON_DELAY=$(( 10 ))

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=simeff/${OUTDIR}_perf_simeff_tb
CheckPoint=${RESTORE_CPOINT}/
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
#BENCHMARK

echo "0" |  tee /sys/devices/system/cpu/intel_pstate/no_turbo

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
					--checkpoint-dir=${CheckPoint} \
					--checkpoint-restore=3 \
					--cmd=${BIN}			\
					--rel-max-tick=${SIM_TICKS}  \
					--options="${ARGS}" &

w_pid=$!
W_PIDS+=( "${w_pid}" )

for i in ${W_PIDS[@]};
do
	VT_PIDSTR+="--pid $i "
done
echo "output directory:${OUTDIR}" 
./bg_killer.sh ${W_PIDS[@]} &

EVENTS_A=dtlb_load_misses.stlb_hit,dtlb_load_misses.miss_causes_a_walk,dtlb_store_misses.stlb_hit,dtlb_store_misses.miss_causes_a_walk
EVENTS_B=mem_load_retired.fb_hit,mem_load_retired.l1_miss,mem_load_retired.l1_hit,mem_load_retired.l2_miss
EVENTS_C=ITLB_MISSES.MISS_CAUSES_A_WALK,ITLB_MISSES.STLB_HIT,ITLB_MISSES.WALK_ACTIVE,ITLB_MISSES.WALK_COMPLETED

EVENTS_A=dtlb_load_misses.walk_active,dtlb_load_misses.walk_pending,itlb_misses.walk_active
perf record -e "cpu-cycles,$EVENTS_A" ${VT_PIDSTR} -o ${OUTDIR}/perf.data
wait ${W_PIDS[*]}
perf report -f -s sample ${OUTDIR}/perf.data >  ${OUTDIR}/events.txt


echo "output directory:${OUTDIR}"

#!/bin/bash
GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py

export VTUNE_WAIT=$(( 60  ))
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
OUTDIR=simeff/${OUTDIR}_test_perf

mkdir -p $OUTDIR

for core in "${CORES[@]}"; do
	taskset -c ${core} stress-ng --vm 1 --vm-bytes=2m --vm-keep  &
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



EVENTS_A=dtlb_load_misses.walk_active,dtlb_load_misses.walk_pending,itlb_misses.walk_active
perf record -e "cpu-cycles,$EVENTS_A" ${VT_PIDSTR} -o ${OUTDIR}/perf.data &
w_pid=$!
W_PIDS+=( "${w_pid}" )
./bg_killer.sh ${W_PIDS[@]} &
wait ${W_PIDS[*]}
perf report -f -s sample ${OUTDIR}/perf.data >  ${OUTDIR}/events.txt


echo "output directory:${OUTDIR}"

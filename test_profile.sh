#!/bin/bash
VTUNE_WAIT=5
CORES=( "1" "2" "3" "4" "5"  )
W_PIDS=( )
C_PIDS=( )

OUTDIR=TEST_VTUNE_RES
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
		sleep 100 &
	w_pid=$!
	W_PIDS+=( "${w_pid}" )

	spec_mon  ${w_pid} &
	s_pid=$!
	S_PIDS+=( "${s_pid}" )

	cpu_mon ${w_pid} &
	c_pid=$!
	C_PIDS+=( "${c_pid}" )
done

echo "top_pids: ${C_PIDS[*]}"
echo "mon_pids: ${S_PIDS[*]}"

#start vtune analysis
sleep $VTUNE_WAIT
sudo vtune -collect-with runsa -result-dir $OUTDIR -knob event-config=MEM_LOAD_RETIRED.FB_HIT_PS,MEM_LOAD_RETIRED.FB_HIT,MEM_LOAD_RETIRED.L1_MISS,MEM_LOAD_RETIRED.L1_HIT,MEM_LOAD_RETIRED.L1_MISS_PS,MEM_LOAD_RETIRED.L1_HIT_PS,MEM_LOAD_RETIRED.L2_MISS,MEM_LOAD_RETIRED.L2_HIT,MEM_LOAD_RETIRED.L2_MISS_PS,MEM_LOAD_RETIRED.L2_HIT_PS,MEM_LOAD_RETIRED.L3_MISS,MEM_LOAD_RETIRED.L3_HIT,MEM_LOAD_RETIRED.L3_MISS_PS,MEM_LOAD_RETIRED.L3_HIT_PS,DTLB_LOAD_MISSES.ANY,ITLB_MISSES.ANY\
	-knob collectMemBandwidth=false -knob dram-bandwidth-limits=false -knob collectMemObjects=false \
	-call-stack-mode all \
	$NGINX_PIDS

wait ${W_PIDS[*]}

xargs sudo kill -KILL ${S_PIDS[*]}
xargs sudo kill -KILL ${C_PIDS[*]}

echo "output directory:${OUTDIR}"

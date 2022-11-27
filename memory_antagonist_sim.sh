#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_mcf_r_test

source ./default_config.sh
#export BIN=/opt/shared/microbench/MI/bench
#export ARGS=" "
#export OUTDIR=MI_bench
#export BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/519.lbm_r/build/build_base_mytest-m64.0000/lbm_r
#export ARGS="3000 /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/519.lbm_r/run/run_base_refrate_mytest-m64.0000/reference.dat 0 0 /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/519.lbm_r/run/run_base_refrate_mytest-m64.0000/100_100_130_ldc.of"
export BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/build/build_base_mytest-m64.0000/mcf_r
export ARGS="/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0000/inp.in"
export OUTDIR=spec_mcf_hugepage_data_segment
export SIM_TICKS=$(( 50500000000 * 45  ))  # 1h for MCF_R default

export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc/bin/streamcluster
export ARGS="10 20 128 16384 16384 1000 none output.txt 4"
export OUTDIR=parsec_streamcluster_largeinput_4tds
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length


#1 - process to monitor memory bandwidth of
spec_mon(){
	OF=gem5_${1}.mem
	rm -f gem5_${1}.mem
	sudo pqos -i 1 -I -p "mbl:${1};llc:${1}" -o gem5_${1}.mem >/dev/null
}

#BENCHMARK
sudo pqos -I -R mbaCtrl-on
sudo pqos -I -a "cos:3=5;" 
#sudo pqos -I -e "mba_max:3=10" 
sudo pqos -I -e "llc:3=0x001" 
#sudo pqos -I -e "l2:3=0x1" 

#sudo pqos -R 
#sudo pqos -e 'mba_max:1=10;'
#sudo pqos -a 'cos:1=5'


#sudo rdtset --iface-os -t 'mba_max=10;cpu=5' -c 5 \
#sudo rdtset --iface-os -t 'l3=0x1;cpu=5' -r 5 -c 5 \
taskset -c 5 \
$GEM5_EXE --outdir=${OUTDIR} $SE_PATH 	\
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
				--options="${ARGS}"

#sudo pqos -I -a "pid:0=$pid" 
#sudo pqos -i 1 -I -p "mbl:$pid;llc:$pid" -o gem5_pid.mem >/dev/null
#sudo pqos -i 1 -I -m "mbl:[0-39];llc:[0-39]" -o system_pqos_llc.mem >/dev/null
#sudo pqos -i 1 -I -m "mbl:5,25;llc:5,25" -o gem5_core.mem >/dev/null

echo "output directory:${OUTDIR}"

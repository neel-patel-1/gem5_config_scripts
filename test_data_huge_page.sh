#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_mcf_r_test

source ./default_config.sh
SIM_TICKS=55000000000
export BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/build/build_base_mytest-m64.0000/mcf_r
#export BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/519.lbm_r/build/build_base_mytest-m64.0000/lbm_r
export ARGS="/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0000/inp.in"
#export ARGS="3000 /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/519.lbm_r/run/run_base_refrate_mytest-m64.0000/reference.dat 0 0 100_100_130_ldc.of"
export OUTDIR=spec_mcf_hugepage_data_segment
export SIM_TICKS=$(( 50500000000  ))  # 1h for MCF_R default

#BENCHMARK
sudo pqos -I -R mbaCtrl-on
sudo pqos -I -e "llc:0=0x001" 
sudo pqos -I -a "cos:0=[5];" 
sudo pqos -I -e "mba_max:0=10" 


export LD_PRELOAD=/usr/lib/libhugetlbfs.so
[ "$?" != 0 ] && echo "LD_PRELOAD unset" && exit -1

sudo LD_PRELOAD=/usr/lib/libhugetlbfs.so \
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

pid=$(pgrep gem5)
sudo pqos -I -a "pid:0=$pid" 
sudo pqos -i 1 -I -p "mbl:[$pid];llc:[$pid]" -o gem5.mem >/dev/null
#sudo pqos -i 1 -I -m "mbl:[5];llc:[5]" -o gem5.mem >/dev/null

echo "output directory:${OUTDIR}"

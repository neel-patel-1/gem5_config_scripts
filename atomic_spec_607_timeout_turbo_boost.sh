#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_cactuBSSN_s_r_test

#BENCHMARK

OUTDIR=spec_cactuBSSN_s_default_atomic_timeout_w_turbo_boost
SPEC_BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/607.cactuBSSN_s/build/build_base_mytest-m64.0000/cactuBSSN_s
SPEC_ARGS="/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/607.cactuBSSN_s/run/run_base_refspeed_mytest-m64.0000/spec_ref.par "
[ ! -f "${SPEC_BIN}" ] && echo "no spec bin" && exit

./default_config.sh

echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

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
					--cmd=${SPEC_BIN}			\
					--rel-max-tick=50500000000  \
					--options="${SPEC_ARGS}"


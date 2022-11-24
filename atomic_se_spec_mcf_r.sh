#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_mcf_r_test

#BENCHMARK
RUNCPU=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/bin/runcpu
SPEC_CONF=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/spec_conf/testConfig.cfg
PARMS=" --iterations=1 --config=${SPEC_CONF}/../../../spec_conf/testConfig.cfg --copies=1 "
EXE=${RUNCPU}
SPEC_BIN="/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0000/mcf_r_base.mytest-m64 "
SPEC_ARGS="inp.in  > inp.out 2>> inp.err"

OUTDIR=spec_mcf_default

$GEM5_EXE --outdir=${OUTDIR} $SE_PATH 			\
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
					--options="${SPEC_ARGS}"


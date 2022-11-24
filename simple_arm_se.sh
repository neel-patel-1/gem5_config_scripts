#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_mcf_r_test

#BENCHMARK
RUNCPU=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/bin/runcpu
SPEC_CONF=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/spec_conf/testConfig.cfg
PARMS=" --iterations=1 --config=${SPEC_CONF}/../../../spec_conf/testConfig.cfg --copies=1 "

EXE="${RUNCPU} "


OUTDIR=spec_mcf_default

NNODES=2


$GEM5_EXE --outdir=${OUTDIR} $SE_PATH --cpu-type=TimingSimpleCPU --l1d_size=64kB --l1i_size=16kB --cmd=${EXE}


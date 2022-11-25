#!/bin/bash

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt

SE_PATH=/opt/shared/gem5-learning/gem5/configs/example/se.py
CheckPoint=$(pwd)/spec_mcf_r_test

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ./default_config.sh
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=${OUTDIR}_transparent_hp
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
OUTDIR=${OUTDIR}_explicit_huge_txt_${SIM_TICKS}_simticks
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1
#BENCHMARK



export IODLR_USE_EXPLICIT_HP=1
[ "$?" != 0 ] && echo "Could not set IODLR to use explicit HPs" && exit -1
export LD_PRELOAD=/usr/lib64/liblppreload.so
[ "$?" != 0 ] && echo "LD_PRELOAD unset" && exit -1

sudo LD_PRELOAD=/usr/lib64/liblppreload.so \
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
					--rel-max-tick=50500000000  \
					--options="${ARGS}"

echo "output directory:${OUTDIR}"

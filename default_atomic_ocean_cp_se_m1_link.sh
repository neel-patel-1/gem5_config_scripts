#!/bin/bash

#./default_config.sh

GEM5_DIR=$(pwd)/../gem5
GEM5_EXE=$GEM5_DIR/build/X86/gem5.opt
#BIN=${GEM5_DIR}/tests/test-progs/hello/bin/x86/linux/hello
BIN=$(pwd)/ocean_cp
SE_PATH=$(pwd)/../gem5/configs/example/se.py
ARGS="-n258 -p1 -e1e-07 -r20000 -t28800"

mkdir m1s_default_atomic_ocean_ncp_se

OUTDIR=m1s_default_atomic_ocean_ncp_se


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
					--interp-dir $(pwd)/x86_root 			\
					--redirects /lib64=$(pwd)/x86_root/lib64 \
					--redirects /lib=$(pwd)/x86_root/lib \
					--cmd=${BIN}		\
					--options="-n258 -p1 -e1e-07 -r20000 -t28800"
					#--input=input_1
echo "output directory:${OUTDIR}"

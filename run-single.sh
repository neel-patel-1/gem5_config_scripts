#!/bin/bash


GEM5_DIR=$(pwd)/../gem5

IMG=$(pwd)/../resources/rootfs.ext2
VMLINUX=$(pwd)/../resources/vmlinux
Bootld=$(pwd)/../resources/boot.arm64
CheckPoint=$(pwd)/m5out
OutputDir=${1}

FS_CONFIG=$(pwd)/armFS.py
GEM5_EXE=$GEM5_DIR/build/ARM/gem5.opt

#SCRIPT=$(pwd)/rcS/single/hack_back_ckpt1.rcS
SCRIPT=$(pwd)/rcS/single/test_progs/run_water_nsquared.sh
NNODES=2

$GEM5_EXE --outdir=$OutputDir $FS_CONFIG\
                    --kernel=$VMLINUX           		\
                    --disk=$IMG                 		\
                    --bootscript=$SCRIPT        		\
                    --bootloader=$Bootld 			\
                    --cpu=atomic				\
                    --num-cores=4                               \
		    --checkpoint_dir=$CheckPoint		\
		    --restore

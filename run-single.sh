#!/bin/bash


GEM5_DIR=$(pwd)/../gem5

IMG=$(pwd)/../resources/rootfs.ext2
VMLINUX=$(pwd)/../resources/vmlinux
Bootld=$(pwd)/../resources/boot.arm64
CheckPoint=m5out
OutputDir=$(pwd)/benchmark_stats/m5out_water_nsquared_o3_hugepages

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
                    --cpu=o3				\
                    --num-cores=4                               \
		    --checkpoint_dir=$CheckPoint		\
		    --restore

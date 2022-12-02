#!/bin/bash

[ -z "$1" ] && echo "No Source Config File Provided" && exit -1
source ${1}
[ -z "$OUTDIR" ] && echo "No OUTPUT DIRECTORY Provided" && exit -1
OUTDIR=simeff/${OUTDIR}
CheckPoint=${RESTORE_CPOINT}/
[ -z "$BIN" ] && echo "No Binary Provided" && exit -1
[ -z "$SIM_TICKS" ] && echo "No SIM_TICKS SPECIFIED" && exit -1 
[ -z "$ARGS" ] && echo "No Binary ARGUMENTS" && exit -1

for i in "$( ls -1 ${OUTDIR}*/stats.txt )"; do
	echo $i;
done
#BENCHMARK

echo "output directory:${OUTDIR}" 

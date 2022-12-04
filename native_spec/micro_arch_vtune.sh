#!/bin/bash
VTUNE=/opt/intel/oneapi/vtune/2022.4.1/bin64/vtune

[ ! -f "$1" ] && echo "specify application start script" && exit

outdir=./native_res/$( basename ${1})_vtune$(printf '%(%H-%M-%S_%d-%m-%Y)T')

$VTUNE -collect uarch-exploration \
	-result-dir ${outdir} \
	-knob collect-frontend-bound=true \
	-knob collect-bad-speculation=true \
	-knob collect-memory-bound=true \
	-knob collect-core-bound=true \
	-knob collect-retiring=true \
	-knob collect-memory-bandwidth=true \
	-knob pmu-collection-mode=summary \
	-- \
	${1} 

$VTUNE -report summary -format=text -r $outdir | tee $outdir/summary

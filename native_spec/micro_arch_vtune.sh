#!/bin/bash
VTUNE=/opt/intel/oneapi/vtune/2022.4.1/bin64/vtune

[ ! -f "$1" ] && echo "specify application start script" && exit
[ ! -f "$2" ] && echo "specify an output directory" && exit

$VTUNE -collect uarch-exploration \
	-result-dir native_res/${1}_vtune$(printf '%(%H:%M:%S_%d-%m-%Y)T') \
	-knob collect-frontend-bound=true \
	-knob collect-bad-speculation=true \
	-knob collect-memory-bound=true \
	-knob collect-core-bound=true \
	-knob collect-retiring=true \
	-knob collect-memory-bandwidth=true \
	-knob pmu-collection-mode=summary \
	-- \
	${1}

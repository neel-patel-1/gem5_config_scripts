#!/bin/bash

for i in `seq 1 40`; do
	{ time /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0008/mcf_r_base.mytest-m64 /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0008/inp.in  > inp.out 2>> inp.err ; } 2>>mcf_times.txt &
done

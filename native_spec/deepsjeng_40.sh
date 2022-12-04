#!/bin/bash

for i in `seq 1 40`; do
	{ time /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/531.deepsjeng_r/build/build_base_mytest-m64.0000/deepsjeng_r /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/531.deepsjeng_r/run/run_base_refrate_mytest-m64.0000/ref.txt > ref.out 2>> ref.err ;  } 2>>native_res/deepsjeng_times.txt &
done
wait

#!/bin/bash

for i in `seq 1 40`; do
	{ time /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/525.x264_r/build/build_base_mytest-m64.0000/x264_r --pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/525.x264_r/run/run_base_refrate_mytest-m64.0000/BuckBunny_New.264 /home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/525.x264_r/run/run_base_refrate_mytest-m64.0000/BuckBunny.yuv 1280x720 > run_000-1000_x264_r_base.mytest-m64_x264_pass1.out 2>> run_000-1000_x264_r_base.mytest-m64_x264_pass1.err ; } 2>>native_res/x264_times.txt &
done
wait

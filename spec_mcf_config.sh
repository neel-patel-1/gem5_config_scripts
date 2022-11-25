
export BIN=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/build/build_base_mytest-m64.0000/mcf_r
export ARGS="/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/benchspec/CPU/505.mcf_r/run/run_base_refrate_mytest-m64.0000/inp.in"
export OUTDIR=spec_mcf
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # 1h for MCF_R default


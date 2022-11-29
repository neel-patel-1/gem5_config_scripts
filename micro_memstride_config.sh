
export BIN=/opt/shared/microbench/MI/bench
export ARGS=" "
export OUTDIR=MI_bench
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # 1h for MCF_R default


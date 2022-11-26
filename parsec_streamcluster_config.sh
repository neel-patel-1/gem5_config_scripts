
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc/bin/streamcluster
export ARGS="2 5 1 10 10 5 none output.txt 1"
export OUTDIR=parsec_streamcluster
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # 1h for MCF_R default



export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc/bin/streamcluster
export ARGS="10 20 128 16384 16384 1000 none output.txt 4"
export OUTDIR=parsec_streamcluster_largeinput_4tds
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length


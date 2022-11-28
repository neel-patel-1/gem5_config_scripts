
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc/bin/dedup
export ARGS="-c -p -v -t 1 -i /opt/shared/parsec_native/parsec-3.0/pkgs/kernels/dedup/run/media.dat -o output.dat.ddp"
export OUTDIR=parsec_dedup_largeinput_1tds
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length
export MAXTIME=5   # spec_mcf derived 1H host length


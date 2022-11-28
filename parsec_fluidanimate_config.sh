
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc/bin/fluidanimate
export ARGS="1 5 /opt/shared/parsec_native/parsec-3.0/pkgs/apps/fluidanimate/run/in_100K.fluid /opt/shared/parsec_native/parsec-3.0/pkgs/apps/fluidanimate/run/out.fluid"
export OUTDIR=parsec_fluidanimate_simmedium
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length
export MAXTIME=3600   # spec_mcf derived 1H host length


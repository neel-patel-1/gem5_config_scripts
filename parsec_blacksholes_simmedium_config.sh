
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc/bin/blackscholes
export ARGS="1 /opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/run/in_16K.txt /opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/run/prices.txt "
export OUTDIR=parsec_blacksholes_simmedium
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length
export MAXTIME=3600   # spec_mcf derived 1H host length


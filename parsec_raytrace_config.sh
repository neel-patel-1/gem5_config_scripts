
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/apps/raytrace/inst/amd64-linux.gcc/bin/rtview
export ARGS="/opt/shared/parsec_native/parsec-3.0/pkgs/apps/raytrace/run/octahedron.obj -automove -nthreads 1 -frames 3 -res 1920 1080"
export OUTDIR=parsec_raytrace
#export SIM_TICKS=50500000000 # 1m20s for MCF_R default
export SIM_TICKS=$(( 50500000000 * 45 ))  # spec_mcf derived 1H host length
export MAXTIME=1
#export SIM_TICKS=$(( 100 ))  # spec_mcf derived 1H host length
export MAXTIME=3600 # 5 seconds for testing


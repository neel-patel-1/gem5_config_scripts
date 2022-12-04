
PARSECMGMT=/opt/shared/parsec_native/parsec-3.0/bin/parsecmgmt
$PARSECMGMT -a run -p blackscholes -i simsmall
export BIN=/opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/inst/amd64-linux.gcc/bin/blackscholes
export ARGS="1 /opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/run/in_4K.txt /opt/shared/parsec_native/parsec-3.0/pkgs/apps/blackscholes/run/prices.txt "
export OUTDIR=blacksholes
export SIM_TICKS=50500000000 
export MAXTIME=2.2725 # 5 seconds for testing
export RESTORE_CPOINT=raytrace_cpoints/

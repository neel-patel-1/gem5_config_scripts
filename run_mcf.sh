RUNCPU=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/cpu_2017/bin/runcpu
SPEC_CONF=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/spec_conf/testConfig.cfg
PARMS=" --iterations=1 --config=${SPEC_CONF}/../../../spec_conf/testConfig.cfg --copies=1 "

EXE="${RUNCPU} ${PARMS}"

${EXE}


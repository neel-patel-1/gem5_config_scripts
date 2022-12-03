#!/bin/bash
[ -z "$1" ] && exit
prefix=${1}
for i in ${1}*/stats.txt ; do
	echo -n "${i}:"
	echo -n $(grep hostSeconds ${i} | awk '{print $2}'),
	echo -n $(grep simSeconds ${i} | awk '{print $2}')
	echo ""
done

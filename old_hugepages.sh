#!/bin/bash
echo 2000000000000 > /proc/sys/vm/nr_hugepages & LD_PRELOAD=libhugetlbfs.so \
	HUGETLB_MORECORE=yes bash run-single.sh


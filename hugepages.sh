#!/bin/bash

LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes ./run-single.sh
#LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes HUGETLB_FORCE_ELPMAP=yes ./run-single1.sh

#hugectl --heap ./run-single.sh


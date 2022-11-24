#!/bin/sh                                                                       
#sudo LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes ~/power/gem5-learning/con\
figs/prifile.sh                                                                 
LD_PRELOAD=libhugetlbfs.so HUGETLB_MORECORE=yes ./run-single.sh

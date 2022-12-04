#!/bin/bash
cd iodlr/large_page-c
make -f Makefile.preload
 cp liblppreload.so ..//../

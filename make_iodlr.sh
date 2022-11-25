#!/bin/bash
cd iodlr/large_page-c
make -f Makefile.preload
sudo cp liblppreload.so ..//../

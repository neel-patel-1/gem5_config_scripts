#!/bin/bash
sudo wrmsr -a 0x1a4 f

taskset -c 5 run-single1.sh

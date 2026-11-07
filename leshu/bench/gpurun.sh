#!/usr/bin/env bash
# gpurun.sh <name> <envfile> <rundir> [cfg]: run1.sh plus nvidia-smi sampling every second
set -u
name=$1
mkdir -p /d/lichii/bench/gpulog
nvidia-smi --query-gpu=timestamp,utilization.gpu,clocks.gr,power.draw,memory.used --format=csv,noheader -l 1 > /d/lichii/bench/gpulog/$name.csv &
smi=$!
bash /d/lichii/bench/run1.sh "$@"
kill $smi 2>/dev/null; taskkill //F //IM nvidia-smi.exe > /dev/null 2>&1

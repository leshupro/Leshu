#!/usr/bin/env bash
# qtpair.sh <tag> <nand_dir>: official Frizti v3 vs Leshu 1 (Qt, docked) on one save
set -u
tag=$1; nand=$2
cd /d/lichii/bench
for r in off3 leshu; do
  cfg=/d/lichii/run-$r/user/config/qt-config.ini
  python -I setcfg.py "$cfg" "nand_directory=$nand" > /dev/null
  for i in $(seq 1 60); do tasklist | grep -qiE "lichii.exe|eden-cli.exe" || break; sleep 5; done
  sleep 10
  nvidia-smi --query-gpu=timestamp,utilization.gpu,clocks.gr,power.draw --format=csv,noheader -l 1 > gpulog/q-$tag-$r.csv &
  smi=$!
  python -I qtbench.py q-$tag-$r "D:\lichii\run-$r" lichii.exe /d/lichii/bench/base_empty.env
  kill $smi 2>/dev/null; taskkill //F //IM nvidia-smi.exe > /dev/null 2>&1
  awk -F', ' 'NR>140 && NR<236 {u+=$2; p+=$4; n++} END{printf "   gpu %.1f%% %.1f W\n", u/n, p/n}' gpulog/q-$tag-$r.csv
done

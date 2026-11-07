#!/usr/bin/env bash
# run1.sh <name> <envfile> <rundir> [cfg]  -> runs one 240 s bench and appends score to results.txt
set -u
name=$1; envf=$2; run=$3; cfg=${4:-}
cd /d/lichii/bench
RUNDIR=$run CFG="$cfg" CAP_EVERY=1200 bash bench.sh "$name" "$envf" 240 "${KEYS:-keys_load.txt}" > /dev/null 2>&1
score=$(awk '$1 ~ /^[0-9.]+$/ && $1>=140 && $1<236 {s+=$2;n++} END{if(n) printf "%.2f", s/n; else print "NA"}' "$name/fps.txt")
echo "$(date +%H:%M) $name score=$score env=[$(basename $envf)] cfg=[$cfg] run=$run" | tee -a results.txt

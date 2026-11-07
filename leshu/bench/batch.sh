#!/usr/bin/env bash
# Runs each config of a batch on the village save and scores it (mean FPS after load settles).
# Usage: batch.sh <batchname> <spec> [spec ...]
#   spec = name:ENV1;ENV2|cfgkey=value,cfgkey=value   (env added to base.env; cfg applied to sdl2-config)
set -u
batch=$1; shift
cd /d/lichii/bench
results=/d/lichii/bench/results.txt
mkdir -p envs
for spec in "$@"; do
  name=${spec%%:*}; rest=${spec#*:}
  [[ $rest == "$spec" ]] && rest=""
  extra=${rest%%|*}; cfg=""
  [[ $rest == *"|"* ]] && cfg=${rest#*|}
  envf=/d/lichii/bench/envs/$batch-$name.env
  cp base.env "$envf"
  [[ -n $extra ]] && tr ';' '\n' <<< "$extra" >> "$envf"
  CFG="$cfg" CAP_EVERY=1200 bash bench.sh "$batch-$name" "$envf" 240 keys_load.txt > /dev/null 2>&1
  score=$(awk '$1 ~ /^[0-9.]+$/ && $1>=140 && $1<236 {s+=$2;n++} END{if(n) printf "%.2f", s/n; else print "NA"}' "$batch-$name/fps.txt")
  crash=$(grep -cE "Critical" "$batch-$name/eden_log.txt" 2>/dev/null)
  echo "$(date +%H:%M) $batch-$name score=$score crit=$crash env=[$extra] cfg=[$cfg] run=${RUNDIR:-/d/lichii/run}" | tee -a "$results"
done

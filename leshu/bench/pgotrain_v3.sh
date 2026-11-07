#!/usr/bin/env bash
# PGO training: instrumented eden-cli on the village save, closed gracefully so the profile is
# written. Usage: pgotrain.sh <rundir> <envfile> <seconds>
set -u
rundir=$1; envfile=$(realpath "$2"); secs=$3
keys=$(cygpath -w /d/lichii/bench/keys_load.txt)
cd "$rundir"
env_args=()
while IFS= read -r line; do
  line=${line%$'\r'}
  [[ -z $line || $line == \#* ]] && continue
  env_args+=("$line")
done < "$envfile"
env_args+=("EDEN_NX2_KEY_SCRIPT=@$keys" "LLVM_PROFILE_FILE=D:/lichii/pgo/raw-v3/eden-%p.profraw")
env "${env_args[@]}" ./eden-cli.exe "${ROM:?set ROM to your own game dump}" > /d/lichii/pgo/train_stdout.txt 2>&1 &
sleep "$secs"
pid=$(tasklist //FI "IMAGENAME eq eden-cli.exe" //FO CSV //NH | head -1 | cut -d, -f2 | tr -d '"')
echo "closing pid $pid"
taskkill //PID "$pid" > /dev/null 2>&1
for i in $(seq 1 60); do
  tasklist | grep -qi eden-cli.exe || break
  sleep 2
done
if tasklist | grep -qi eden-cli.exe; then echo "forced"; taskkill //F //IM eden-cli.exe > /dev/null 2>&1; fi
ls -la /d/lichii/pgo/raw/

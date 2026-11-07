#!/usr/bin/env bash
# PGO training for Leshu 2: instrumented eden-cli, docked, one zone per call, closed gracefully.
# Usage: pgotrain_l2.sh <rundir> <envfile> <seconds> <keyscript> [cfg]
set -u
rundir=$1; envfile=$(realpath "$2"); secs=$3; keys=$(cygpath -w "$(realpath "$4")"); cfg=${5:-}
cd "$rundir"
python -I /d/lichii/bench/setcfg.py user/config/sdl2-config.ini "$cfg" > /dev/null
env_args=()
while IFS= read -r line; do
  line=${line%$'\r'}
  [[ -z $line || $line == \#* ]] && continue
  env_args+=("$line")
done < "$envfile"
env_args+=("EDEN_NX2_KEY_SCRIPT=@$keys" "LLVM_PROFILE_FILE=D:/lichii/pgo/raw-l2/eden-%p.profraw")
for i in $(seq 1 60); do tasklist | grep -qi eden-cli.exe || break; sleep 5; done
sleep 5
env "${env_args[@]}" ./eden-cli.exe "${ROM:?set ROM to your own game dump}" > /d/lichii/pgo/train_stdout.txt 2>&1 &
sleep "$secs"
pid=$(tasklist //FI "IMAGENAME eq eden-cli.exe" //FO CSV //NH | head -1 | cut -d, -f2 | tr -d '"')
taskkill //PID "$pid" > /dev/null 2>&1
for i in $(seq 1 60); do tasklist | grep -qi eden-cli.exe || break; sleep 2; done
if tasklist | grep -qi eden-cli.exe; then echo "forced"; taskkill //F //IM eden-cli.exe > /dev/null 2>&1; fi
ls /d/lichii/pgo/raw-l2/ | wc -l

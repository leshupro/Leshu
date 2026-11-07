#!/usr/bin/env bash
# Prueba automatica: arranca Zelda en eden-cli (copia en D:\lichii\run), con los switches de un
# archivo de entorno, durante N segundos, y guarda log + capturas en D:\lichii\bench\<nombre>.
# Uso: bench.sh <nombre> <archivo.env> <segundos> [keyscript]
set -u
name=$1; envfile=$2; secs=$3; keys=${4:-}
out=/d/lichii/bench/$name
rm -rf "$out"; mkdir -p "$out/frames"
envfile=$(realpath "$envfile"); [[ -n $keys ]] && keys=$(cygpath -w "$(realpath "$keys")"); cd "${RUNDIR:-/d/lichii/run}"
env_args=()
while IFS= read -r line; do
  line=${line%$'\r'}
  [[ -z $line || $line == \#* ]] && continue
  env_args+=("$line")
done < "$envfile"
env_args+=("EDEN_NX2_FPS_LOG=1" "EDEN_NX2_FRAME_CAPTURE=D:/lichii/bench/$name/frames" "EDEN_NX2_FRAME_CAPTURE_EVERY=${CAP_EVERY:-600}")
[[ -n $keys ]] && env_args+=("EDEN_NX2_KEY_SCRIPT=@$keys")
rm -f user/log/eden_log.txt
cfg=user/config/sdl2-config.ini
if [[ -n ${CFG:-} ]]; then cp "$cfg" "$cfg.benchsave"; python -I /d/lichii/bench/setcfg.py "$cfg" "$CFG" > "$out/cfg.txt"; fi
# Wait for the previous emulator to be gone and its memory released (the 12 GB layout needs
# ~20 GB of free commit, else it falls back to a slower path).
for i in $(seq 1 60); do
  if ! tasklist | grep -qi "eden-cli.exe"; then
    freecommit=$(powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreeVirtualMemory/1MB)")
    [[ ${freecommit:-0} -ge 22 ]] && break
  fi
  sleep 5
done
echo "free commit before start: ${freecommit:-?} GB" > "$out/pre.txt"
sleep 5
env "${env_args[@]}" timeout -s KILL "$secs" ./eden-cli.exe "${ROM:?set ROM to your own game dump}" > "$out/stdout.txt" 2>&1
cp user/log/eden_log.txt "$out/eden_log.txt" 2>/dev/null
if [[ -n ${CFG:-} ]]; then mv -f "$cfg.benchsave" "$cfg"; fi
grep -E "FPS: " "$out/eden_log.txt" | sed -E 's/^\[ *([0-9.]+)\].*FPS: ([0-9.]+) speed: ([0-9]+)% frametime: ([0-9.]+).*/\1 \2 \3 \4/' > "$out/fps.txt"
echo "done $name: $(wc -l < "$out/fps.txt") fps samples, $(ls "$out/frames" | wc -l) frames"

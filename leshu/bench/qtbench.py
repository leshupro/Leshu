"""Qt frontend benchmark through the debug server.

qtbench.py <name> <rundir> <exe> <envfile>
Boots the ROM, presses A to pass the title and load the save, then samples presented fps from
140 s to 236 s (5 s windows) like bench.sh does for eden-cli. Results: D:/lichii/bench/<name>/.
"""
import json
import os
import socket
import subprocess
import sys
import time

ROM = os.environ["ROM"]  # path to your own game dump
PORT = 6545

name, rundir, exe, envfile = sys.argv[1:5]
out = os.path.join(r"D:\lichii\bench", name)
os.makedirs(out, exist_ok=True)
env = dict(os.environ)
for line in open(envfile, encoding="utf-8"):
    line = line.strip()
    if line and not line.startswith("#") and "=" in line:
        key, value = line.split("=", 1)
        env[key] = value
env["EDEN_NX2_DEBUG_SERVER"] = f"127.0.0.1:{PORT}"
log_path = os.path.join(rundir, "user", "log", "eden_log.txt")
if os.path.exists(log_path):
    os.remove(log_path)

start = time.time()
proc = subprocess.Popen([os.path.join(rundir, exe), ROM], cwd=rundir, env=env)


def call(method, params=None, timeout=30):
    with socket.create_connection(("127.0.0.1", PORT), timeout=timeout) as sock:
        sock.sendall((json.dumps({"method": method, "params": params or {}}) + "\n").encode())
        data = b""
        while not data.endswith(b"\n"):
            chunk = sock.recv(1 << 20)
            if not chunk:
                break
            data += chunk
    return json.loads(data.decode())


def elapsed():
    return time.time() - start


samples = []
try:
    pressed = set()
    while elapsed() < 236:
        t = elapsed()
        if 70 <= t <= 106:
            slot = int((t - 70) // 4)
            if slot not in pressed:
                pressed.add(slot)
                try:
                    call("input", {"buttons": ["A"], "frames": 3}, timeout=20)
                except Exception as error:  # noqa: BLE001 - the server may not be up yet
                    print(f"{t:.0f}s input failed: {error}")
            time.sleep(0.5)
            continue
        if t >= 140:
            try:
                status = call("status", {"fps_window_ms": 5000}, timeout=20)
                result = status.get("result", status)
                samples.append((round(elapsed(), 1), result.get("fps", 0.0)))
            except Exception as error:  # noqa: BLE001
                print(f"{t:.0f}s status failed: {error}")
                time.sleep(2)
            continue
        time.sleep(1)
    try:
        call("screenshot", {"height": 360, "save": True}, timeout=20)
    except Exception:  # noqa: BLE001
        pass
finally:
    proc.kill()
    proc.wait()
    time.sleep(2)
    if os.path.exists(log_path):
        with open(log_path, "rb") as src, open(os.path.join(out, "eden_log.txt"), "wb") as dst:
            dst.write(src.read())

with open(os.path.join(out, "fps.txt"), "w") as file:
    for t, fps in samples:
        file.write(f"{t} {fps:.2f}\n")
values = [fps for _, fps in samples if fps > 0]
mean = sum(values) / len(values) if values else 0.0
line = f"{time.strftime('%H:%M')} {name} score={mean:.2f} n={len(values)} qt rundir={rundir} exe={exe}"
print(line)
with open(r"D:\lichii\bench\results.txt", "a") as file:
    file.write(line + "\n")

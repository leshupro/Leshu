<p align="center">
  <img src="leshu/leshu.png" alt="Leshu" width="160">
</p>

# Lichii Leshu

**English** · [Español](README.es.md)

**Leshu** is a performance build of [Lichii Frizti](https://github.com/Frizti/Lichii), the Switch 2 emulator fork tuned for *The Legend of Zelda: Ocarina of Time*. It does not change what the emulator emulates. It is the same code as Frizti v3, built differently:

- **clang-cl + ThinLTO + PGO** (Profile-Guided Optimization trained on Ocarina of Time in six areas).
- **Generic x86-64-v3 build**: runs on any CPU with AVX2 (Intel 4th gen / Haswell or newer, any AMD Ryzen).
- **Ready to play**: Frizti v3's tuned defaults for Ocarina of Time are built in. Add your keys and firmware, open the game.

> All credit for the emulator goes to its authors (see **Credits**). Leshu only builds, measures and tunes it.

## Results

Docked mode, 1080p, i7-11700F + RTX 3060, Link standing still, mean FPS over 96 s after the save loads.

| Area | Frizti v3 (official build) | **Leshu 1** |
|---|---|---|
| Kokiri Village | 34.1 | **35.3 (+3.5%)** |
| Hyrule Field | 43.3 | **43.9 (+1%)** |

Village: mean of two runs each; Hyrule: one run each. The gain is small because the official Frizti v3 builds already use clang + PGO (with their own profile); Leshu's profile is trained on Ocarina of Time only. Bigger gains need code changes: that is the plan for Leshu 2.

## Install (Windows)

1. Install the [Microsoft Visual C++ Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe) if you don't have it.
2. Download `Leshu-1-Windows-x64.zip` from [Releases](https://github.com/leshupro/Leshu/releases) and extract the whole folder.
3. Put your own `prod.keys` and `title.keys` in `user/keys/` and install the firmware dumped from your own console (Tools → Install Firmware).
4. Run **lichii.exe**, add your game folder and play.

The `user` folder next to `lichii.exe` makes the build portable: saves, settings and shader cache stay inside it. To reuse an existing Lichii/Eden setup, copy your old `user` folder there (back up your saves first).

Leshu contains **no keys, firmware or games**. Dump them from your own console.

### Settings

Nothing has to be set. `nx2_switches.txt` next to the executable lists the GPU switches with comments, for anyone who wants to experiment. Frizti v3's defaults (Docked, 8 GB memory, GPU accuracy Low, async shaders and presentation, the 60/30 FPS choice for Ocarina) apply automatically.

## What was measured and did not help

Within ±1 FPS on this PC: GPU fence "Immediate", CPU accuracy "Unsafe", DLSS replacement, disabling post-processing, VSync off, 8 vs 12 GB memory layout, most `EDEN_NX2_PERF_ON` experiments, and skipping the compute-to-graphics and wait-for-idle barriers Frizti v3 added (#295).

Handheld (720p) is ~5 FPS faster than Docked (1080p) in Hyrule Field, where the GPU is ~80% busy. In small areas the CPU side is the limit and both modes perform the same.

## Building Leshu

Requirements: Visual Studio 2022/2026 with "Desktop development with C++", the C++ Clang tools and CMake tools components, and the Vulkan SDK.

```bat
:: Optimized build with the profile (download leshu-pgo-profile.zip from Releases to pgo\v3.profdata)
leshu\scripts\configure_leshu.bat use
leshu\scripts\build_dir.bat build-leshu
```

To train your own profile: `configure_leshu.bat gen`, build `build-leshugen`, run the instrumented `eden-cli` in a few areas (`leshu/bench/pgotrain_v3.sh` closes it gracefully so the `.profraw` files are written), then `llvm-profdata merge -o pgo\v3.profdata <files>.profraw`.

Ninja does not rebuild when only the `.profdata` changes: delete the `.obj` files first. The scripts contain absolute paths (`D:\lichii\...`); adjust them to yours.

## Automated benchmark (`leshu/bench/`)

Boots the game, loads the latest save through a key script, and logs FPS without anyone playing, so every change can be compared fairly. Set `ROM` to the path of your own dump.

- `bench.sh` / `run1.sh` / `batch.sh`: `eden-cli` runs with a switch file and config overrides (`setcfg.py`).
- `qtbench.py` / `qtpair.sh`: the same for `lichii.exe` through its debug server.
- `gpurun.sh`: also logs GPU use with `nvidia-smi`.

Lessons: compare versions only at identical graphics settings (Docked vs handheld alone moved Hyrule by 5 FPS), wait until ~22 GB of commit is free before each run, and parse FPS lines strictly.

`leshu/patches-v2-experiments/` holds experiments against Frizti v2 (semaphore acquires, QMD release prediction). They were correct but gave no FPS and are not in Leshu 1.

## Credits

- **Lichii Frizti** by Frizti — the base of Leshu, with the Ocarina of Time work.
- **Lichii** by zortos293 and contributors.
- **Eglantine**, **Eden** and **Sudachi**, and the **yuzu** project before them.
- **Dynamic FPS by Dark** (bundled in Lichii Frizti), **EvilOOT** and everyone whose fixes Frizti ported.
- Leshu builds and benchmarks: leshupro, with Claude (Anthropic).

The original Lichii README is in [README.lichii.md](README.lichii.md).

## License

GPL-3.0-or-later, like Lichii. Lichii and Leshu are not affiliated with Nintendo.

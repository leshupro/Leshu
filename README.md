<p align="center">
  <img src="leshu/leshu.png" alt="Leshu" width="160">
</p>

# Lichii Leshu 5

**English** · [Español](README.es.md)

**Leshu 5** is [zortos293/Lichii](https://github.com/zortos293/Lichii) **build 117** (a Switch 2 emulator) with one addition: **frame generation spacing**. All other code, the settings and the PGO profile are the ones zortos293 ships.

> Playing normally, without frame generation, Leshu 5 is **not faster** than the official build 117. If you don't use frame generation, use the official build.

## What it adds

With frame generation on, each generated frame was presented right before its real one, so frames arrived in pairs. Leshu 5 spaces them evenly.

Build 117, 30 FPS limit, FSR3 x2, Kokiri Village, Link standing still, two runs each:

| | Without spacing | **With spacing** |
|---|---|---|
| Present intervals | half under 4 ms, half over 30 ms | **85-91% between 12 and 20 ms** |
| Longest interval | 42-46 ms | **24-26 ms** |
| Game FPS | 27.6 / 28.7 | 29.4 / 29.8 |

These are the times frames are sent to the display, measured in the emulator, on one PC (i7-11700F + RTX 3060) and one scene. `EDEN_NX2_FG_PACE=0` turns the spacing off. Without frame generation the code does nothing.

To use it: Emulation → Configure → Graphics → Enable Frame Generation (FSR3, x2). A limit such as `FPS Limit` = 30 in the same tab keeps it steady.

## Install (Windows)

1. Install the [Microsoft Visual C++ Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe) if you don't have it.
2. Download `Leshu-5-Windows-x64.zip` from [Releases](https://github.com/leshupro/Leshu/releases) and extract the whole folder.
3. Put your own `prod.keys` and `title.keys` in `user/keys/` and install the firmware dumped from your own console (Tools → Install Firmware).
4. Run **lichii.exe**. It creates the settings recommended by zortos293 on first start.

Start with a new `user` folder. An old configuration can keep values that this version reads differently (slower GPU accuracy, synchronous shaders). The shader cache starts empty, so expect stutter the first time each thing appears. Leshu contains **no keys, firmware or games**: dump them from your own console.

## What was measured and did not help

A PGO profile trained on gameplay (walking, six situations) did not beat the official profile, so it is not included (handheld 720p, official vs gameplay profile: village standing 30.3 vs 29.9, Hyrule standing 35.8 vs 36.8, village walking 43.75 and 43.05 vs 44.2 and 39.1, Hyrule walking 39.1 vs 40.3).

## Building

Visual Studio 2022/2026 with "Desktop development with C++", the C++ Clang tools and CMake tools components, and the Vulkan SDK. The scripts contain absolute paths; adjust them to yours.

```bat
leshu\scripts\configure_z.bat build-z117 D:/lichii/zsrc/lichii-windows.profdata
leshu\scripts\build_dir.bat build-z117
```

Leshu 1-4 (based on Lichii Frizti v3) are on the [`leshu` branch](https://github.com/leshupro/Leshu/tree/leshu).

## Credits

- **Lichii** by zortos293 and contributors: everything in Leshu 5 except the frame spacing.
- **Lichii Frizti** by Frizti, **Eglantine**, **Eden**, **Sudachi** and the **yuzu** project before them.
- **Dynamic FPS by Dark**, bundled in Lichii.
- Frame spacing and measurements: leshupro, with Claude (Anthropic).

The original Lichii README is in [README.lichii.md](README.lichii.md).

## License

GPL-3.0-or-later, like Lichii. Not affiliated with Nintendo.

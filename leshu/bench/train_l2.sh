#!/usr/bin/env bash
set -u
R=/d/lichii/run-leshugen
rm -rf $R; mkdir -p $R; cp -r /d/lichii/run-v3bar/user $R/; rm -rf $R/user/log/*
cp /d/lichii/build-leshugen/bin/eden-cli.exe $R/; cp /d/lichii/run-v3bar/*.dll $R/
mkdir -p /d/lichii/pgo/raw-l2; rm -f /d/lichii/pgo/raw-l2/*
cd /d/lichii/bench
D="use_docked_mode=1,use_vsync=1,nvdec_emulation=2"
T=bash; S=/d/lichii/bench/pgotrain_l2.sh; E=/d/lichii/bench/v3builtin.env
$T $S $R $E 200 keys_load.txt  "nand_directory=D:/lichii/run/user/nand,$D"
$T $S $R $E 220 keys_walk2.txt "nand_directory=D:/lichii/run/user/nand,$D"
$T $S $R $E 200 keys_load.txt  "nand_directory=D:/lichii/nand-hyrule,$D"
$T $S $R $E 220 keys_walk2.txt "nand_directory=D:/lichii/nand-hyrule,$D"
$T $S $R $E 220 keys_walk2.txt "nand_directory=D:/lichii/nand-dekuin,$D"
$T $S $R $E 200 keys_load.txt  "nand_directory=D:/lichii/nand-boss,$D"
ls -la /d/lichii/pgo/raw-l2

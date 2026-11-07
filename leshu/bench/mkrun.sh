#!/usr/bin/env bash
# mkrun.sh <rundir> <builddir>: a run folder with that build's eden-cli + the shared test user data
set -e
r=$1; b=$2
mkdir -p "$r/user"
cp "$b/bin/eden-cli.exe" "$r/"; cp "$b/bin/eden-cli.pdb" "$r/" 2>/dev/null || true
cp /d/lichii/run/*.dll "$r/" 2>/dev/null || true
for d in config keys amiibo; do rm -rf "$r/user/$d"; cp -r "/d/lichii/run/user/$d" "$r/user/"; done
mkdir -p "$r/user/cache"; rm -rf "$r/user/cache/shader"; cp -r /d/lichii/run/user/cache/shader "$r/user/cache/" 2>/dev/null || true
mkdir -p "$r/user/log"
echo "run folder $r ready"

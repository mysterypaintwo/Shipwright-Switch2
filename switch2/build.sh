#!/bin/sh
# Builds Ship of Harkinian for Switch 2 (ounce) and puts the files to copy to
# the console in build-switch2/dist.
#
#   sh switch2/build.sh
#
# Needs devkitPro (switch-dev, switch-portlibs) and the ounce SDK (install.sh).
# Make the OTR files first with a native build: see switch2/README.md.

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-switch2"

git -C "$ROOT" submodule update --init --recursive

cmake -H"$ROOT" -B"$BUILD" -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/switch2/cmake/Switch2.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$BUILD" --target soh_nro

DIST="$BUILD/dist/switch/soh"
mkdir -p "$DIST"
cp "$BUILD/soh/soh.nro" "$DIST/"
for otr in soh.otr oot.otr oot-mq.otr; do
    if [ -f "$ROOT/$otr" ]; then
        cp "$ROOT/$otr" "$DIST/"
    fi
done
echo "Files to copy to the SD card are in $BUILD/dist"
ls -l "$DIST"

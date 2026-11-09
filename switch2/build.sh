#!/bin/sh
# Builds Ship of Harkinian for Switch 2 (ounce) and makes the release archive
# build-switch2/soh-switch2.zip.
#
#   sh switch2/build.sh
#
# Needs devkitPro (switch-dev, switch-portlibs) and the ounce SDK (install.sh).
#
# The archive has soh.nro and soh.otr only. soh.otr holds the port's own
# assets. oot.otr and oot-mq.otr are made from a ROM, so they are never put in
# the archive: each player makes their own (see switch2/README.md).

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-switch2"

git -C "$ROOT" submodule update --init --recursive

cmake -H"$ROOT" -B"$BUILD" -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/switch2/cmake/Switch2.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$BUILD" --target soh_nro

# Start from an empty folder, so no file from an earlier build gets in.
DIST="$BUILD/dist"
rm -rf "$DIST" "$BUILD/soh-switch2.zip"
mkdir -p "$DIST/switch/soh"
cp "$BUILD/soh/soh.nro" "$DIST/switch/soh/"
if [ -f "$ROOT/soh.otr" ]; then
    cp "$ROOT/soh.otr" "$DIST/switch/soh/"
else
    echo "warning: soh.otr not found; make it with the GenerateSohOtr target" >&2
fi
cp "$ROOT/switch2/README.md" "$DIST/readme.txt"

# Stop if a ROM-derived file got into the archive folder.
if find "$DIST" -name 'oot*.otr' -o -name '*.z64' -o -name '*.n64' -o -name '*.v64' | grep -q .; then
    echo "error: ROM-derived files found in $DIST" >&2
    exit 1
fi

(cd "$DIST" && zip -qr "$BUILD/soh-switch2.zip" .)
echo "Release archive: $BUILD/soh-switch2.zip"
unzip -l "$BUILD/soh-switch2.zip"

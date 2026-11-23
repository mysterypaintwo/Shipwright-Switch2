#!/bin/sh
# Builds Ship of Harkinian for Switch 2 (ounce) and makes the release archive
# build-switch2/soh-switch2.zip.
#
#   sh switch2/build.sh
#
# Needs devkitPro (switch-dev, switch-portlibs) and the ounce SDK (install.sh).
#
# The archive has soh.nro, soh.o2r and the player docs. soh.o2r holds the port's own
# assets. oot.o2r and oot-mq.o2r are made from a ROM, so they are never put in
# the archive: each player makes their own (see switch2/GAME-DATA.md).

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build-switch2"

# Fetch the submodules only if missing, so local library work is never reset.
[ -f "$ROOT/libultraship/CMakeLists.txt" ] && [ -f "$ROOT/torch/CMakeLists.txt" ] || \
    git -C "$ROOT" submodule update --init --recursive

cmake -H"$ROOT" -B"$BUILD" -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/switch2/cmake/Switch2.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$BUILD" --target soh_nro

# Stop if the NRO is not marked as a Switch 2 program (old SDK or libnx).
python3 "$ROOT/switch2/check_nro.py" "$BUILD/soh/soh.nro"

# Start from an empty folder, so no file from an earlier build gets in.
DIST="$BUILD/dist"
rm -rf "$DIST" "$BUILD/soh-switch2.zip"
mkdir -p "$DIST/switch/soh"
cp "$BUILD/soh/soh.nro" "$DIST/switch/soh/"
# soh.o2r is built by the computer's toolchain, not the Switch one.
HOST="$BUILD/host-tools"
cmake -S "$ROOT" -B "$HOST" -G Ninja -DSOH_TOOLS_ONLY=ON -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$HOST" --target GenerateSohOtr
cp "$HOST/soh/soh.o2r" "$DIST/switch/soh/"
cp "$ROOT/switch2/PLAYER-README.txt" "$DIST/readme.txt"
cp "$ROOT/switch2/GAME-DATA.md" "$DIST/GAME-DATA.md"
cp "$ROOT/switch2/CHANGELOG.md" "$DIST/CHANGELOG.md"

# Stop if a ROM-derived file got into the archive folder.
if find "$DIST" -name 'oot*.otr' -o -name 'oot*.o2r' -o -name '*.z64' -o -name '*.n64' -o -name '*.v64' | grep -q .; then
    echo "error: ROM-derived files found in $DIST" >&2
    exit 1
fi

(cd "$DIST" && zip -qr "$BUILD/soh-switch2.zip" .)
echo "Release archive: $BUILD/soh-switch2.zip"
unzip -l "$BUILD/soh-switch2.zip"

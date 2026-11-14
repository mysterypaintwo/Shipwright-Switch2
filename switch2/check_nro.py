#!/usr/bin/env python3
"""Checks that an NRO is a Switch 2 (libounce) program.

    python3 switch2/check_nro.py path/to/program.nro

libounce's startup code adds an "OUN0" record (NroOunceInfo in
<switch/nro.h>) as a MOD0 extension block. A libnx (Switch 1) program, or a
program built with an ounce SDK older than 20261114, has none; the console
then warns that the program targets Switch 1 or uses an outdated SDK.

The script also prints the title from the NACP, as the homebrew menu shows it.
"""
import struct
import sys

NROOUNCE_MAGIC = b"OUN0"
PLATFORMS = {1: "Switch 1", 2: "Switch 2"}


def main(path):
    with open(path, "rb") as f:
        data = f.read()
    if data[0x10:0x14] != b"NRO0":
        sys.exit(f"{path}: not an NRO")

    # The record is in the first 0x1000 bytes, after MOD0 and libnx's LNY blocks.
    mod0 = struct.unpack_from("<I", data, 4)[0]
    if data[mod0:mod0 + 4] != b"MOD0":
        sys.exit(f"{path}: no MOD0 header")
    at = data.find(NROOUNCE_MAGIC, mod0, 0x1000)
    if at < 0:
        sys.exit(f"{path}: no OUN0 record: not linked with a current libounce (Switch 1 or outdated SDK)")
    platform, version = struct.unpack_from("<II", data, at + 4)
    name = PLATFORMS.get(platform, f"unknown ({platform})")
    if platform != 2:
        sys.exit(f"{path}: OUN0 platform is {name}, not Switch 2")

    title = ""
    size = struct.unpack_from("<I", data, 0x18)[0]
    if data[size:size + 4] == b"ASET":
        nacp_off, nacp_size = struct.unpack_from("<QQ", data, size + 0x18)
        if nacp_size >= 0x200:
            nacp = data[size + nacp_off:size + nacp_off + 0x200]
            title = nacp.split(b"\0", 1)[0].decode("utf-8", "replace")
    print(f"{path}: {name} program (OUN0 version {version}), title \"{title}\"")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__.strip().splitlines()[2].strip())
    main(sys.argv[1])

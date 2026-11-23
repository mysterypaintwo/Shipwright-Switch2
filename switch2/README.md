# Ship of Harkinian for Switch 2 (ounce)

An unofficial build of Ship of Harkinian 9.3.1 for the Nintendo Switch 2. To
install and play it, see `PLAYER-README.txt` and `GAME-DATA.md`. This file is
for building from source.

# Building

This folder builds Ship of Harkinian for Switch 2 with the ounce homebrew SDK
(libounce and OunceVK). The build uses the existing Switch code with
`__SWITCH2__` defined, and links libounce instead of libnx.

## Requirements

- devkitPro with `switch-dev` and `switch-portlibs`:

  ```sh
  sudo dkp-pacman -S --needed switch-dev switch-portlibs
  ```

- The ounce devkit 20261117 or newer, installed in `$DEVKITPRO` with
  `sh install.sh` from ounce-devkit (it adds `libounce` and
  `portlibs/switch2`). Older SDKs are refused: their NROs are
  not marked as Switch 2 programs, and the console warns about them.
- A supported ROM to make the OTR files (see `docs/supportedHashes.json`).

## Game data

`oot.o2r` and `oot-mq.o2r` are made from a ROM, so they are never distributed.
Each player makes their own with the PC version 9.3.1 (see `GAME-DATA.md`).

## Build the NRO

```sh
sh switch2/build.sh
```

The script builds `soh.nro`, makes the ROM-free `soh.o2r` with the host tools,
and packs `build-switch2/soh-switch2.zip`.

## Changes for Switch 2

- `cmake/Switch2.cmake`: the CMake toolchain. It loads the devkit's own
  `$DEVKITPRO/libounce/cmake/Switch2.cmake` (libounce, the Switch 2 portlibs
  first, `-D__SWITCH2__` and the Switch 2 CPU flags).
- `check_nro.py`: `build.sh` runs it on `soh.nro` to check that libounce marked
  it as a Switch 2 program (the `OUN0` record).
- `soh/CMakeLists.txt`: on Switch 2 the homebrew menu title is
  "HarbourMasters - Shipwright", next to "HarbourMasters - 2Ship".
- `libultraship` (submodule, `soh-ounce` branch of
  <https://github.com/mysterypaintwo/libultraship-Switch2>): on Switch 2, the
  CPU clock table of the Switch 1 is not applied, and the display size is
  1920x1080 in both modes. OpenGL is a 4.1 core context with the core-profile
  shaders (as on macOS): Switch 2's OpenGL is Zink on Vulkan, and the Switch 1
  path (GLSL 1.10, no vertex array object) drew nothing there. The log has the
  OpenGL version and renderer.

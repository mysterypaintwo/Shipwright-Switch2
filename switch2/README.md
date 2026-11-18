# Ship of Harkinian for Switch 2 (ounce)

An unofficial build of Ship of Harkinian 8.0.6 for the Nintendo Switch 2. It
runs as homebrew from the homebrew menu.

## Quick start

1. Unzip `soh-switch2.zip` to the root of the SD card. You get
   `/switch/soh/soh.nro` and `/switch/soh/soh.otr`.
2. Make `oot.otr` (or `oot-mq.otr`) from your own ROM with the PC version
   8.0.6 of Ship of Harkinian, and copy it to `/switch/soh/`.
   `GAME-DATA.md` (next to this file) explains it step by step.
3. Start "HarbourMasters - Shipwright" from the homebrew menu.

The rest of this file is for building from source, and has more about
playing (see "Install on the console" and "Playing").

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

## Make the OTR files

The asset extractor runs on the computer, not on the console. From the repo
root, with the ROM copied to `OTRExporter/baserom.z64`:

```sh
cmake -H. -Bbuild-cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build-cmake --target ExtractAssets
```

This writes `soh.otr` and `oot.otr` (or `oot-mq.otr` for a Master Quest ROM)
to the repo root. With Apple Clang 21 or later, add
`-DCMAKE_CXX_FLAGS="-DFMT_CONSTEVAL= "` to the first command, because the
bundled fmt library does not compile there.

## Build the NRO

```sh
sh switch2/build.sh
```

The script updates the submodules, builds `soh.nro`, and makes the release
archive `build-switch2/soh-switch2.zip`. The archive has `switch/soh/soh.nro`
and `switch/soh/soh.otr` only. To make a ROM-free `soh.otr`, run
`cmake --build build-cmake --target GenerateSohOtr`.

`oot.otr` and `oot-mq.otr` are made from a ROM, so they are never distributed.
Each player makes their own from their own ROM (see above).

## Install on the console

1. Unzip `soh-switch2.zip` to the root of the SD card.
2. Copy your own `oot.otr`, `oot-mq.otr`, or both to `/switch/soh/`
   (`GAME-DATA.md` explains how to make them with the PC version 8.0.6).
3. Start "HarbourMasters - Shipwright" from the homebrew menu.

Which quest you get depends on the files:

- Only `oot-mq.otr` (made from a Master Quest ROM): every file is Master
  Quest. This is by design, not a bug.
- Only `oot.otr` (made from a vanilla ROM): every file is the original quest.
- Both: you pick the quest when you make a new file.

This build supports the PAL ROMs (PAL 1.0, PAL 1.1, PAL GameCube and PAL
Master Quest, see `docs/supportedHashes.json`). They have English, German
and French text: pick the language in Settings > Languages.

## Playing

- Press `-` to open the menu.
- Default buttons: B is A, Y is B, A is C-down, X is C-left, R is C-right,
  ZL is Z, ZR is R. The right stick is also the C buttons. If you played an
  earlier build, your saved controls stay: reset them in the controller
  settings to get these.
- Quit: Ship > Quit to Homebrew Menu goes back to the homebrew menu.
  Closing the game from the HOME menu also works.
- 120 FPS: on the Switch 2 screen, set the FPS slider in Graphics above 60.
  With vsync on, the game is held to the display's refresh rate (120 Hz
  handheld, 60 Hz on most TVs).
- Bug reports: the log is in `/switch/soh/logs/`. Send it with the report.
  After a crash, the folder also has a `crash-<date>.txt` file that says
  where the game crashed.

## Changes for Switch 2

- `cmake/Switch2.cmake`: the CMake toolchain. It loads the devkit's own
  `$DEVKITPRO/libounce/cmake/Switch2.cmake` (libounce, the Switch 2 portlibs
  first, `-D__SWITCH2__` and the Switch 2 CPU flags).
- `check_nro.py`: `build.sh` runs it on `soh.nro` to check that libounce marked
  it as a Switch 2 program (the `OUN0` record).
- `soh/CMakeLists.txt`: on Switch 2 the homebrew menu title is
  "HarbourMasters - Shipwright", next to "HarbourMasters - 2Ship".
- `libultraship` (submodule, `ounce` branch of
  <https://github.com/mysterypaintwo/libultraship-Switch2>): on Switch 2, the
  CPU clock table of the Switch 1 is not applied, and the display size is
  1920x1080 in both modes. OpenGL is a 4.1 core context with the core-profile
  shaders (as on macOS): Switch 2's OpenGL is Zink on Vulkan, and the Switch 1
  path (GLSL 1.10, no vertex array object) drew nothing there. The log has the
  OpenGL version and renderer.
- `soh/soh/SohMenuBar.cpp`: the "Switch performance mode" menu is hidden on
  Switch 2.

# Switch 2 (ounce) build

This folder builds Ship of Harkinian for Switch 2 with the ounce homebrew SDK
(libounce and OunceVK). The build uses the existing Switch code with
`__SWITCH2__` defined, and links libounce instead of libnx.

## Requirements

- devkitPro with `switch-dev` and `switch-portlibs`:

  ```sh
  sudo dkp-pacman -S --needed switch-dev switch-portlibs
  ```

- The ounce SDK, installed with its `install.sh` into `$DEVKITPRO`.
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
2. Copy your own `oot.otr` or `oot-mq.otr` to `/switch/soh/`.
3. Start `soh.nro` from hbloader.

## Changes for Switch 2

- `cmake/Switch2.cmake`: the CMake toolchain. It is devkitPro's `Switch.cmake`
  pointed at libounce, with the Switch 2 portlibs first.
- `cmake/Platform/NintendoSwitch.cmake`: adds `-D__SWITCH2__` and the Switch 2
  library path to devkitPro's platform settings.
- `libultraship` (submodule, `ounce` branch of
  <https://github.com/mysterypaintwo/libultraship-Switch2>): on Switch 2, the
  CPU clock table of the Switch 1 is not applied, and the display size is
  1920x1080 in both modes.
- `soh/soh/SohMenuBar.cpp`: the "Switch performance mode" menu is hidden on
  Switch 2.

# CMake toolchain for Switch 2 ("ounce"): the ounce devkit's own toolchain.
#
# ounce-devkit 20261114 and newer ship $DEVKITPRO/libounce/cmake/Switch2.cmake,
# which sets NX_ROOT to libounce, puts the Switch 2 portlibs first, adds
# __SWITCH2__ and the Switch 2 CPU flags, and sets NINTENDO_SWITCH2. Older SDKs
# do not have it. Their libounce also does not mark the NRO as a Switch 2
# program, so the console warns that it targets Switch 1 or an outdated SDK.
#
#   cmake -B build-switch2 -G Ninja -DCMAKE_TOOLCHAIN_FILE=switch2/cmake/Switch2.cmake

cmake_minimum_required(VERSION 3.13)

if(DEFINED ENV{DEVKITPRO})
    set(OUNCE_TOOLCHAIN "$ENV{DEVKITPRO}/libounce/cmake/Switch2.cmake")
else()
    set(OUNCE_TOOLCHAIN "/opt/devkitpro/libounce/cmake/Switch2.cmake")
endif()

if(NOT EXISTS "${OUNCE_TOOLCHAIN}")
    message(FATAL_ERROR "${OUNCE_TOOLCHAIN} not found. Install ounce-devkit 20261114 or newer, "
        "and set DEVKITPRO to the devkitPro folder that has it.")
endif()

include("${OUNCE_TOOLCHAIN}")

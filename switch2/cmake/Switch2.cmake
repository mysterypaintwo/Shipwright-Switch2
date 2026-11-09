# CMake toolchain for Switch 2 ("ounce") with the ounce SDK (libounce + OunceVK).
#
# This is devkitPro's Switch.cmake with three changes:
# - NX_ROOT is libounce instead of libnx, so -lnx and switch.specs come from libounce.
# - The Switch 2 portlibs come before the Switch 1 portlibs.
# - __SWITCH2__ is defined (see Platform/NintendoSwitch.cmake next to this file).
#
# CMAKE_SYSTEM_NAME stays NintendoSwitch, so the project's Switch code paths apply.
#
#   cmake -B build-switch2 -G Ninja -DCMAKE_TOOLCHAIN_FILE=switch2/cmake/Switch2.cmake

cmake_minimum_required(VERSION 3.13)

set(CMAKE_SYSTEM_NAME NintendoSwitch)

if(DEFINED ENV{DEVKITPRO})
    include($ENV{DEVKITPRO}/cmake/devkitA64.cmake)
else()
    include(/opt/devkitpro/cmake/devkitA64.cmake)
endif()

if(NOT EXISTS "${DEVKITPRO}/libounce/switch.specs")
    message(FATAL_ERROR "libounce not found in ${DEVKITPRO}. Install the ounce SDK with its install.sh.")
endif()

set(NX_SWITCH2 TRUE)
set(NX_ROOT ${DEVKITPRO}/libounce)
set(NX_SWITCH2_PORTLIBS ${DEVKITPRO}/portlibs/switch2)
set(DKP_INSTALL_PREFIX_INIT ${NX_SWITCH2_PORTLIBS})

# Inserted at the front, so the search order is: switch2 portlibs, switch portlibs, libounce.
__dkp_platform_prefix(
    ${NX_SWITCH2_PORTLIBS}
    ${DEVKITPRO}/portlibs/switch
    ${NX_ROOT}
)

# Our Platform/NintendoSwitch.cmake wraps devkitPro's and adds the Switch 2 flags.
list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

find_program(PKG_CONFIG_EXECUTABLE NAMES aarch64-none-elf-pkg-config
    HINTS "${NX_SWITCH2_PORTLIBS}/bin" "${DEVKITPRO}/portlibs/switch/bin")
if(NOT PKG_CONFIG_EXECUTABLE)
    message(FATAL_ERROR "Could not find aarch64-none-elf-pkg-config: try installing switch-pkg-config")
endif()

find_program(NX_ELF2NRO_EXE NAMES elf2nro HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_ELF2KIP_EXE NAMES elf2kip HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_ELF2NSO_EXE NAMES elf2nso HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_BUILD_PFS0_EXE NAMES build_pfs0 HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_NACPTOOL_EXE NAMES nacptool HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_NPDMTOOL_EXE NAMES npdmtool HINTS "${DEVKITPRO}/tools/bin")
find_program(NX_UAM_EXE NAMES uam HINTS "${DEVKITPRO}/tools/bin")

find_file(NX_DEFAULT_ICON NAMES default_icon.jpg HINTS "${NX_ROOT}" NO_CMAKE_FIND_ROOT_PATH)

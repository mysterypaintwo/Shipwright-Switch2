# Switch 2 platform settings. Loaded instead of devkitPro's Platform/NintendoSwitch.cmake
# when the Switch2.cmake toolchain is used. It loads devkitPro's file, then adds the
# Switch 2 define and puts the Switch 2 portlibs first on the library path.

include_guard(GLOBAL)

include(${DEVKITPRO}/cmake/Platform/NintendoSwitch.cmake)

set(NX_COMMON_FLAGS "${NX_COMMON_FLAGS} -D__SWITCH2__")
set(NX_LINKER_FLAGS "-L${NX_SWITCH2_PORTLIBS}/lib ${NX_LINKER_FLAGS}")
set(NX_STANDARD_INCLUDE_DIRECTORIES "${NX_ROOT}/include;${NX_SWITCH2_PORTLIBS}/include")

__dkp_init_platform_settings(NX)

if(NOT DKP_PLATFORM_BOOTSTRAP)
    foreach(lang IN ITEMS C CXX ASM)
        set(CMAKE_${lang}_STANDARD_INCLUDE_DIRECTORIES "${NX_STANDARD_INCLUDE_DIRECTORIES}" CACHE STRING "" FORCE)
    endforeach()
endif()

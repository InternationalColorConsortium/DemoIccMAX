#################################################################################
# Cmake Configuration for: Build/Cmake/vcpkg-toolchain.cmake | iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# 
#
#  Last Updated: 24-MAR-2025 1222 EDT by David Hoyt
#  date -d @1742833338
#  Mon Mar 24 12:22:18 EDT 2025
#
#  Changes: Minimized for Production, Logging is Verbose, Default
#           Added to CMakelists.txt: IccPngDump
#           Adjusted Cross Platform Build Args
#						
#  TODO:    Refactor Debug, Release, Asan, subproject pathing issues
#           Collapse 3-tier CMakeLists.txt, Housekeeping
#           Refactor Base Configs & logging to .mk's 
#
#
#################################################################################

# Allow user to override VCPKG_ROOT via environment or CLI
if(NOT DEFINED VCPKG_ROOT)
    if(DEFINED ENV{VCPKG_ROOT})
        set(VCPKG_ROOT "$ENV{VCPKG_ROOT}" CACHE PATH "Root path to vcpkg")
    else()
        message(FATAL_ERROR "VCPKG_ROOT is not defined. Please set it via environment variable or cmake -DVCPKG_ROOT=...")
    endif()
endif()

set(VCPKG_TARGET_TRIPLET "x64-windows" CACHE STRING "Triplet for vcpkg builds")

set(VCPKG_INCLUDE_DIR "${VCPKG_ROOT}/installed/${VCPKG_TARGET_TRIPLET}/include" CACHE PATH "Vcpkg include dir")
set(VCPKG_LIB_DIR "${VCPKG_ROOT}/installed/${VCPKG_TARGET_TRIPLET}/lib" CACHE PATH "Vcpkg lib dir")

# Multi-core builds (optional: MSVC specific optimization)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL" CACHE STRING "Use /MD runtime")
add_compile_options(/MP)  # Enable multiprocessor compilation

# Core Debug/Dev Flags
set(COMMON_FLAGS "/Zi /Od /RTC1 /Gm- /nologo /diagnostics:column /utf-8 /FC /FS /MD")

# Optional: Enable sanitizers (ASan/UBSan for Clang/GCC, MSVC equivalent via instrumentation flags)
set(SANITIZE_FLAGS "")
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(SANITIZE_FLAGS "-fsanitize=address,undefined -fno-omit-frame-pointer")
endif()

# Optional: Logging/coverage flags (Linux/Clang/LLVM-based)
set(LOGGING_FLAGS "")
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(LOGGING_FLAGS "-fprofile-instr-generate -fcoverage-mapping")
endif()

# Combine all C/C++ flags
set(CMAKE_C_FLAGS "${COMMON_FLAGS} /I \"${VCPKG_INCLUDE_DIR}\" ${SANITIZE_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} /I \"${VCPKG_INCLUDE_DIR}\" ${SANITIZE_FLAGS} ${LOGGING_FLAGS}" CACHE STRING "")

# Linker Flags
set(CMAKE_SHARED_LINKER_FLAGS "/DEBUG /LIBPATH:\"${VCPKG_LIB_DIR}\"" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "/DEBUG /LIBPATH:\"${VCPKG_LIB_DIR}\"" CACHE STRING "")

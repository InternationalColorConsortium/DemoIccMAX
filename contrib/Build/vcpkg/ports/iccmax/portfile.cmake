## ports/iccmax/portfile.cmake
##
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt
## Date: 25-APRIL-2025 1000 EDT
#
# Branch: PR129
# Intent: ports/iccmax/portfile.cmake
# Production: TRUE
# Runner: TRUE
#
#
#
#
#
#
#
#
##

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/DemoIccMAX
    REF 16741a7083b433646aa8ee29a0574b1eb6213396
    SHA512 a948868a7067710b8f76af26a07ce95d12449ac2ff14323562a4f6881142ec1a144f85117dda3df88232623abdb476a0b6512d98a02b769a17d3cb65a41aca2c
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    GENERATOR "Unix Makefiles"
    OPTIONS
        -DENABLE_TOOLS=ON
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
)

vcpkg_cmake_build()
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    CONFIG_PATH lib/cmake/reficcmax
)

# Correct LICENSE installation
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# Known necessary policy suppressions
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
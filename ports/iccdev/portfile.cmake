# portfile.cmake

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/DemoIccMAX
    REF 4c0949c23631ca449f480da80630c34765fb61c7
    SHA512 28914abb4add566dacaf13f217508a20883b12ef5c7981bafb542cc71e108dbc50bae7374e6582b0bc4467004400e3566b0f1165f0fb403eb6a76ef87fc49600
)

# Make libxml2/iconv headers visible
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")

# Common options for one configure
set(_COMMON_OPTS
    -DENABLE_TESTS=OFF
    -DENABLE_INSTALL_RIM=ON
    -DENABLE_ICCXML=ON
    -DENABLE_SHARED_LIBS=ON
    -DENABLE_STATIC_LIBS=ON
    -DENABLE_TOOLS=ON
    -DCMAKE_DEBUG_POSTFIX=
    # Hint paths if upstream does any find_library fallback
    "-DCMAKE_PREFIX_PATH=${CURRENT_PACKAGES_DIR};${CURRENT_INSTALLED_DIR}"
    "-DCMAKE_LIBRARY_PATH=${CURRENT_PACKAGES_DIR}/lib;${CURRENT_PACKAGES_DIR}/debug/lib"
    "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
    # CRITICAL: tell IccXML to link the *target*, not a raw .lib path
    -DTARGET_LIB_ICCPROFLIB=IccProfLib2
)

# DO NOT override MSVC runtime; keep vcpkg defaults (/MD, /MDd)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS ${_COMMON_OPTS}
)

# --- Stage 1:
# If upstream ever renames these, swap the target names accordingly.
vcpkg_cmake_build(TARGET IccProfLib2)   # core color lib
vcpkg_cmake_build(TARGET IccXML2)       # XML lib depends on the core lib
vcpkg_cmake_install()

# --- Stage 2: 
vcpkg_cmake_build(TARGET iccApplyToLink)
vcpkg_cmake_build(TARGET iccDumpProfile)
vcpkg_cmake_build(TARGET iccFromCube)
vcpkg_cmake_build(TARGET iccFromXml)
vcpkg_cmake_build(TARGET iccRoundTrip)
vcpkg_cmake_build(TARGET iccToXml)
vcpkg_cmake_build(TARGET iccV5DspObsToV4Dsp)
vcpkg_cmake_install()

# Stage CLI tools under tools/<port>
vcpkg_copy_tools(
    TOOL_NAMES
        iccApplyToLink
        iccDumpProfile
        iccFromCube
        iccFromXml
        iccRoundTrip
        iccToXml
        iccV5DspObsToV4Dsp
    AUTO_CLEAN
)

# Fix CMake package layout if upstream uses a custom subdir
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

# Housekeeping
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# Policies actually needed
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)

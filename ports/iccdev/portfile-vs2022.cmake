vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/DemoIccMAX
    REF 4c0949c23631ca449f480da80630c34765fb61c7
    SHA512 28914abb4add566dacaf13f217508a20883b12ef5c7981bafb542cc71e108dbc50bae7374e6582b0bc4467004400e3566b0f1165f0fb403eb6a76ef87fc49600
)


# Inject include paths to satisfy libxml2's iconv.h dependency
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS
        -DENABLE_TOOLS=ON
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
        "-DCMAKE_C_FLAGS=/I${CURRENT_INSTALLED_DIR}/include"
        "-DCMAKE_CXX_FLAGS=/I${CURRENT_INSTALLED_DIR}/include"
    OPTIONS_RELEASE -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
    OPTIONS_DEBUG -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug
)

vcpkg_cmake_build()
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)

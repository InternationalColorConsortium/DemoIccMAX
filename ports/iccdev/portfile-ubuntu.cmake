vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/DemoIccMAX
    REF 4c0949c23631ca449f480da80630c34765fb61c7
    SHA512 28914abb4add566dacaf13f217508a20883b12ef5c7981bafb542cc71e108dbc50bae7374e6582b0bc4467004400e3566b0f1165f0fb403eb6a76ef87fc49600
)

# Prepare MSVC-specific runtime flags conditionally
if (VCPKG_TARGET_IS_WINDOWS)
    set(msvc_runtime_release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded)
    set(msvc_runtime_debug   -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug)
else()
    set(msvc_runtime_release "")
    set(msvc_runtime_debug "")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS
        -DENABLE_TOOLS=ON
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
    OPTIONS_RELEASE ${msvc_runtime_release}
    OPTIONS_DEBUG   ${msvc_runtime_debug}
)

vcpkg_cmake_build()
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)

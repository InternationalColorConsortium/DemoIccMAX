#
# Written by : David Hoyt for DemoIccMAX Project
#
#
# Place file in location: vcpkg/triplets/community/x64-windows-asan.cmake
#
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# Enable AddressSanitizer
add_compile_options(-fsanitize=address)
add_link_options(-fsanitize=address)

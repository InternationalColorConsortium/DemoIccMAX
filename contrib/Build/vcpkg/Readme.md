
# VCPKG Contrib Directory for DemoIccMAX Project

This directory contains custom triplet files and a PowerShell script to install **vcpkg** dependencies for the DemoIccMAX project. The custom triplets and installation script are designed to provide support for multiple configurations, including static and dynamic linking, release and debug builds, and AddressSanitizer (ASAN).

## Files

- **Custom Triplets**:
  - `x64-windows-release.cmake`: Dynamic linking in release mode.
  - `x64-windows-static-md-release.cmake`: Static linking with dynamic runtime (`/MD`) in release mode.
  - `x64-windows-asan.cmake`: Dynamic linking with AddressSanitizer (ASAN) enabled in release mode.
  - `x64-windows-asan-debug.cmake`: Dynamic linking with AddressSanitizer (ASAN) enabled in debug mode.

- **PowerShell Script**:
  - `install_vcpkg_deps.ps1`: Script to install **vcpkg** dependencies for the project using the custom triplets.

## Usage Instructions

### 1. Install Dependencies Using the PowerShell Script

To install all the necessary **vcpkg** dependencies with support for different build configurations (release, debug, static, dynamic, ASAN), run the `install_vcpkg_deps.ps1` script.

#### Steps:

1. **Clone the vcpkg repository** (if you haven't already):
   ```bash
   git clone https://github.com/microsoft/vcpkg
   ```

2. **Bootstrap vcpkg**:
   ```bash
   ./vcpkg/bootstrap-vcpkg.bat
   ```

### 2. Custom Triplet Descriptions

#### Custom Triplets Provided:

- **x64-windows-release.cmake**: Builds with dynamic linking in release mode.
- **x64-windows-static-md-release.cmake**: Builds with static linking and dynamic runtime (`/MD`) in release mode.
- **x64-windows-asan.cmake**: Enables AddressSanitizer (ASAN) for detecting memory issues in dynamic release builds.
- **x64-windows-asan-debug.cmake**: Enables ASAN in debug mode for dynamic linking.

### 3. Add Triplets to Your vcpkg Environment

To use the custom triplets, you need to place them in the correct **vcpkg** triplet directory. The triplets are placed in the `contrib` directory, you can copy or link them into `vcpkg/triplets/community/` or reference the path directly.

For example:

1. **Copy or move the custom triplets**:
   ```bash
   cp contrib/Build/vcpkg/x64-windows-release.cmake path_to_vcpkg/triplets/community/
   ```

2. **Install a specific triplet manually** (if needed):
```
  vcpkg install --triplet x64-windows-static-release 
  vcpkg install --triplet x64-windows
  vcpkg install --triplet x64-windows-release
  vcpkg install --triplet x64-windows-static-md-release
  vcpkg install --triplet x64-windows-static-md 
  vcpkg install --triplet x64-windows-asan-debug 
  vcpkg install --triplet x64-windows-static
  vcpkg install --triplet x64-windows-asan
```

### 4. Install Triplets
```
$env:VCPKG_ROOT

C:\Program Files\Microsoft Visual Studio\2022\Community\VC\vcpkg

vcpkg list
egl-registry:x64-windows                          2024-01-25          EGL API and Extension Registry
egl-registry:x64-windows-static                   2024-01-25          EGL API and Extension Registry
expat:x64-windows                                 2.6.3               XML parser library written in C
expat:x64-windows-static                          2.6.3               XML parser library written in C
libiconv:x64-windows                              1.17#4              GNU Unicode text conversion
libiconv:x64-windows-static                       1.17#4              GNU Unicode text conversion
libjpeg-turbo:x64-windows                         3.0.4               libjpeg-turbo is a JPEG image codec that uses SI...
libjpeg-turbo:x64-windows-static                  3.0.4               libjpeg-turbo is a JPEG image codec that uses SI...
liblzma:x64-windows                               5.6.3               Compression library with an API similar to that ...
liblzma:x64-windows-static                        5.6.3               Compression library with an API similar to that ...
libpng:x64-windows                                1.6.43#3            libpng is a library implementing an interface fo...
libpng:x64-windows-static                         1.6.43#3            libpng is a library implementing an interface fo...
libxml2:x64-windows                               2.11.9              Libxml2 is the XML C parser and toolkit develope...
libxml2:x64-windows-static                        2.11.9              Libxml2 is the XML C parser and toolkit develope...
libxml2[iconv]:x64-windows                                            Add ICONV support
libxml2[iconv]:x64-windows-static                                     Add ICONV support
libxml2[lzma]:x64-windows                                             Use LZMA
libxml2[lzma]:x64-windows-static                                      Use LZMA
libxml2[zlib]:x64-windows                                             Use ZLib
libxml2[zlib]:x64-windows-static                                      Use ZLib
nanosvg:x64-windows                               2023-12-29          NanoSVG is a simple stupid single-header-file SV...
nanosvg:x64-windows-static                        2023-12-29          NanoSVG is a simple stupid single-header-file SV...
nlohmann-json:x64-windows                         3.11.3#1            JSON for Modern C++
nlohmann-json:x64-windows-static                  3.11.3#1            JSON for Modern C++
opengl-registry:x64-windows                       2024-02-10#1        OpenGL, OpenGL ES, and OpenGL ES-SC API and Exte...
opengl-registry:x64-windows-static                2024-02-10#1        OpenGL, OpenGL ES, and OpenGL ES-SC API and Exte...
opengl:x64-windows                                2022-12-04#3        Open Graphics Library (OpenGL)[3][4][5] is a cro...
opengl:x64-windows-static                         2022-12-04#3        Open Graphics Library (OpenGL)[3][4][5] is a cro...
pcre2:x64-windows                                 10.43               Regular Expression pattern matching using the sa...
pcre2:x64-windows-static                          10.43               Regular Expression pattern matching using the sa...
pcre2[jit]:x64-windows                                                Enable support for Just-In-Time compiling regex ...
pcre2[jit]:x64-windows-static                                         Enable support for Just-In-Time compiling regex ...
pcre2[platform-default-features]:x64-windows                          Enable default features
pcre2[platform-default-features]:x64-windows-st...                    Enable default features
tiff:x64-windows                                  4.7.0               A library that supports the manipulation of TIFF...
tiff:x64-windows-static                           4.7.0               A library that supports the manipulation of TIFF...
tiff[jpeg]:x64-windows                                                Support JPEG compression in TIFF image files
tiff[jpeg]:x64-windows-static                                         Support JPEG compression in TIFF image files
tiff[lzma]:x64-windows                                                Support LZMA compression in TIFF image files
tiff[lzma]:x64-windows-static                                         Support LZMA compression in TIFF image files
tiff[zip]:x64-windows                                                 Support ZIP/deflate compression in TIFF image files
tiff[zip]:x64-windows-static                                          Support ZIP/deflate compression in TIFF image files
vcpkg-cmake-config:x64-windows                    2024-05-23
vcpkg-cmake:x64-windows                           2024-04-23
wxwidgets:x64-windows                             3.2.6               Widget toolkit and tools library for creating gr...
wxwidgets:x64-windows-static                      3.2.6               Widget toolkit and tools library for creating gr...
wxwidgets[debug-support]:x64-windows                                  Enable wxWidgets debugging support hooks even fo...
wxwidgets[debug-support]:x64-windows-static                           Enable wxWidgets debugging support hooks even fo...
wxwidgets[sound]:x64-windows                                          Build wxSound support
wxwidgets[sound]:x64-windows-static                                   Build wxSound support
zlib:x64-windows                                  1.3.1               A compression library
zlib:x64-windows-static                           1.3.1               A compression library
```

### 5. MSBuild Example | VS2022C

```
msbuild /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
```

### Build Result

```
Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:22.29
```

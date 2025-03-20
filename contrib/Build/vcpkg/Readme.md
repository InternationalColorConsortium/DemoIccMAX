
# 🧰 Setting up `vcpkg` for IccMAX

This document will help you set up the `vcpkg` dependency manager for the IccMAX project and configure a CMake-based build using either MSVC (Windows) or Clang/GCC (Linux/macOS).

---

## 🔧 Prerequisites

- Git
- CMake ≥ 3.21
- Compiler: MSVC (Windows), GCC or Clang (Linux/macOS)
- PowerShell (Windows) or Bash-compatible shell (Linux/macOS)

---

## 📦 Step 1: Clone and Bootstrap vcpkg

```
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh        # Linux/macOS
.\bootstrap-vcpkg.bat       # Windows
./vcpkg integrate install
```

---

## 📚 Step 2: Install Required Packages

> Required for DemoIccMAX: PNG, XML, TIFF, wxWidgets, JSON

### Windows

```
vcpkg.exe install `
  libpng `
  nlohmann-json:x64-windows `
  nlohmann-json:x64-windows-static `
  libxml2:x64-windows `
  libxml2:x64-windows-static `
  tiff:x64-windows `
  tiff:x64-windows-static `
  wxwidgets:x64-windows `
  wxwidgets:x64-windows-static
```

### Linux/macOS

```bash
./vcpkg install libpng libxml2 nlohmann-json tiff wxwidgets
```

---

## 🛠️ Step 3: Configure with CMake

### Windows (MSVC)

```
cd DemoIccMAX\Build\Cmake\
cmake -S . -B build -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_TOOLCHAIN_FILE=path/to/vcpkg/scripts/buildsystems/vcpkg.cmake `
  -DCMAKE_BUILD_TYPE=Release `
  -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON
```

### Linux/macOS

```
cd DemoIccMAX/Build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug   -DCMAKE_TOOLCHAIN_FILE=path/to/vcpkg/scripts/buildsystems/vcpkg.cmake   -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON
```

---

## 🧪 Step 4: Build the Project

```bash
cmake --build build --config Release -j$(nproc)
```

---

## 🧼 Cleanup

To remove installed packages:

```bash
./vcpkg remove --outdated
```

---

## 🔍 Notes

- The vcpkg integration ensures both static and shared builds are supported.
- You can use the `--graphviz=output.dot` option during configuration to visualize target dependencies.

---

_Contributions welcome!_

---

This directory also contains custom triplet files and a PowerShell script to install **vcpkg** dependencies for the IccMAX project. The custom triplets and installation script are designed to provide support for multiple configurations, including static and dynamic linking, release and debug builds, and AddressSanitizer (ASAN).


#### Custom Triplets Provided:

- **x64-windows-release.cmake**: Builds with dynamic linking in release mode.
- **x64-windows-static-md-release.cmake**: Builds with static linking and dynamic runtime (`/MD`) in release mode.
- **x64-windows-asan.cmake**: Enables AddressSanitizer (ASAN) for detecting memory issues in dynamic release builds.
- **x64-windows-asan-debug.cmake**: Enables ASAN in debug mode for dynamic linking.

### Add Triplets to Your vcpkg Environment

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

### Install Triplets
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

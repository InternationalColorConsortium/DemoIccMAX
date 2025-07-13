# `iccMAX Version 2.2.6`

##### Target Review Date: 15-MAY-2025

[PR129](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/129) addressed Bug Classes and other Housekeeping.

### Homebrew Formula

**brew install iccmax**

Coming Soon: vcpkg install iccmax


### [Triples Testing Summary](https://github.com/xsscx/PatchIccMAX/actions)

This table captures the architecture, kernel, and environment triples across macOS, iOS, Linux, Windows, and ARM SoCs for reproducible builds and CI validation.

| **Operating System**         | **Kernel Version**                               | **Architecture**     | **Environment**                       |
|-----------------------------|--------------------------------------------------|----------------------|---------------------------------------|
| Linux (Ubuntu 24.04 LTS)     | Linux Kernel 6.8.0-31-generic (glibc)   | x86_64           | Homebrew Test-Bot Container (Ubuntu) |
| macOS 15 Sequoia             | Darwin Kernel Version 24.0.0            | ARM64            | macOS 15-arm64 Runner              |
| macOS 15 Sequoia             | Darwin Kernel Version 24.0.0            | x86_64           | macOS 15-x86_64 Runner             |
| macOS 14 Sonoma              | Darwin Kernel Version 23.0.0            | ARM64            | macOS 14-arm64 Runner              |
| macOS 14 Sonoma              | Darwin Kernel Version 23.0.0            | x86_64           | macOS 14-x86_64 Runner             |
| macOS 13 Ventura             | Darwin Kernel Version 22.0.0            | ARM64            | macOS 13-arm64 Runner              |
| macOS 13 Ventura             | Darwin Kernel Version 22.0.0            | x86_64           | macOS 13-x86_64 Runner             |
| iOS (iPhone 16 Pro Max) | Darwin Kernel Version 24.4.0 (iOS 18.4)          | arm64e               | iOS_ARM64E_A18_PRO                    |
| iOS (iPad Pro M4)     | Darwin Kernel Version 24.4.0 (iPadOS 18.4)       | arm64                | iOS_ARM64_M4_IPAD_PRO                 |
| WSL2 (Linux)                | 5.15.167.4-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro    | Version 10.0.26100 Build 26100                   | x86_64               | Visual Studio 17.13.6                 |
| Microsoft Windows 11 ARM    | Version 10.0.26100 Build 26100                   | ARM64            | windows-11-arm GitHub Runner      |
| Raspberry Pi OS (Debian)    | Linux 6.1.21-v8+ #1642 SMP PREEMPT               | aarch64 (ARMv8)      | GCC 10.2.1 (Debian 10.2.1-6)          |

### PR Refactor Summary

**Scan Build**

`Ubuntu clang version 18.1.3 (1ubuntu1)`
	
| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 67                 | 47                    |
| **Logic Error**  | Assigned value is garbage         | 1                  | -                    |
|                  | Dereference of null pointer       | 1                  | -                    |
|                  | Garbage return value              | 1                  | -                    |
|                  | Result of op is garbage/undefined | 4                  | -                    |
|                  | Uninitialized argument value      | 3                  | -                    |
| **Memory Error** | Double delete                     | 1                  | -                    |
|                  | Memory leak                       | 1                  | -                    |
|                  | Use of zero allocated             | 1                  | -                    |
|                  | Use-after-free                    | 2                  | -                    |
| **Unused Code**  | Dead assignment                   | 24                 | 21                   |
|                  | Dead increment                    | 4                  | 4                    |
|                  | Dead initialization               | 22                 | 20                   |
|                  | Dead nested assignment            | 2                  | 2                    |

**Code Audit**

| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 874                 | 848                 |
| **Other**        | Code Review, CodeQL Bugs          | 860                 | 840                 |
| **Heap or Stack**  | Over, Under, Other              | 14                  | 8                   |


---

## AFL Build

```
[*] Verifying tool instrumentation...
[PASS] iccToXml/iccToXml_test is instrumented
[PASS] iccFromXml/iccFromXml_test is instrumented
[PASS] iccDumpProfile/iccDumpProfile_test is instrumented
[PASS] iccRoundTrip/iccRoundTrip_afl is instrumented
[PASS] iccApplyNamedCmm/iccApplyNamedCmm_afl is instrumented
[PASS] iccApplyProfiles/iccApplyProfiles_afl is instrumented
[PASS] iccTiffDump/iccTiffDump_afl is instrumented
[PASS] iccPngDump/iccPngDump_afl is instrumented
```

---

## icc XML HTTP Service

RESTful service for bidirectional conversion between ICC XML and .icc using iccMAX.

---

### 📌 icc XHR Features

- **POST endpoints** for ICC XML → `.icc` and `.icc` → XML
- Built on the **iccMAX reference implementation**
- Enables structured roundtrip validation
- Exposes **HTTP interfaces** for fuzzing, CI, and test automation
- Supports integration with tools like **AFL**, **Burp Suite**, and custom harnesses
- Logs stderr, exit codes, and raw inputs for postmortem and traceability
- Foundation for expanding **iccMAX tooling as network services**

## 🧪 Fuzzing-Ready

This service is ready for fuzzing with:

- **Burp Suite**
- **AFLNet**
- **REST API fuzzers**
- Your custom toolchains


### Sample Output


```
F:\pr129\PatchIccMAX\Build\iis>run_service.bat

[*] Starting ICC XML HTTP Service on: http://localhost:8182/icctoxml

[+] Service listening at: http://localhost:8182/icctoxml
[+] Received POST request
[+] Extracted UTF-8 body, size: 134591
[+] Received POST request
[+] Extracted UTF-8 body, size: 43245
[+] Received POST request
[+] Extracted UTF-8 body, size: 8544
...
XML successfully created
XML successfully created
Unable to read 'temp_input.icc'
Unable to read 'temp_input.icc'
...
XML successfully created
XML successfully created
```

---

## 🔒 Security Notes

- Input size is not validated — use in isolated test environments.
- XML parser is libxml2 — known to tolerate many malformed patterns.

---

## Build Reproductions

### WSL-2 Ubuntu24

With X11 Libs, Asan + Logging:

```
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DCMAKE_BUILD_TYPE=Debug \
  -DENABLE_TOOLS=ON \
  -DENABLE_SHARED_LIBS=ON \
  -DENABLE_STATIC_LIBS=ON \
  -DENABLE_TESTS=ON \
  -DENABLE_INSTALL_RIM=ON \
  -DENABLE_ICCXML=ON \
  -DCMAKE_CXX_FLAGS="-DICC_CLUT_DEBUG \
  -Wno-dev \
  -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
  -DCMAKE_EXE_LINKER_FLAGS="-lX11" \
  Cmake/
make -j$(nproc)
cd ../Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### Ubuntu24 | GNU

```
cd /tmp
export CC=clang
export CXX=clang++
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/129/head:pr-129
git checkout pr-129
cd Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ../Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

#### Expected Output

```
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -print `` 
```

```
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccRoundTrip/iccRoundTrip
./Tools/wxProfileDump/iccDumpProfileGui
./Tools/IccPngDump/iccPngDump
./Tools/IccFromXml/iccFromXml
./Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
./Tools/IccFromCube/iccFromCube
./Tools/IccToXml/iccToXml
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccApplyToLink/iccApplyToLink
./Tools/IccApplyProfiles/iccApplyProfiles
./Tools/IccTiffDump/iccTiffDump
./IccXML/libIccXML2-static.a
./IccXML/libIccXML2.so.2.1.25
./IccProfLib/libIccProfLib2-static.a
./IccProfLib/libIccProfLib2.so.2.1.25
```


```
find ./build_* -type d -depth 1 ! -name "*CMakeFiles*" | sort
```

```
./build_Debug/IccProfLib
./build_Debug/IccXML
./build_Debug/Testing
./build_Debug/Tools
./build_MinSizeRel/IccProfLib
./build_MinSizeRel/IccXML
./build_MinSizeRel/Testing
./build_MinSizeRel/Tools
./build_RelWithDebInfo/IccProfLib
./build_RelWithDebInfo/IccXML
./build_RelWithDebInfo/Testing
./build_RelWithDebInfo/Tools
./build_Release/IccProfLib
./build_Release/IccXML
./build_Release/Testing
./build_Release/Tools
```


---

### macOS | Brew | x86_64

```
[2025-04-25 11:18:17] $ mkdir -p $(brew --repo local/iccmax)/Formula
cp iccmax.rb $(brew --repo local/iccmax)/Formula/

[2025-04-25 11:18:19] $ brew install local/iccmax/iccmax
==> Fetching local/iccmax/iccmax
==> Downloading https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/heads/master.tar.gz
Already downloaded: /Users/xss/Library/Caches/Homebrew/downloads/5677725d337abfaee5e353c5810ceae07fe8e8f518f64e0d09e596ea040541cd--DemoIccMAX-master.tar.gz
==> Installing iccmax from local/iccmax
==> cmake CMake -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON
==> make -j12
==> make install
🍺  /usr/local/Cellar/iccmax/2.3.0: 75 files, 5.2MB, built in 29 seconds
==> Running `brew cleanup iccmax`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
[2025-04-25 11:18:55] $ brew audit --strict --new --online local/iccmax/iccmax
[2025-04-25 11:19:09] $ more iccmax.rb
class Iccmax < Formula
  desc "Reference implementation tools for iccMAX"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/heads/master.tar.gz"
  version "2.3.0"
  sha256 "87075b823062048acc96dd0ed50ac529511d4627d75becd9ed4e449630a301a8"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "nlohmann-json"
  depends_on "wxwidgets"

  def install
    mkdir "Build" do
      system "cmake", "CMake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", \
                      "-DCMAKE_BUILD_TYPE=Release", \
                      "-DENABLE_TOOLS=ON", \
                      "-DENABLE_SHARED_LIBS=ON", \
                      "-DENABLE_STATIC_LIBS=ON", \
                      "-DENABLE_TESTS=ON", \
                      "-DENABLE_INSTALL_RIM=ON", \
                      "-DENABLE_ICCXML=ON", \
                      "-Wno-dev"

      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/iccDumpProfile", "--help"
  end
end
[2025-04-25 11:19:48] $
```

## macOS | Brew | arm64

```
xss@macbookpro brew % brew uninstall iccmax
Uninstalling /opt/homebrew/Cellar/iccmax/2.1.26... (75 files, 5.5MB)
==> Autoremoving 10 unneeded formulae:
docbook
docbook-xsl
gl2ps
gnu-getopt
jpeg
libffi
libgit2@1.8
libtommath
tcl-tk
xmlto
Uninstalling /opt/homebrew/Cellar/xmlto/0.0.29... (47 files, 182.6KB)
Uninstalling /opt/homebrew/Cellar/tcl-tk/9.0.1... (3,150 files, 38MB)
Uninstalling /opt/homebrew/Cellar/libgit2@1.8/1.8.4... (106 files, 4.7MB)
Uninstalling /opt/homebrew/Cellar/jpeg/9f... (21 files, 900.9KB)
Uninstalling /opt/homebrew/Cellar/gl2ps/1.4.2... (16 files, 318.2KB)
Uninstalling /opt/homebrew/Cellar/libffi/3.4.7... (18 files, 782KB)
Uninstalling /opt/homebrew/Cellar/libtommath/1.3.0... (12 files, 530.6KB)
Uninstalling /opt/homebrew/Cellar/gnu-getopt/2.41... (13 files, 168.5KB)
Uninstalling /opt/homebrew/Cellar/docbook-xsl/1.79.2_1... (4,910 files, 94.0MB)
Uninstalling /opt/homebrew/Cellar/docbook/5.1_1... (199 files, 8.9MB)
xss@macbookpro brew %  brew install --build-from-source iccmax.rb
Error: Failed to load cask: iccmax.rb
Cask 'iccmax' is unreadable: wrong constant name #<Class:0x000000012e95bb98>
Warning: Treating iccmax.rb as a formula.
==> Fetching iccmax
==> Downloading https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/heads/master.tar.gz
Already downloaded: /Users/xss/Library/Caches/Homebrew/downloads/5677725d337abfaee5e353c5810ceae07fe8e8f518f64e0d09e596ea040541cd--DemoIccMAX-master.tar.gz
==> cmake CMake -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABL
==> make -j8
==> make install
🍺  /opt/homebrew/Cellar/iccmax/2.1.26: 75 files, 5.5MB, built in 16 seconds
==> Running `brew cleanup iccmax`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
xss@macbookpro brew %
```

---

### Windows | MSVC

#### Prerequisites

- Windows 10/11
- Visual Studio 2022 (with C++ Desktop Development workload)
- PowerShell
- Administrator or Developer command prompt

---

#### Setup: Environment & Dependencies

```
mkdir C:\test\
cd C:\test\
```

### Clone vcpkg and bootstrap

```
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat -disableMetrics
.\vcpkg.exe integrate install
```

#### Install required libraries (both dynamic and static)

```
.\vcpkg.exe install `
  libpng `
  nlohmann-json:x64-windows `
  nlohmann-json:x64-windows-static `
  libxml2:x64-windows `
  libxml2:x64-windows-static `
  tiff:x64-windows `
  tiff:x64-windows-static `
  wxwidgets:x64-windows `
  wxwidgets:x64-windows-static `
  libjpeg-turbo:x64-windows `
  libjpeg-turbo:x64-windows-static
```

### Clone, Configure and Build

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/129/head:pr-129
git checkout pr-129
cd Build
mkdir win
cd win
# ---- BASE PATH SETUP ----
$base = Get-Location
$sourceDir = Resolve-Path "$base\..\Cmake"
$toolchain = "C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake"
$vcpkgInclude = "C:/test/vcpkg/installed/x64-windows/include"
$vcpkgLib = "C:/test/vcpkg/installed/x64-windows/lib"

# ---- CONFIG TO RUNTIME MAP ----
$configs = @{
  "Debug"        = "MultiThreadedDebugDLL"
  "Release"      = "MultiThreadedDLL"
  "RelWithDebInfo" = "MultiThreadedDLL"
  "MinSizeRel"   = "MultiThreadedDLL"
}

# ---- PER CONFIG BUILD LOOP ----
foreach ($cfg in $configs.Keys) {
    $outDir = "$base\build_$cfg"

    # Clean build dir
    if (-Not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    Set-Location $outDir
    Remove-Item -Recurse -Force .\CMakeCache.txt, .\CMakeFiles -ErrorAction SilentlyContinue

    # ---- CONFIGURE ----
    cmake -S $sourceDir -B . -G "Visual Studio 17 2022" -A x64 `
      "-DCMAKE_BUILD_TYPE=$cfg" `
      "-DCMAKE_TOOLCHAIN_FILE=$toolchain" `
      "-DCMAKE_C_FLAGS=/Od /Zi /I $vcpkgInclude" `
      "-DCMAKE_CXX_FLAGS=/Od /Zi /I $vcpkgInclude" `
      "-DCMAKE_SHARED_LINKER_FLAGS=/LIBPATH:$vcpkgLib" `
      "-DCMAKE_MSVC_RUNTIME_LIBRARY=$($configs[$cfg])" `
      -DENABLE_TOOLS=ON `
      -DENABLE_SHARED_LIBS=ON `
      -DENABLE_STATIC_LIBS=ON `
      -DENABLE_TESTS=ON `
      -DENABLE_INSTALL_RIM=ON `
      -DENABLE_ICCXML=ON `
      -DENABLE_SPECTRE_MITIGATION=OFF `
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
      "--graphviz=iccMAX-$cfg.dot"

    # ---- BUILD ----
    Write-Host "`n>>>>> Building $cfg configuration <<<<<" -ForegroundColor Green
    cmake --build . --config $cfg -- /m /maxcpucount:32

    Set-Location $base
}

```

#### View Output

Command:

```
Get-ChildItem -Recurse -Include *.exe  | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
Get-ChildItem -Recurse -Include *.lib  | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
Get-ChildItem -Recurse -Include *.exe,*.lib | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
```

## Git Diff Summary: `master...pr-129`

```
git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
git checkout pr129
git diff --stat origin/master...
```

### Ubuntu Cmake Example | Debug Logging + X11 Libs

```
cmake \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DCMAKE_BUILD_TYPE=Debug \
  -DENABLE_TOOLS=ON \
  -DENABLE_SHARED_LIBS=ON \
  -DENABLE_STATIC_LIBS=ON \
  -DENABLE_TESTS=ON \
  -DENABLE_INSTALL_RIM=ON \
  -DENABLE_ICCXML=ON \
  -DICC_TRACE_NAN_ENABLED=ON \
  -DICC_CLUT_DEBUG=ON \
  -DCMAKE_CXX_FLAGS="-g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer -fno-inline -Wall -Wextra -DICC_TRACE_NAN_ENABLED -DICC_CLUT_DEBUG -DICC_ENABLE_ASSERTS -DICC_LOG_SAFE" \
  -DCMAKE_EXE_LINKER_FLAGS="-lX11 -fsanitize=address,undefined" \
  Cmake/

make -j$(nproc)


```

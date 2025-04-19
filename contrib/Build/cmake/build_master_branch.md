
# Build Master Branch

## Ubuntu Overview
Clone and Build the Master Branch. 

### Manual Steps

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
```

## macOS Overview
Clone and Build the Master Branch. 

### Manual Steps

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
brew install libpng nlohmann-json libxml2 wxwidgets libtiff jpeg
cd PatchIccMAX/Build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
```

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
  wxwidgets:x64-windows-static
```

### Clone, Configure and Build

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
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

#### Sample Output

Command:

```
Get-ChildItem -Recurse -Include *.exe -Path .\build_* | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
Get-ChildItem -Recurse -Include *.lib -Path .\build_* | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
Get-ChildItem -Recurse -Include *.exe,*.lib -Path .\build_* | Where-Object { -not $_.PSIsContainer -and $_.FullName -notmatch '\\CMakeFiles\\' } | Select-Object FullName, Length | Sort-Object FullName
```

Output:

```
FullName                                                                             Length
--------                                                                             ------
build_Debug\Tools\IccApplyNamedCmm\Debug\iccApplyNamedCmm.exe                       3246080
build_Debug\Tools\IccApplyProfiles\Debug\iccApplyProfiles.exe                       3233792
build_Debug\Tools\IccApplyToLink\Debug\iccApplyToLink.exe                           2446336
build_Debug\Tools\IccDumpProfile\Debug\iccDumpProfile.exe                           2375168
build_Debug\Tools\IccFromCube\Debug\iccFromCube.exe                                 2377216
build_Debug\Tools\IccFromXml\Debug\iccFromXml.exe                                   3603456
build_Debug\Tools\IccPngDump\Debug\iccPngDump.exe                                   2368512
build_Debug\Tools\IccRoundTrip\Debug\iccRoundTrip.exe                               2379264
build_Debug\Tools\IccSpecSepToTiff\Debug\iccSpecSepToTiff.exe                       2378752
build_Debug\Tools\IccTiffDump\Debug\iccTiffDump.exe                                 2374144
build_Debug\Tools\IccToXml\Debug\iccToXml.exe                                       3181056
build_Debug\Tools\IccV5DspObsToV4Dsp\Debug\iccV5DspObsToV4Dsp.exe                   2376192
build_Debug\Tools\wxProfileDump\Debug\iccDumpProfileGui.exe                         2665984
build_MinSizeRel\Tools\IccApplyNamedCmm\MinSizeRel\iccApplyNamedCmm.exe              779776
build_MinSizeRel\Tools\IccApplyProfiles\MinSizeRel\iccApplyProfiles.exe              710656
build_MinSizeRel\Tools\IccApplyToLink\MinSizeRel\iccApplyToLink.exe                  632320
build_MinSizeRel\Tools\IccDumpProfile\MinSizeRel\iccDumpProfile.exe                  534016
build_MinSizeRel\Tools\IccFromCube\MinSizeRel\iccFromCube.exe                        536064
build_MinSizeRel\Tools\IccFromXml\MinSizeRel\iccFromXml.exe                          875520
build_MinSizeRel\Tools\IccPngDump\MinSizeRel\iccPngDump.exe                          529920
build_MinSizeRel\Tools\IccRoundTrip\MinSizeRel\iccRoundTrip.exe                      615936
build_MinSizeRel\Tools\IccSpecSepToTiff\MinSizeRel\iccSpecSepToTiff.exe               48640
build_MinSizeRel\Tools\IccTiffDump\MinSizeRel\iccTiffDump.exe                        529408
build_MinSizeRel\Tools\IccToXml\MinSizeRel\iccToXml.exe                              863232
build_MinSizeRel\Tools\IccV5DspObsToV4Dsp\MinSizeRel\iccV5DspObsToV4Dsp.exe          532992
build_MinSizeRel\Tools\wxProfileDump\MinSizeRel\iccDumpProfileGui.exe                791552
build_Release\Tools\IccApplyNamedCmm\Release\iccApplyNamedCmm.exe                    939520
build_Release\Tools\IccApplyProfiles\Release\iccApplyProfiles.exe                    856064
build_Release\Tools\IccApplyToLink\Release\iccApplyToLink.exe                        769024
build_Release\Tools\IccDumpProfile\Release\iccDumpProfile.exe                        649728
build_Release\Tools\IccFromCube\Release\iccFromCube.exe                              651776
build_Release\Tools\IccFromXml\Release\iccFromXml.exe                               1094144
build_Release\Tools\IccPngDump\Release\iccPngDump.exe                                644096
build_Release\Tools\IccRoundTrip\Release\iccRoundTrip.exe                            748032
build_Release\Tools\IccSpecSepToTiff\Release\iccSpecSepToTiff.exe                     51200
build_Release\Tools\IccTiffDump\Release\iccTiffDump.exe                              644096
build_Release\Tools\IccToXml\Release\iccToXml.exe                                   1081344
build_Release\Tools\IccV5DspObsToV4Dsp\Release\iccV5DspObsToV4Dsp.exe                649216
build_Release\Tools\wxProfileDump\Release\iccDumpProfileGui.exe                      929280
build_RelWithDebInfo\Tools\IccApplyNamedCmm\RelWithDebInfo\iccApplyNamedCmm.exe     1554432
build_RelWithDebInfo\Tools\IccApplyProfiles\RelWithDebInfo\iccApplyProfiles.exe     1550336
build_RelWithDebInfo\Tools\IccApplyToLink\RelWithDebInfo\iccApplyToLink.exe         1248768
build_RelWithDebInfo\Tools\IccDumpProfile\RelWithDebInfo\iccDumpProfile.exe         1219584
build_RelWithDebInfo\Tools\IccFromCube\RelWithDebInfo\iccFromCube.exe               1223680
build_RelWithDebInfo\Tools\IccFromXml\RelWithDebInfo\iccFromXml.exe                 1998848
build_RelWithDebInfo\Tools\IccPngDump\RelWithDebInfo\iccPngDump.exe                 1216512
build_RelWithDebInfo\Tools\IccRoundTrip\RelWithDebInfo\iccRoundTrip.exe             1222144
build_RelWithDebInfo\Tools\IccSpecSepToTiff\RelWithDebInfo\iccSpecSepToTiff.exe     1221120
build_RelWithDebInfo\Tools\IccTiffDump\RelWithDebInfo\iccTiffDump.exe               1219072
build_RelWithDebInfo\Tools\IccToXml\RelWithDebInfo\iccToXml.exe                     1810432
build_RelWithDebInfo\Tools\IccV5DspObsToV4Dsp\RelWithDebInfo\iccV5DspObsToV4Dsp.exe 1219584
build_RelWithDebInfo\Tools\wxProfileDump\RelWithDebInfo\iccDumpProfileGui.exe       1446400

                                                                        Length
--------                                                                ------
build_Debug\IccProfLib\Debug\IccProfLib2.lib                          19417988
build_Debug\IccProfLib\Debug\IccProfLib2-static.lib                   19417988
build_Debug\IccXML\Debug\IccXML2.lib                                   9581472
build_Debug\IccXML\Debug\IccXML2-static.lib                            9581472
build_MinSizeRel\IccProfLib\MinSizeRel\IccProfLib2.lib                10153282
build_MinSizeRel\IccProfLib\MinSizeRel\IccProfLib2-static.lib         10153282
build_MinSizeRel\IccXML\MinSizeRel\IccXML2.lib                         5515190
build_MinSizeRel\IccXML\MinSizeRel\IccXML2-static.lib                  5515190
build_Release\IccProfLib\Release\IccProfLib2.lib                      11180402
build_Release\IccProfLib\Release\IccProfLib2-static.lib               11180402
build_Release\IccXML\Release\IccXML2.lib                               6086536
build_Release\IccXML\Release\IccXML2-static.lib                        6086536
build_RelWithDebInfo\IccProfLib\RelWithDebInfo\IccProfLib2.lib        10723838
build_RelWithDebInfo\IccProfLib\RelWithDebInfo\IccProfLib2-static.lib 10723838
build_RelWithDebInfo\IccXML\RelWithDebInfo\IccXML2.lib                 6128702
build_RelWithDebInfo\IccXML\RelWithDebInfo\IccXML2-static.lib          6128702
```

### devenv

```
devenv .
```

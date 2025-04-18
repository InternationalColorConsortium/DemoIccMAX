[![color.org logo](ReadMeFiles/ICC_header.png "color.org")](https://color.org)

# IccMAX

## Introduction

The IccMAX project (formally known as RefIccMAX, or DemoIccMAX) provides an open source set of libraries and tools that allow for the interaction, manipulation, and application of iccMAX based color management profiles based on the [iccMAX profile specification](http://www.color.org/iccmax.xalter) in addition to legacy ICC profiles defined by [earlier ICC profile specifications](http://www.color.org/icc_specs2.xalter) and [documentation](ReadMeFiles/Readme.md).


Within the project are several libraries and tools as follows:

* Libraries that allow applications to interact with iccMAX profiles

  * IccProfLib - The IccMAX IccProfLib project represents an open source &
    cross platform reference implementation of a C++ library for reading,
    writing, applying, manipulating iccMAX color profiles defined by the [iccMAX
    profile specification](http://www.color.org/iccmax.xalter). Class and object
    interaction documentation for IccProfLib in [Doxygen](https://xss.cx/public/docs/DemoIccMAX/).

  * IccLibXML - The IccMAX IccLibXML project contains a parallel C++
    extension library (IccLibXML) which provides the ability to interact with the
    objects defined by IccProfLib using an XML representation thus allowing iccMAX
    profiles to be expressed as or created from text based XML files. Class and object
    interaction documentation for IccLibXML in [Doxygen](https://xss.cx/public/docs/DemoIccMAX/).


* Tools based upon these libraries

  For command line arguments running the application without any arguments
  will display help information about command line options.

  * IccToXML is a cross platform command line tool that allows both legacy ICC
    and iccMAX profiles to be expressed using an XML representation. This allows
    for profiles to be converted to a textual representation that can be directly
    edited using a text editor and then converted back to ICC/iccMAX profile
    formats using IccFromXML.

  * IccFromXML is a cross platform command line tool that allows both legacy ICC
    and iccMAX profiles to be created from the same XML representation provided by
    IccToXML. A schema for iccXML files is forthcoming but can be determined using
    the FromXML() and ToXML() member functions defined in IccLibXML. The
    IccFromXML tool provides a simple direct method to create and manipulate
    iccMAX based profiles.

  * IccApplyNamedCmm is a cross platform command line tool that allows a
    sequence of legacy ICC and/or iccMAX profiles to be applied to colors defined
    in a text based input profile outputting the results to the console, and can
    be redirected to a output text file. Example source text files can be found in
    Testing/ApplyDataFiles. The IccApplyNamedCmm application provides a basis for
    testing various features of iccMAX.

  * IccApplyProfiles is a cross platform command line tool that allows a sequence of
    legacy and/or iccMAX profiles to a source TIFF image resulting in a destination
    TIFF image. The final destination profile can optionally be embedded in the
    resulting TIFF image.

  * IccDumpProfile is a cross platform command line tool that allows information
    from a legacy ICC and or iccMAX profile to be output to the console. Data
    with non-printable values are replaced with '?'. Output from this tool is
    not guaranteed to be ASCII or UTF-8, but line-endings are consistent for a
    given platform.

    Detailed validation messages start with either "Warning!", "Error!" or "NonCompliant!".
    The overall status of validation is reported 2 lines below the line starting
    "Validation Report" and can be located using the following simple `grep`:

    ```bash
    grep --text -A 3 "^Validation Report" out.txt
    ```


  * IccRoundTrip is a cross platform command line tool that allows round trip
    colorimetric processing characteristics of rendering intent of a profile to be
    evaluated. (Evaluation goes from device values to PCS to establish initial PCS
    values. These are then converted to device values and then PCS values for the
    first round trip. Second round trip comparison then converts the second PCS
    values to device values to PCS values for comparison to the second PCS values.

  * IccSpecSepToTiff is a cross platform command line tool that combines separate
    individual TIFF images associated with different spectral wavelengths into a
    single multi-sample per pixel TIFF image. An iccMAX based profile can optionally
    be embedded in the resulting TIFF image.

  * IccTiffDump is a cross platform command line tool that outputs header and
    embedded ICC profile information about a TIFF image to the console.

  * IccPngDump is a cross platform command line tool that outputs header and
    embedded ICC profile information about a PNG image to the console. 

  * wxProfileDump provides a [wxWidgets](https://www.wxwidgets.org/) GUI based
    iccMAX and legacy ICC profile inspector tool. The code for this tool is based on
    wxWidgets 3.2.


## Example iccMAX Profiles

XML files are provided that can be used to create example iccMAX profiles. The
CreateAllProfiles.bat file uses the iccFromXML tool to create ICC profiles for
each of these XML files. The XML files can be found in the following folders:

### [Calc](Testing/Calc)

This folder contains profiles that demonstrate color modeling using the
Calculator MultiProcessElement. The srgbCalcTest profile exercises all specified
calculator operations.

### [Display](Testing/Display)

This folder contains profiles that demonstrate spectral modeling of display
profiles allowing for late binding of the observer using MultiProcessElements
that are transformed at startup to colorimetry for the desired observer.

### [Encoding](Testing/Encoding)

This folder contains 3 channel encoding class profiles. Both "name only"
profiles as well as fully specified profiles are present.

### [Named](Testing/Named)

This folder contains named color profiles showcasing
features such as tints, spectral reflectance, and fluorescence (with and with
out sparse notation).

### [PCC](Testing/PCC)

This folder contains various profiles that can be used to
define Profile Connection Conditions (PCC). All profiles are abstract profiles
that perform no operation to PCS values. However, all profiles contain fully
defined PCC tags that provide information that can be used to define rendering
for various observers and illuminants. Profiles that utilize both absolute
colorimetry as well as Material Adjusted colorimetry are present.

### [SpecRef](Testing/SpaceRef)

This folder contains various profiles that convert data to/from/between a
spectral reflectance PCS. The argbRef (AdobeRGB) and srgbRef (sRGB) convert RGB
values to/from spectral reflectance. RefDecC, RefDecH, and RefIncW are abstract
spectral reflectance profiles that modify "chroma", "hue", and "lightness" of
spectral reflectance values in a spectral reflectance PCS. The argbRef, srgbRef,
RefDecC, RefDecH, RefIncW profiles all estimate and/or manipulate spectral
reflectance using Wpt based spectral estimation (see chapter 7 of
http://scholarworks.rit.edu/theses/8789/. Additionally, examples of 6 channel
abridged spectral encoding is provided.

---

## Quick Start

[Release Libraries & Binaries](https://github.com/xsscx/PatchIccMAX/releases) | [Legacy OS Build Instructions](contrib/Build/cmake/IccMAX_Ubuntu22_Readme.md)

### Supported Triples
| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Ubuntu 24)           | 5.15.167.4-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

---

### Ubuntu | Build Reproduction | GNU Toolchain

Copy and Paste into your Terminal:

```
export CXX=g++
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
find IccProfLib/ IccXML/ Tools/ -type f -executable -exec file {} \; | grep 'ELF' | cut -d: -f1
cd ..
```

Create Profiles:

```
cd Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### macOS Build Reproduction | Clang Toolchain

Copy and Paste into your Terminal:

```
export CXX=clang++
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
brew install libpng nlohmann-json libxml2 wxwidgets libtiff
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ..
```

Create Profiles:

```
cd Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

---

## Windows Build

- **Build the master branch of the project via powershell**:

   ```
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build.ps1").Content
   ```

### Windows Cmake Instructions

#### Prerequisites

- Windows 10/11
- Visual Studio 2022 (with C++ Desktop Development workload)
- PowerShell
- Administrator or Developer command prompt

---

#### Setup: Environment & Dependencies

This example installs `vcpkg` to `c:\test` to avoid `devenv` pollution.

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


#### Clone and Checkout IccMAX

```
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
```

---

#### Configure & Build Example (MinSizeRel)

This example Cmake Configure and Build uses `vcpkg` installed to `c:\test` to avoid `devenv` pollution. 

```
cd Build
mkdir win
cd win

cmake -S ..\Cmake -B . -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_BUILD_TYPE=MinSizeRel `
  -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake `
  -DCMAKE_C_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_CXX_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" `
  -DENABLE_TOOLS=ON `
  -DENABLE_SHARED_LIBS=ON `
  -DENABLE_STATIC_LIBS=ON `
  -DENABLE_TESTS=ON `
  -DENABLE_INSTALL_RIM=ON `
  -DENABLE_ICCXML=ON `
  -DENABLE_SPECTRE_MITIGATION=OFF `
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
  --graphviz=iccMAX-project.dot

cmake --build . --config MinSizeRel -- /m /maxcpucount:32
```

##### Expected Output

```
  IccProfLib2-static.vcxproj -> Build\win\IccProfLib\MinSizeRel\IccProfLib2-static.lib
  IccProfLib2.vcxproj -> Build\win\IccProfLib\MinSizeRel\IccProfLib2.dll
  Aliasing IccProfLib2-static.lib to IccProfLib2.lib for MSVC compatibility
  iccFromCube.vcxproj -> Build\win\Tools\IccFromCube\MinSizeRel\iccFromCube.exe
  iccApplyToLink.vcxproj -> Build\win\Tools\IccApplyToLink\MinSizeRel\iccApplyToLink.exe
  iccPngDump.vcxproj -> Build\win\Tools\IccPngDump\MinSizeRel\iccPngDump.exe
  IccXML2-static.vcxproj -> Build\win\IccXML\MinSizeRel\IccXML2-static.lib
  iccV5DspObsToV4Dsp.vcxproj -> Build\win\Tools\IccV5DspObsToV4Dsp\MinSizeRel\iccV5DspObsToV4Dsp.exe
  iccDumpProfile.vcxproj -> Build\win\Tools\IccDumpProfile\MinSizeRel\iccDumpProfile.exe
  iccTiffDump.vcxproj -> Build\win\Tools\IccTiffDump\MinSizeRel\iccTiffDump.exe
  iccSpecSepToTiff.vcxproj -> Build\win\Tools\IccSpecSepToTiff\MinSizeRel\iccSpecSepToTiff.exe
  iccRoundTrip.vcxproj -> Build\win\Tools\IccRoundTrip\MinSizeRel\iccRoundTrip.exe
  Aliasing IccXML2-static.lib to IccXML2.lib for MSVC compatibility
  IccXML2.vcxproj -> Build\win\IccXML\MinSizeRel\IccXML2.dll
  iccDumpProfileGui.vcxproj -> Build\win\Tools\wxProfileDump\MinSizeRel\iccDumpProfileGui.exe
  IccMAXCmm.vcxproj -> Build\win\Tools\IccMAXCmm\x64\MinSizeRel\IccMAXCmm.dll
  iccFromXml.vcxproj -> Build\win\Tools\IccFromXml\MinSizeRel\iccFromXml.exe
  iccToXml.vcxproj -> Build\win\Tools\IccToXml\MinSizeRel\iccToXml.exe
  iccApplyNamedCmm.vcxproj -> Build\win\Tools\IccApplyNamedCmm\MinSizeRel\iccApplyNamedCmm.exe
  iccApplyProfiles.vcxproj -> Build\win\Tools\IccApplyProfiles\MinSizeRel\iccApplyProfiles.exe
```

### Dependency Install via vcpkg.json

There is `vcpkg.json` to install and integrate the dependencies:

```
cd DemoIccMAX
vcpkg integrate install
vcpkg install
```

##### Reproduction

```
[2025-04-13 11:35:22 F:\pr124\DemoIccMAX]%  vcpkg integrate install
Applied user-wide integration for this vcpkg root.
CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE= C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\vcpkg\scripts\buildsystems\vcpkg.cmake"

All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.
[2025-04-13 11:35:31 F:\pr124\DemoIccMAX]%
```

Adjust the Cmake Configure args shown above to use `$vcpkg` instead of `C:/test/vcpkg/`

### Visual Studio Solution

`devenv RefIccMAX.sln`

---

## Project PR Preflight Checks
1. Build on Linux, macOS & Windows
2. Create ICC Profiles
3. CICD Runner plus Stub

### Project Dependencies
- `libpng-dev`: Required for Png Support.
- `libxml2`: Required for XML support.
- `libwxgtk3.2-dev`: Required for GUI support.
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files.
- `libtiff`: Supports TIFF image manipulation for image processing tools.
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer.

---

[The ICC Software License](LICENSE.md)

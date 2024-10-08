
#
# DemoIccMAX Project | PCS_Refactor Branch | Build Script for Windows & VS2022C
# Refactor Date: 30-Sept-2024
# Author: David Hoyt
# Purpose: Automates the build and testing for the PCS_Refactor on Windows + VS2022C
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build_revert_master_branch_release.ps1").Content
#
# ============================================================

# Set up directories and environment variables
$optDir = "C:\test"
$vcpkgDir = "$optDir\vcpkg"
$patchDir = "$optDir\DemoIccMAX"

# Setup anon git
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Create the /opt directory if it doesn't exist
if (-Not (Test-Path $optDir)) {
    New-Item -ItemType Directory -Path $optDir
}

# Clone vcpkg repository and bootstrap
Write-Host "Cloning vcpkg repository..."
cd $optDir
git clone https://github.com/microsoft/vcpkg.git
cd $vcpkgDir
Write-Host "Bootstrapping vcpkg..."
.\bootstrap-vcpkg.bat

# Integrate vcpkg and install dependencies
Write-Host "Integrating vcpkg..."
.\vcpkg.exe integrate install

Write-Host "Installing required libraries (libxml2, tiff, wxwidgets) for x64-windows-static..."
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static

# Clone the PatchIccMAX repository
Write-Host "Cloning DemoIccMAX repository..."
cd $optDir
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git

# Checkout the master branch
cd $patchDir
git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6

# Build the project using msbuild
#Write-Host "Building the project..."
#msbuild  /m /maxcpucount "Build\MSVC\BuildAll_v22.sln" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 

Write-Host "Fixups for bad project configs"
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib 

# Set the PATH in case build and link static not working
# Confirmed working point and shoot
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\IccLibXML\IccLibXML_CRTDLL_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\IccLibXML\IccLibXML_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_CRTDLL_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_DLL_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\CmdLine\IccFromXml\IccFromXml_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\CmdLine\IccToXml\IccToXml_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyNamedCmm\iccApplyNamedCmm_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyToLink\iccApplyToLink_v16.vcxproj" /p:PlatformToolset=v143 /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccFromCube\iccFromCube_v16.vcxproj" /p:PlatformToolset=v143 /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO"
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccRoundTrip\iccRoundTrip_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccTiffDump\iccTiffDump_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\IccV5DspObsToV4Dsp_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\Winnt\DemoIccMAXCmm\DemoIccMAXCmm_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 

# TODO
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyProfiles\iccApplyProfiles_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
# iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_iccApplyProfiles.ps1").Content
# TODO
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccTiffDump\iccTiffDump_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
# iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_iccTiffDump_v22.ps1").Content
# TODO
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccSpecSepToTiff\iccSpecSepToTiff_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
# iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/VS2022C/build_iccSpecSepToTiff.ps1").Content

# Set the PATH in case build and link static not working
Write-Host "Adding $env:PATH = "C:\test\vcpkg\installed\x64-windows\bin;" + $env:PATH"
$env:PATH = "C:\test\vcpkg\installed\x64-windows\bin;" + $env:PATH

Write-Host "Copying .dll and .kibs into Testing/"
cd Testing/
copy c:\test\vcpkg\installed\x64-windows\lib\*.dll .
copy c:\test\vcpkg\installed\x64-windows-static\lib\*.lib .

Write-Host "Running the .exe files built"
# copy ..\..\vcpkg\installed\x64-windows-static\lib\tiff.lib  ..\..\vcpkg\installed\x64-windows-static\lib\libtiff.lib
Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object { Write-Host "Running: $($_.FullName)"; & $_.FullName }

Write-Host "Running CreateAllProfiles.bat from remote"
$tempFile = "$env:TEMP\CreateAllProfiles.bat"; iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.bat" -OutFile $tempFile; & $tempFile; Remove-Item $tempFile

Write-Host "All Done!"

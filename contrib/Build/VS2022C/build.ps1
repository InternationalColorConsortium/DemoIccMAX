# ========================== DemoIccMAX Master Branch Build Script ==========================
# DemoIccMAX Static Branch Build Script
# Copyright (c) 2024 The International Color Consortium. All rights reserved.
# Author: David Hoyt
# Date: 24-NOV-2024
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting DemoIccMAX Master Branch Build =============================" -ForegroundColor Green
Write-Host "Copyright (c) 2024 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "For more information on the International Color Consortium see URL https://color.org" -ForegroundColor Green
Write-Host "Signing: David H Hoyt LLC | dhoyt@hoyt.net" -ForegroundColor Green

# Set up directories and environment variables
Write-Host "Set up \test directories and environment variables...."
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
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
.\vcpkg.exe install nlohmann-json:x64-windows nlohmann-json:x64-windows-static libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libxml2:x64-windows-static tiff:x64-windows-static wxwidgets:x64-windows-static

# Clone the DemoIccMAXIccMAX repository
Write-Host "Cloning DemoIccMAX repository..."
cd $optDir
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git

# Checkout the master branch
cd $patchDir


# Build the project using msbuild
#Write-Host "Building the project..."
#msbuild  /m /maxcpucount "Build\MSVC\BuildAll_v22.sln" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 

Write-Host "Fixups for libs"
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib 

# Set the PATH in case build and link static not working
# Confirmed working point and shoot
Write-Host "Running msbuild for the individual .vcxproj files......"
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
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\IccV5DspObsToV4Dsp_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\Winnt\DemoIccMAXCmm\DemoIccMAXCmm_v22.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyProfiles\iccApplyProfiles_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccTiffDump\iccTiffDump_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccSpecSepToTiff\iccSpecSepToTiff_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build

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

# SIG # Begin signature block
# MII9BgYJKoZIhvcNAQcCoII89zCCPPMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCplzMuR4RMXnd9
# cOS75JschRGUEO4HsD+JcC3/WZjd6qCCIqIwggXMMIIDtKADAgECAhBUmNLR1FsZ
# lUgTecgRwIeZMA0GCSqGSIb3DQEBDAUAMHcxCzAJBgNVBAYTAlVTMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xSDBGBgNVBAMTP01pY3Jvc29mdCBJZGVu
# dGl0eSBWZXJpZmljYXRpb24gUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAy
# MDAeFw0yMDA0MTYxODM2MTZaFw00NTA0MTYxODQ0NDBaMHcxCzAJBgNVBAYTAlVT
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xSDBGBgNVBAMTP01pY3Jv
# c29mdCBJZGVudGl0eSBWZXJpZmljYXRpb24gUm9vdCBDZXJ0aWZpY2F0ZSBBdXRo
# b3JpdHkgMjAyMDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALORKgeD
# Bmf9np3gx8C3pOZCBH8Ppttf+9Va10Wg+3cL8IDzpm1aTXlT2KCGhFdFIMeiVPvH
# or+Kx24186IVxC9O40qFlkkN/76Z2BT2vCcH7kKbK/ULkgbk/WkTZaiRcvKYhOuD
# PQ7k13ESSCHLDe32R0m3m/nJxxe2hE//uKya13NnSYXjhr03QNAlhtTetcJtYmrV
# qXi8LW9J+eVsFBT9FMfTZRY33stuvF4pjf1imxUs1gXmuYkyM6Nix9fWUmcIxC70
# ViueC4fM7Ke0pqrrBc0ZV6U6CwQnHJFnni1iLS8evtrAIMsEGcoz+4m+mOJyoHI1
# vnnhnINv5G0Xb5DzPQCGdTiO0OBJmrvb0/gwytVXiGhNctO/bX9x2P29Da6SZEi3
# W295JrXNm5UhhNHvDzI9e1eM80UHTHzgXhgONXaLbZ7LNnSrBfjgc10yVpRnlyUK
# xjU9lJfnwUSLgP3B+PR0GeUw9gb7IVc+BhyLaxWGJ0l7gpPKWeh1R+g/OPTHU3mg
# trTiXFHvvV84wRPmeAyVWi7FQFkozA8kwOy6CXcjmTimthzax7ogttc32H83rwjj
# O3HbbnMbfZlysOSGM1l0tRYAe1BtxoYT2v3EOYI9JACaYNq6lMAFUSw0rFCZE4e7
# swWAsk0wAly4JoNdtGNz764jlU9gKL431VulAgMBAAGjVDBSMA4GA1UdDwEB/wQE
# AwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTIftJqhSobyhmYBAcnz1AQ
# T2ioojAQBgkrBgEEAYI3FQEEAwIBADANBgkqhkiG9w0BAQwFAAOCAgEAr2rd5hnn
# LZRDGU7L6VCVZKUDkQKL4jaAOxWiUsIWGbZqWl10QzD0m/9gdAmxIR6QFm3FJI9c
# Zohj9E/MffISTEAQiwGf2qnIrvKVG8+dBetJPnSgaFvlVixlHIJ+U9pW2UYXeZJF
# xBA2CFIpF8svpvJ+1Gkkih6PsHMNzBxKq7Kq7aeRYwFkIqgyuH4yKLNncy2RtNwx
# AQv3Rwqm8ddK7VZgxCwIo3tAsLx0J1KH1r6I3TeKiW5niB31yV2g/rarOoDXGpc8
# FzYiQR6sTdWD5jw4vU8w6VSp07YEwzJ2YbuwGMUrGLPAgNW3lbBeUU0i/OxYqujY
# lLSlLu2S3ucYfCFX3VVj979tzR/SpncocMfiWzpbCNJbTsgAlrPhgzavhgplXHT2
# 6ux6anSg8Evu75SjrFDyh+3XOjCDyft9V77l4/hByuVkrrOj7FjshZrM77nq81YY
# uVxzmq/FdxeDWds3GhhyVKVB0rYjdaNDmuV3fJZ5t0GNv+zcgKCf0Xd1WF81E+Al
# GmcLfc4l+gcK5GEh2NQc5QfGNpn0ltDGFf5Ozdeui53bFv0ExpK91IjmqaOqu/dk
# ODtfzAzQNb50GQOmxapMomE2gj4d8yu8l13bS3g7LfU772Aj6PXsCyM2la+YZr9T
# 03u4aUoqlmZpxJTG9F9urJh4iIAGXKKy7aIwggblMIIEzaADAgECAhMzAAHx0G+i
# KWTNTc6PAAAAAfHQMA0GCSqGSIb3DQEBDAUAMFoxCzAJBgNVBAYTAlVTMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKzApBgNVBAMTIk1pY3Jvc29mdCBJ
# RCBWZXJpZmllZCBDUyBBT0MgQ0EgMDEwHhcNMjQxMTI0MTAzMTE0WhcNMjQxMTI3
# MTAzMTE0WjBlMQswCQYDVQQGEwJVUzEQMA4GA1UECBMHVmVybW9udDEOMAwGA1UE
# BxMFU3Rvd2UxGTAXBgNVBAoTEERhdmlkIEggSG95dCBMTEMxGTAXBgNVBAMTEERh
# dmlkIEggSG95dCBMTEMwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDJ
# fgCqpwFqPqFBqJiEUg1WiLoZvzoF1PPSxhA0S37F+dosml/skewnbLBaHSIOvTsU
# t97vzQLxig8wnoslWORNQVDcxAXsYJuxmpDlbK3dJbbcu6vZz6mY4NCQma7kv9Yq
# KEUValM7hd71ecAjbLRRW5wulKagJgjtaYZUbY1iR2ZZtRN3c/nIovSahE2frYz2
# zWyzg83VeAJc/NCKZaMZNpn+IdArhObWvP5kAILMMTPhR5bKKvX72056WGEAy+Ge
# 3zgXXGt4qyuoLrYRfOIFeGpt2BSVT14GwvXRzNu+5YV3LR3FF4WiYrUwPtdyH9k8
# SgIZhw6GBvy2Po9h2KuPAD8nWTH9ZmvWl4NfyCUOfHsiQo00hSb5FtLnx0Dm37Fo
# IMXOOWgrNKTgzPvcciD4HNFV8Xn9BACcwnG2ABlSuFVw0Xrq+ond4dPtEbHkIFe0
# lZ8MoqiQSq3vlgxraJeCxPZZIFuDQEXtAzkv2jc6TMT+h3Kq6FY4odK5FIG0XwkC
# AwEAAaOCAhcwggITMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMDoGA1Ud
# JQQzMDEGCisGAQQBgjdhAQAGCCsGAQUFBwMDBhkrBgEEAYI3Yd3D5j2C3IfhdYXS
# i06euL1zMB0GA1UdDgQWBBRacqvq2zyfHgsBh8Df4goikbMtBzAfBgNVHSMEGDAW
# gBTog8Qz19yfDJx2mgqm1N+Hpl5Y7jBnBgNVHR8EYDBeMFygWqBYhlZodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBJRCUyMFZl
# cmlmaWVkJTIwQ1MlMjBBT0MlMjBDQSUyMDAxLmNybDCBpQYIKwYBBQUHAQEEgZgw
# gZUwZAYIKwYBBQUHMAKGWGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y2VydHMvTWljcm9zb2Z0JTIwSUQlMjBWZXJpZmllZCUyMENTJTIwQU9DJTIwQ0El
# MjAwMS5jcnQwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vbmVvY3NwLm1pY3Jvc29mdC5j
# b20vb2NzcDBmBgNVHSAEXzBdMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9y
# eS5odG0wCAYGZ4EMAQQBMA0GCSqGSIb3DQEBDAUAA4ICAQA6BrrNGg63j3PH27vs
# PM9fyi+4F36BiCky6w7n2IWv3Erbr2YEZouEyGmpux+hVzAR57jEaB/5gywCo/wu
# nna8WtUpvdKGLlP3I4UjmtLzZpBDKcNn/JpUg/kneCdwsADIpA/QWIspkYAt4Q85
# zf+6tbq1WKhmnilaNdujJAsK2mYBJAezzOfy51/Do93GiiTJg5LJ5u6O1L991/gB
# zGwYR3zbbwTVNPcaEmL5OdcPl2tUlaqjozO40JKZxzQrWkBu/4/F4utURp9IPXDs
# vXH8MZuocU8FHBmtJiFAfMk+Rx4oQo7dIzMh5Q2ucy17Xpxqbc7jMpp2rH1oEuNi
# 0pn53B52tkSZHFI+8trpKwA6p06p8RwyMxf0PKvoa/EMTmOgPcAKXanEPbKHue94
# JVnGyIS9TKFw0caRxY4XfEbceFOoxI52NGfgI6ZQrpEUYST6na1lYLXjzmZZp5tp
# mZGmotWebpsRNag5VXObo6V9AmFdlAqEBSf1A52QEfIUDdgT2Vdm1HuXRpWEcTKW
# QT/FYMOmWKoJ9OtnrvFk4OXKT2bwMqZnpRxH03tEYv5zF2zWfVxEXgmbBEbIRSnl
# WMdzmZ1lHpwVjvEQH6AM1sKpAzZGQ1qpoRKibfClpjt1LwxIRX4uEcgPsiflfsxW
# Kh78DF+hEsj4y1lM+UZHpw5aLDCCBuUwggTNoAMCAQICEzMAAfHQb6IpZM1Nzo8A
# AAAB8dAwDQYJKoZIhvcNAQEMBQAwWjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiTWljcm9zb2Z0IElEIFZlcmlm
# aWVkIENTIEFPQyBDQSAwMTAeFw0yNDExMjQxMDMxMTRaFw0yNDExMjcxMDMxMTRa
# MGUxCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdWZXJtb250MQ4wDAYDVQQHEwVTdG93
# ZTEZMBcGA1UEChMQRGF2aWQgSCBIb3l0IExMQzEZMBcGA1UEAxMQRGF2aWQgSCBI
# b3l0IExMQzCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAMl+AKqnAWo+
# oUGomIRSDVaIuhm/OgXU89LGEDRLfsX52iyaX+yR7CdssFodIg69OxS33u/NAvGK
# DzCeiyVY5E1BUNzEBexgm7GakOVsrd0ltty7q9nPqZjg0JCZruS/1iooRRVqUzuF
# 3vV5wCNstFFbnC6UpqAmCO1phlRtjWJHZlm1E3dz+cii9JqETZ+tjPbNbLODzdV4
# Alz80Iploxk2mf4h0CuE5ta8/mQAgswxM+FHlsoq9fvbTnpYYQDL4Z7fOBdca3ir
# K6guthF84gV4am3YFJVPXgbC9dHM277lhXctHcUXhaJitTA+13If2TxKAhmHDoYG
# /LY+j2HYq48APydZMf1ma9aXg1/IJQ58eyJCjTSFJvkW0ufHQObfsWggxc45aCs0
# pODM+9xyIPgc0VXxef0EAJzCcbYAGVK4VXDReur6id3h0+0RseQgV7SVnwyiqJBK
# re+WDGtol4LE9lkgW4NARe0DOS/aNzpMxP6HcqroVjih0rkUgbRfCQIDAQABo4IC
# FzCCAhMwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwOgYDVR0lBDMwMQYK
# KwYBBAGCN2EBAAYIKwYBBQUHAwMGGSsGAQQBgjdh3cPmPYLch+F1hdKLTp64vXMw
# HQYDVR0OBBYEFFpyq+rbPJ8eCwGHwN/iCiKRsy0HMB8GA1UdIwQYMBaAFOiDxDPX
# 3J8MnHaaCqbU34emXljuMGcGA1UdHwRgMF4wXKBaoFiGVmh0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMElEJTIwVmVyaWZpZWQl
# MjBDUyUyMEFPQyUyMENBJTIwMDEuY3JsMIGlBggrBgEFBQcBAQSBmDCBlTBkBggr
# BgEFBQcwAoZYaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9N
# aWNyb3NvZnQlMjBJRCUyMFZlcmlmaWVkJTIwQ1MlMjBBT0MlMjBDQSUyMDAxLmNy
# dDAtBggrBgEFBQcwAYYhaHR0cDovL29uZW9jc3AubWljcm9zb2Z0LmNvbS9vY3Nw
# MGYGA1UdIARfMF0wUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTAI
# BgZngQwBBAEwDQYJKoZIhvcNAQEMBQADggIBADoGus0aDrePc8fbu+w8z1/KL7gX
# foGIKTLrDufYha/cStuvZgRmi4TIaam7H6FXMBHnuMRoH/mDLAKj/C6edrxa1Sm9
# 0oYuU/cjhSOa0vNmkEMpw2f8mlSD+Sd4J3CwAMikD9BYiymRgC3hDznN/7q1urVY
# qGaeKVo126MkCwraZgEkB7PM5/LnX8Oj3caKJMmDksnm7o7Uv33X+AHMbBhHfNtv
# BNU09xoSYvk51w+Xa1SVqqOjM7jQkpnHNCtaQG7/j8Xi61RGn0g9cOy9cfwxm6hx
# TwUcGa0mIUB8yT5HHihCjt0jMyHlDa5zLXtenGptzuMymnasfWgS42LSmfncHna2
# RJkcUj7y2ukrADqnTqnxHDIzF/Q8q+hr8QxOY6A9wApdqcQ9soe573glWcbIhL1M
# oXDRxpHFjhd8Rtx4U6jEjnY0Z+AjplCukRRhJPqdrWVgtePOZlmnm2mZkaai1Z5u
# mxE1qDlVc5ujpX0CYV2UCoQFJ/UDnZAR8hQN2BPZV2bUe5dGlYRxMpZBP8Vgw6ZY
# qgn062eu8WTg5cpPZvAypmelHEfTe0Ri/nMXbNZ9XEReCZsERshFKeVYx3OZnWUe
# nBWO8RAfoAzWwqkDNkZDWqmhEqJt8KWmO3UvDEhFfi4RyA+yJ+V+zFYqHvwMX6ES
# yPjLWUz5RkenDlosMIIHWjCCBUKgAwIBAgITMwAAAAc3jFuh2VuM1AAAAAAABzAN
# BgkqhkiG9w0BAQwFADBjMQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTQwMgYDVQQDEytNaWNyb3NvZnQgSUQgVmVyaWZpZWQgQ29k
# ZSBTaWduaW5nIFBDQSAyMDIxMB4XDTIxMDQxMzE3MzE1NFoXDTI2MDQxMzE3MzE1
# NFowWjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjErMCkGA1UEAxMiTWljcm9zb2Z0IElEIFZlcmlmaWVkIENTIEFPQyBDQSAwMTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALf3wAMoB8W6Po8QNOITSPG8
# /hKm1r0rvXUYAGsIwmWrtWOeCEGpeQK6SVovHCI9FgPpqcIsfIk0YLqvSRC2b0zK
# NmdVOgLRNU595r6t5ssGfUnsVXfqzzk6/rnWuhlYMCwPNC4UX/NgL60sMZmaQh/5
# Wk9PHZ+/hrdHF2FTSiTkZtYUqwI4w0ImdSYqv0qog6Bzejxpk+YVyrNthO/THhVm
# AeMtFJTaltGdizzbmvJNK2xEXYjUvp0z/8bBEmVJ625sl2Wh73MhCmCvOVgc90q+
# hLfFZW3Ynf6YwaXByPh8raGlABhOq0lqpoe/2hGXgw1JM/bjCjhmrCIGJ3p1JORN
# G9lP/20Kg796nYY/VCWFgAzWAv94t4sXFtVRC2lPsE6l08SwBXpQov5UR0o2loqQ
# 3hP02wW9M0woi53PZ5jo2TypbrTDYaPdcMaOIrXCaCJNmz6LfbfgFflMDWg0SG3B
# GkGgcnJfaXGMFpn9GyeCBZ/wpmDFRtXpAgcQcskTZBZB5rjFy1+jzF3L3hOOozK/
# bMgtzPCR0XXUeM1Y3fxcQZ0uRzq6N6YOkrbhD7Ia6eyPypNXExvMjlpfGqn+jiXg
# FchuJcifVfmcQpWJmlOcr7SmCpNRSwZxAXw1sPlAM0FdL3C6egFcdhXPJ9L6aMrn
# a90sGZnJCbs+0fku/QczAgMBAAGjggIOMIICCjAOBgNVHQ8BAf8EBAMCAYYwEAYJ
# KwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFOiDxDPX3J8MnHaaCqbU34emXljuMFQG
# A1UdIARNMEswSQYEVR0gADBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wGQYJKwYBBAGCNxQC
# BAweCgBTAHUAYgBDAEEwEgYDVR0TAQH/BAgwBgEB/wIBADAfBgNVHSMEGDAWgBTZ
# QSmwDw9jbO9p1/XNKZ6kSGow5jBwBgNVHR8EaTBnMGWgY6Bhhl9odHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBJRCUyMFZlcmlm
# aWVkJTIwQ29kZSUyMFNpZ25pbmclMjBQQ0ElMjAyMDIxLmNybDCBrgYIKwYBBQUH
# AQEEgaEwgZ4wbQYIKwYBBQUHMAKGYWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwSUQlMjBWZXJpZmllZCUyMENvZGUlMjBT
# aWduaW5nJTIwUENBJTIwMjAyMS5jcnQwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vbmVv
# Y3NwLm1pY3Jvc29mdC5jb20vb2NzcDANBgkqhkiG9w0BAQwFAAOCAgEAd/7rSyLZ
# MC06eDX4ffb626UrC/DcDyI9vkwZ2Ri9wvHrUxmLPh2VMTRvqzXmWvkc7vaBHAGS
# Q4hoxFsrczGrw+gYod5xFhbCFuGhoeIAeJ/6UT3nlayuItSxu4yd5Dy0YTTh2Yi1
# ELZqxeFeiMbVBY7wZ4o2mfaCMbEkkD/IhzIz/dqY0KxwRVhxg25JsfsjuiGp90Dd
# 2Jm3X3sM0r50Jim5Ik4myYHCdS9E2ewcJrA75vtF0bDznxYJ84S1amXRMlsMNdG3
# 5TngSqpG90mgjUE8/J7IWlGYa8VVOajYGI2mg0EJvj9khKQRe0aJRAt5ZZX7i+AD
# hgraDXTzlq8fbwWU1wFXUxNq9CA5PPuctZCxkyys5jRZ+pFQnOQXXTO8aA1kOGlK
# AkV3LAXkYbHJZO5FVz/syRjzl8I1CW589irfYhf/AehQzuG5Rrhq6IDKcl5LsAgt
# meF3H8jIzw4amWADxhk1CDTLRW2ruUbRhtQzlhPXnQmobbjzA4Acnz4sb4ct7J+8
# 1B4CAv2LDkzMVbjEIv24GpnpqP1TSma7GWktJ85jsSqYPag3n4+XyfYCB13KdhdD
# h3FcHtypxF2vJKszA360Zf8MCqzUhZ96e4NG+OAHdTjQ5lretTC0LxeeCxutoun3
# 4UwnqBU/WfaW1KNoMZckxYOwZtH4DpZ0XxgwggeeMIIFhqADAgECAhMzAAAAB4ej
# NKN7pY4cAAAAAAAHMA0GCSqGSIb3DQEBDAUAMHcxCzAJBgNVBAYTAlVTMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xSDBGBgNVBAMTP01pY3Jvc29mdCBJ
# ZGVudGl0eSBWZXJpZmljYXRpb24gUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkg
# MjAyMDAeFw0yMTA0MDEyMDA1MjBaFw0zNjA0MDEyMDE1MjBaMGMxCzAJBgNVBAYT
# AlVTMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xNDAyBgNVBAMTK01p
# Y3Jvc29mdCBJRCBWZXJpZmllZCBDb2RlIFNpZ25pbmcgUENBIDIwMjEwggIiMA0G
# CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCy8MCvGYgo4t1UekxJbGkIVQm0Uv96
# SvjB6yUo92cXdylN65Xy96q2YpWCiTas7QPTkGnK9QMKDXB2ygS27EAIQZyAd+M8
# X+dmw6SDtzSZXyGkxP8a8Hi6EO9Zcwh5A+wOALNQbNO+iLvpgOnEM7GGB/wm5dYn
# MEOguua1OFfTUITVMIK8faxkP/4fPdEPCXYyy8NJ1fmskNhW5HduNqPZB/NkWbB9
# xxMqowAeWvPgHtpzyD3PLGVOmRO4ka0WcsEZqyg6efk3JiV/TEX39uNVGjgbODZh
# zspHvKFNU2K5MYfmHh4H1qObU4JKEjKGsqqA6RziybPqhvE74fEp4n1tiY9/ootd
# U0vPxRp4BGjQFq28nzawuvaCqUUF2PWxh+o5/TRCb/cHhcYU8Mr8fTiS15kRmwFF
# zdVPZ3+JV3s5MulIf3II5FXeghlAH9CvicPhhP+VaSFW3Da/azROdEm5sv+EUwhB
# rzqtxoYyE2wmuHKws00x4GGIx7NTWznOm6x/niqVi7a/mxnnMvQq8EMse0vwX2Cf
# qM7Le/smbRtsEeOtbnJBbtLfoAsC3TdAOnBbUkbUfG78VRclsE7YDDBUbgWt75lD
# k53yi7C3n0WkHFU4EZ83i83abd9nHWCqfnYa9qIHPqjOiuAgSOf4+FRcguEBXlD9
# mAInS7b6V0UaNwIDAQABo4ICNTCCAjEwDgYDVR0PAQH/BAQDAgGGMBAGCSsGAQQB
# gjcVAQQDAgEAMB0GA1UdDgQWBBTZQSmwDw9jbO9p1/XNKZ6kSGow5jBUBgNVHSAE
# TTBLMEkGBFUdIAAwQTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBkGCSsGAQQBgjcUAgQMHgoA
# UwB1AGIAQwBBMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUyH7SaoUqG8oZ
# mAQHJ89QEE9oqKIwgYQGA1UdHwR9MHsweaB3oHWGc2h0dHA6Ly93d3cubWljcm9z
# b2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMElkZW50aXR5JTIwVmVyaWZp
# Y2F0aW9uJTIwUm9vdCUyMENlcnRpZmljYXRlJTIwQXV0aG9yaXR5JTIwMjAyMC5j
# cmwwgcMGCCsGAQUFBwEBBIG2MIGzMIGBBggrBgEFBQcwAoZ1aHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBJZGVudGl0eSUy
# MFZlcmlmaWNhdGlvbiUyMFJvb3QlMjBDZXJ0aWZpY2F0ZSUyMEF1dGhvcml0eSUy
# MDIwMjAuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vb25lb2NzcC5taWNyb3NvZnQu
# Y29tL29jc3AwDQYJKoZIhvcNAQEMBQADggIBAH8lKp7+1Kvq3WYK21cjTLpebJDj
# W4ZbOX3HD5ZiG84vjsFXT0OB+eb+1TiJ55ns0BHluC6itMI2vnwc5wDW1ywdCq3T
# Amx0KWy7xulAP179qX6VSBNQkRXzReFyjvF2BGt6FvKFR/imR4CEESMAG8hSkPYs
# o+GjlngM8JPn/ROUrTaeU/BRu/1RFESFVgK2wMz7fU4VTd8NXwGZBe/mFPZG6tWw
# kdmA/jLbp0kNUX7elxu2+HtHo0QO5gdiKF+YTYd1BGrmNG8sTURvn09jAhIUJfYN
# otn7OlThtfQjXqe0qrimgY4Vpoq2MgDW9ESUi1o4pzC1zTgIGtdJ/IvY6nqa80jF
# OTg5qzAiRNdsUvzVkoYP7bi4wLCj+ks2GftUct+fGUxXMdBUv5sdr0qFPLPB0b8v
# q516slCfRwaktAxK1S40MCvFbbAXXpAZnU20FaAoDwqq/jwzwd8Wo2J83r7O3onQ
# bDO9TyDStgaBNlHzMMQgl95nHBYMelLEHkUnVVVTUsgC0Huj09duNfMaJ9ogxhPN
# Thgq3i8w3DAGZ61AMeF0C1M+mU5eucj1Ijod5O2MMPeJQ3/vKBtqGZg4eTtUHt/B
# PjN74SsJsyHqAdXVS5c+ItyKWg3Eforhox9k3WgtWTpgV4gkSiS4+A09roSdOI4v
# rRw+p+fL4WrxSK5nMYIZujCCGbYCAQEwcTBaMQswCQYDVQQGEwJVUzEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYDVQQDEyJNaWNyb3NvZnQgSUQg
# VmVyaWZpZWQgQ1MgQU9DIENBIDAxAhMzAAHx0G+iKWTNTc6PAAAAAfHQMA0GCWCG
# SAFlAwQCAQUAoF4wEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwLwYJKoZIhvcNAQkEMSIEIMmRosgYSWxHlN5sNE0JzwatdM4mD7RI
# 7FdZoQ9KBadrMA0GCSqGSIb3DQEBAQUABIIBgBvPGbZajx6EH42/gbgnKoSC6doX
# pKK3c1pFDnTkjY51iCRneI7ffmU7FI2tUdF0MRCXflDLsFQ4aBJc2m61QTH+OJL/
# 8c4R2vRMO7eMk0DRgAUF0O+EoZrbZ6y92vcb8zTZ2MivDpXpq3k/W5ZFKEBcm37V
# ynzqklDnCQUp1O1164SwNLZ6l8ERIfoQVKLJ/Ih/Toet8Dw9S1jgvW7AYpaoAy7n
# 3f8sHzmxZV6VyjvrnwM/27OsdbNO2X2EmK3o7r4t1qpx4LIKZ2peux6x00iHCdwr
# cqEWyXvE8lPHyQCZRFCLdTSNfdwueBh1Dg3ijkMeWiySB6Pm5rxf5PRO9I7E3W5u
# F9hyFpEjt976TmkG4McrmjbPWRggkNy0+Yl0jQVUxfmONr6i2V+88zpcGbJTeNtQ
# a+k8vxCoIgM34ikzFm8YP7HTm3znGEpZZQ+X7meqG3w/YDsJNqCY3l5XthJ9lilk
# NdLSbvQ/v/l/yyNmmLWxWlDuwQbq0Xhakkkqi6GCFzowghc2BgorBgEEAYI3AwMB
# MYIXJjCCFyIGCSqGSIb3DQEHAqCCFxMwghcPAgEDMQ8wDQYJYIZIAWUDBAIBBQAw
# eAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQC
# AQUABCDYiFaAYoiHsHfYBhZTMwCBiJj93WseCufCJL4skUIa3wIRALwe2mLYeZ2Z
# nB0oxu3b0MQYDzIwMjQxMTI0MjM1NDAwWqCCEwMwgga8MIIEpKADAgECAhALrma8
# Wrp/lYfG+ekE4zMEMA0GCSqGSIb3DQEBCwUAMGMxCzAJBgNVBAYTAlVTMRcwFQYD
# VQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3RlZCBH
# NCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwHhcNMjQwOTI2MDAwMDAw
# WhcNMzUxMTI1MjM1OTU5WjBCMQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGlnaUNl
# cnQxIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFtcCAyMDI0MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAvmpzn/aVIauWMLpbbeZZo7Xo/ZEfGMSIO2qZ
# 46XB/QowIEMSvgjEdEZ3v4vrrTHleW1JWGErrjOL0J4L0HqVR1czSzvUQ5xF7z4I
# Qmn7dHY7yijvoQ7ujm0u6yXF2v1CrzZopykD07/9fpAT4BxpT9vJoJqAsP8YuhRv
# flJ9YeHjes4fduksTHulntq9WelRWY++TFPxzZrbILRYynyEy7rS1lHQKFpXvo2G
# ePfsMRhNf1F41nyEg5h7iOXv+vjX0K8RhUisfqw3TTLHj1uhS66YX2LZPxS4oaf3
# 3rp9HlfqSBePejlYeEdU740GKQM7SaVSH3TbBL8R6HwX9QVpGnXPlKdE4fBIn5BB
# FnV+KwPxRNUNK6lYk2y1WSKour4hJN0SMkoaNV8hyyADiX1xuTxKaXN12HgR+8Wu
# lU2d6zhzXomJ2PleI9V2yfmfXSPGYanGgxzqI+ShoOGLomMd3mJt92nm7Mheng/T
# BeSA2z4I78JpwGpTRHiT7yHqBiV2ngUIyCtd0pZ8zg3S7bk4QC4RrcnKJ3FbjyPA
# GogmoiZ33c1HG93Vp6lJ415ERcC7bFQMRbxqrMVANiav1k425zYyFMyLNyE1QulQ
# SgDpW9rtvVcIH7WvG9sqYup9j8z9J1XqbBZPJ5XLln8mS8wWmdDLnBHXgYly/p1D
# hoQo5fkCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAA
# MBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsG
# CWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91jGogj57IbzAdBgNV
# HQ4EFgQUn1csA3cOKBWQZqVjXu5Pkh92oFswWgYDVR0fBFMwUTBPoE2gS4ZJaHR0
# cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNI
# QTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEEgYMwgYAwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggrBgEFBQcwAoZMaHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5
# NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAPa0e
# H3aZW+M4hBJH2UOR9hHbm04IHdEoT8/T3HuBSyZeq3jSi5GXeWP7xCKhVireKCnC
# s+8GZl2uVYFvQe+pPTScVJeCZSsMo1JCoZN2mMew/L4tpqVNbSpWO9QGFwfMEy60
# HofN6V51sMLMXNTLfhVqs+e8haupWiArSozyAmGH/6oMQAh078qRh6wvJNU6gnh5
# OruCP1QUAvVSu4kqVOcJVozZR5RRb/zPd++PGE3qF1P3xWvYViUJLsxtvge/mzA7
# 5oBfFZSbdakHJe2BVDGIGVNVjOp8sNt70+kEoMF+T6tptMUNlehSR7vM+C13v9+9
# ZOUKzfRUAYSyyEmYtsnpltD/GWX8eM70ls1V6QG/ZOB6b6Yum1HvIiulqJ1Elesj
# 5TMHq8CWT/xrW7twipXTJ5/i5pkU5E16RSBAdOp12aw8IQhhA/vEbFkEiF2abhuF
# ixUDobZaA0VhqAsMHOmaT3XThZDNi5U2zHKhUs5uHHdG6BoQau75KiNbh0c+hatS
# F+02kULkftARjsyEpHKsF7u5zKRbt5oK5YGwFvgc4pEVUNytmB3BpIiowOIIuDgP
# 5M9WArHYSAR16gc0dP2XdkMEP5eBsX7bf/MGN4K3HP50v/01ZHo/Z5lGLvNwQ7XH
# Bx1yomzLP8lx4Q1zZKDyHcp4VQJLu2kWTsKsOqQwggauMIIElqADAgECAhAHNje3
# JFR82Ees/ShmKl5bMA0GCSqGSIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAf
# BgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMjAzMjMwMDAwMDBa
# Fw0zNzAzMjIyMzU5NTlaMGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2Vy
# dCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNI
# QTI1NiBUaW1lU3RhbXBpbmcgQ0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQDGhjUGSbPBPXJJUVXHJQPE8pE3qZdRodbSg9GeTKJtoLDMg/la9hGhRBVC
# X6SI82j6ffOciQt/nR+eDzMfUBMLJnOWbfhXqAJ9/UO0hNoR8XOxs+4rgISKIhjf
# 69o9xBd/qxkrPkLcZ47qUT3w1lbU5ygt69OxtXXnHwZljZQp09nsad/ZkIdGAHvb
# REGJ3HxqV3rwN3mfXazL6IRktFLydkf3YYMZ3V+0VAshaG43IbtArF+y3kp9zvU5
# EmfvDqVjbOSmxR3NNg1c1eYbqMFkdECnwHLFuk4fsbVYTXn+149zk6wsOeKlSNbw
# sDETqVcplicu9Yemj052FVUmcJgmf6AaRyBD40NjgHt1biclkJg6OBGz9vae5jtb
# 7IHeIhTZgirHkr+g3uM+onP65x9abJTyUpURK1h0QCirc0PO30qhHGs4xSnzyqqW
# c0Jon7ZGs506o9UD4L/wojzKQtwYSH8UNM/STKvvmz3+DrhkKvp1KCRB7UK/BZxm
# SVJQ9FHzNklNiyDSLFc1eSuo80VgvCONWPfcYd6T/jnA+bIwpUzX6ZhKWD7TA4j+
# s4/TXkt2ElGTyYwMO1uKIqjBJgj5FBASA31fI7tk42PgpuE+9sJ0sj8eCXbsq11G
# deJgo1gJASgADoRU7s7pXcheMBK9Rp6103a50g5rmQzSM7TNsQIDAQABo4IBXTCC
# AVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUuhbZbU2FL3MpdpovdYxq
# II+eyG8wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/
# BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggr
# BgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVo
# dHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0
# LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjAL
# BglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIBAH1ZjsCTtm+YqUQiAX5m1tgh
# QuGwGC4QTRPPMFPOvxj7x1Bd4ksp+3CKDaopafxpwc8dB+k+YMjYC+VcW9dth/qE
# ICU0MWfNthKWb8RQTGIdDAiCqBa9qVbPFXONASIlzpVpP0d3+3J0FNf/q0+KLHqr
# hc1DX+1gtqpPkWaeLJ7giqzl/Yy8ZCaHbJK9nXzQcAp876i8dU+6WvepELJd6f8o
# VInw1YpxdmXazPByoyP6wCeCRK6ZJxurJB4mwbfeKuv2nrF5mYGjVoarCkXJ38SN
# oOeY+/umnXKvxMfBwWpx2cYTgAnEtp/Nh4cku0+jSbl3ZpHxcpzpSwJSpzd+k1Os
# Ox0ISQ+UzTl63f8lY5knLD0/a6fxZsNBzU+2QJshIUDQtxMkzdwdeDrknq3lNHGS
# 1yZr5Dhzq6YBT70/O3itTK37xJV77QpfMzmHQXh6OOmc4d0j/R0o08f56PGYX/sr
# 2H7yRp11LB4nLCbbbxV7HhmLNriT1ObyF5lZynDwN7+YAN8gFk8n+2BnFqFmut1V
# wDophrCYoCvtlUG3OtUVmDG0YgkPCr2B2RP+v6TR81fZvAT6gt4y3wSJ8ADNXcL5
# 0CN/AAvkdgIm2fBldkKmKYcJRyvmfxqkhQ/8mJb2VVQrH4D6wPIOK+XW+6kvRBVK
# 5xMOHds3OBqhK/bt1nz8MIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjAN
# BgkqhkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQg
# SW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2Vy
# dCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1
# OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVk
# IFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN67
# 5F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaX
# bR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQ
# Lt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82s
# NEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4Da
# tpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwh
# TNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98Fp
# iHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppE
# GSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+
# 9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56
# rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8
# oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/
# BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgw
# FoAUReuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUF
# BwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
# CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRB
# c3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0g
# BAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW
# 1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH3
# 8nLeJLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMT
# dydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY
# 9HdaXFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyer
# bHbObyMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmU
# MYIDdjCCA3ICAQEwdzBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
# IEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEy
# NTYgVGltZVN0YW1waW5nIENBAhALrma8Wrp/lYfG+ekE4zMEMA0GCWCGSAFlAwQC
# AQUAoIHRMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUx
# DxcNMjQxMTI0MjM1NDAwWjArBgsqhkiG9w0BCRACDDEcMBowGDAWBBTb04XuYtvS
# Pnvk9nFIUIck1YZbRTAvBgkqhkiG9w0BCQQxIgQg78rceYWfX/M3ZdhXq0B06rTb
# iXaMxVrH6Pnwjt7rVE4wNwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgdnafqPJjLx9D
# CzojMK7WVnX+13PbBdZluQWTmEOPmtswDQYJKoZIhvcNAQEBBQAEggIAETUWTzVD
# 71jeZfenow2DwgADG8Q05cxgj4H3lS9QmhMdfMUXGT5plNPbfaxPiaO+YMLbYUgp
# jp+Xfrrtf64v73McROd+UUrBfP/qj9+UTbChDJt+8HO5+h71tkd/cImoWg1+jbaN
# p9imzlY1MJgOTt1Pg7ciajv7R24Dl1keQMkb422Yu/r03MhufFYGTdaPF3hi+6NA
# vHPDAVkKdc2Y5JGpzDr/aqzECVApaMOWj9RrlMB94WXXihIVEKi/uEkqrGTyLwJM
# BQdlBvRhBqn9N1T1jGx9dH47Eqe+a+KF50D6ay8BL5+WwSDaeCaTAfTRr5Hz3tGN
# iP5zPvjeNUaKgQI9ohBP8LVIRYpCXZEPQXl0HBxqFxXZdaBqWxHOQa8hDiiTvnMo
# d5uT++sT26SugnzM4t6IZdCGsPyVwam3rjrMhEHCI71omGNMd7nCQljz6Zk2fjiX
# YSxaRNcVfQFHHpWOZ2ShOtaX8AkGtmDGljkYJ7ZHmVD3S2Bd0HIxahdAMO5gZy//
# RhgpzOkBhJsamHzkGMnrCg7sxPFTb6QJnNKuGPkj/Xb7p8TkrjgTuwfq4lQp2JeK
# M+iw3Jf12CiejjkFqdogKqfKCQknf3r6MJ5vPYteN6BxNvd3Zqk/PaaWLXjnRxvq
# uXhmi20dJIHgxHzBd/rdmhfFHBgXKza+Bok=
# SIG # End signature block

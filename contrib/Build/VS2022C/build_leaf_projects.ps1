#
# DemoIccMAX Project | Build Leaf Projects | Build Script for Windows & VS2022C
# Refactor Date: 30-Sept-2024
# Author: David Hoyt
# Purpose: Automates the build and testing for the PCS_Refactor on Windows + VS2022C
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contribBuild/VS2022C/build_leaf_projects.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting DemoIccMAX LEaf Project Build =============================" -ForegroundColor Green
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
Write-Host "Copyright (c) 2024 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "Author: David Hoyt | dhoyt@hoyt.net" -ForegroundColor Green
Write-Host "Building .vcxproj files selectively, the running the .exe files to check build"

Write-Host "Fixups for bad project configs"
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib 

# Confirmed working point and shoot
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\IccLibXML\IccLibXML_CRTDLL_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\IccLibXML\IccLibXML_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_CRTDLL_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_DLL_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccProfLib\IccProfLib_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\CmdLine\IccFromXml\IccFromXml_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\CmdLine\IccToXml\IccToXml_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyNamedCmm\iccApplyNamedCmm_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyToLink\iccApplyToLink_v16.vcxproj" /p:PlatformToolset=v143 /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccFromCube\iccFromCube_v16.vcxproj" /p:PlatformToolset=v143 /p:Configuration=Debug /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO"
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccRoundTrip\iccRoundTrip_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccTiffDump\iccTiffDump_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccV5DspObsToV4Dsp\IccV5DspObsToV4Dsp_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\Winnt\DemoIccMAXCmm\DemoIccMAXCmm_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" 
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyProfiles\iccApplyProfiles_v22.vcxproj"  /p:Configuration=Debug /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccSpecSepToTiff\iccSpecSepToTiff_v22.vcxproj"  /p:Configuration=Debug /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build

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

Write-Host "All Done!"

# SIG # Begin signature block
# MII9BQYJKoZIhvcNAQcCoII89jCCPPICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDJBVSbr7IuzagA
# I67KOi3PxZOXCxEMeSwUvPl5V3Dnw6CCIqIwggXMMIIDtKADAgECAhBUmNLR1FsZ
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
# 03u4aUoqlmZpxJTG9F9urJh4iIAGXKKy7aIwggblMIIEzaADAgECAhMzAAEH2jQU
# NwFhPC9IAAAAAQfaMA0GCSqGSIb3DQEBDAUAMFoxCzAJBgNVBAYTAlVTMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKzApBgNVBAMTIk1pY3Jvc29mdCBJ
# RCBWZXJpZmllZCBDUyBFT0MgQ0EgMDEwHhcNMjQxMDMwMTI0NTI3WhcNMjQxMTAy
# MTI0NTI3WjBlMQswCQYDVQQGEwJVUzEQMA4GA1UECBMHVmVybW9udDEOMAwGA1UE
# BxMFU3Rvd2UxGTAXBgNVBAoTEERhdmlkIEggSG95dCBMTEMxGTAXBgNVBAMTEERh
# dmlkIEggSG95dCBMTEMwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCI
# IxzLSssCELKFGvHVtpLhsWJZazGpp06frzIJDnPMtnrsSVdPiRGwSg4P0cNWrXOH
# OqVrjL3kA0wru7wgIyrLgsT8MDnzAFDS2ZbDCUiYMn9Z/0EqIh9HKVH+GUcDzA8j
# kHcR8lD62A3EfGVxUorvB1IHtXWdXdq/UcbBfA0HS41mWTh2Sz/dBMwdj+w2bYMi
# zAt0NrzRwoeUUR7Hi2HzT8BQyXQTXmogRJoj0ZlJ8zt7ugb4D9Mapkkx7aHjN4WH
# dMk6GRej7aC8frlc+iEGrB5emOgO1DfU3AOvr/w1R4BdWxKN0vjhvWplDpFcxo/u
# TShBbIpQTku4zWeuGfOyKyrbOS4HPSJP8a7AAEJG7C/V397IZhTMYEysNCiVevMp
# AOt0/v1A1t78OK2u+II4yXwhzA8DtzxB0Yfz+g0yiat5RmMacXjNqEwpxU4SvasV
# OzUZ3FO3ygsNYKHRpsL89svnwKU9sd3B03fds3PDmWzSki34RndTgIr+uPTofh8C
# AwEAAaOCAhcwggITMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMDoGA1Ud
# JQQzMDEGCisGAQQBgjdhAQAGCCsGAQUFBwMDBhkrBgEEAYI3Yd3D5j2C3IfhdYXS
# i06euL1zMB0GA1UdDgQWBBRianiouQTrMKPB//JZiR+pdVnZ8jAfBgNVHSMEGDAW
# gBR2nDZ0E9GQfWFfswLrgPSZS6U+hTBnBgNVHR8EYDBeMFygWqBYhlZodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBJRCUyMFZl
# cmlmaWVkJTIwQ1MlMjBFT0MlMjBDQSUyMDAxLmNybDCBpQYIKwYBBQUHAQEEgZgw
# gZUwZAYIKwYBBQUHMAKGWGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y2VydHMvTWljcm9zb2Z0JTIwSUQlMjBWZXJpZmllZCUyMENTJTIwRU9DJTIwQ0El
# MjAwMS5jcnQwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vbmVvY3NwLm1pY3Jvc29mdC5j
# b20vb2NzcDBmBgNVHSAEXzBdMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9y
# eS5odG0wCAYGZ4EMAQQBMA0GCSqGSIb3DQEBDAUAA4ICAQAn2vOyHvY7fu3stlM5
# /j6Lu9OGGEJUMwotD/rJneKvxmFHhYPS5/gfc5H6iKFH5o9wBtY0gB9G1AYXRW+5
# VvpU4Y66t5TEqkcNZz0QGmnYmIijFf72Lnij1Rx1qg/M3Wy491v6kqn/F63ro9J7
# 5WBhlrFlxdf8oSCBYEfcRAHTJ69k/JPfNZL613UqxhvhNfNcSBpfqy+Xb8QhJDVP
# Ok+DcXoH7f2SP0Cv9hjoCxotgmNHRHf54yGpJ6fD53GqyFDCY0LW3iCd82J72PmX
# 4uI4IJ6dqWs2YHYu63HUE2Ne29LHQYR4dh9asoUXwipud49DohSH3VzPPCHRYfXc
# PrSGLGaHLI8ImTVmnn6or1l5dRtr4KafkQtrGdDQ7niAQ02ilQ/st9QI4mUBRMOo
# HB0Dy4p7Tot2ANQ1AKFG6CPHrLys2wwPZLizKjYjqLNDLETlf8gBF0Itf9clkW6W
# uZlcM4Fl5WzUBlo+uHoBiNMELVZaILF7BHYQVS1D89hA1m5/BWats45dFzm6gU4i
# qlncDi1MbHoeQIEvWq3rWRhNYEzKqzkYtPsApx+5eNPoo+owXzMvMAKMU9o/d76i
# jbv44OjrVduef87oYf2LsIsam2/nyCPWOSD6C4HcP6chWM7tv5/LLi9+YqKkxjYy
# De4UlaG6AWjcClLDXMVPXuHiRDCCBuUwggTNoAMCAQICEzMAAQfaNBQ3AWE8L0gA
# AAABB9owDQYJKoZIhvcNAQEMBQAwWjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiTWljcm9zb2Z0IElEIFZlcmlm
# aWVkIENTIEVPQyBDQSAwMTAeFw0yNDEwMzAxMjQ1MjdaFw0yNDExMDIxMjQ1Mjda
# MGUxCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdWZXJtb250MQ4wDAYDVQQHEwVTdG93
# ZTEZMBcGA1UEChMQRGF2aWQgSCBIb3l0IExMQzEZMBcGA1UEAxMQRGF2aWQgSCBI
# b3l0IExMQzCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAIgjHMtKywIQ
# soUa8dW2kuGxYllrMamnTp+vMgkOc8y2euxJV0+JEbBKDg/Rw1atc4c6pWuMveQD
# TCu7vCAjKsuCxPwwOfMAUNLZlsMJSJgyf1n/QSoiH0cpUf4ZRwPMDyOQdxHyUPrY
# DcR8ZXFSiu8HUge1dZ1d2r9RxsF8DQdLjWZZOHZLP90EzB2P7DZtgyLMC3Q2vNHC
# h5RRHseLYfNPwFDJdBNeaiBEmiPRmUnzO3u6BvgP0xqmSTHtoeM3hYd0yToZF6Pt
# oLx+uVz6IQasHl6Y6A7UN9TcA6+v/DVHgF1bEo3S+OG9amUOkVzGj+5NKEFsilBO
# S7jNZ64Z87IrKts5Lgc9Ik/xrsAAQkbsL9Xf3shmFMxgTKw0KJV68ykA63T+/UDW
# 3vw4ra74gjjJfCHMDwO3PEHRh/P6DTKJq3lGYxpxeM2oTCnFThK9qxU7NRncU7fK
# Cw1godGmwvz2y+fApT2x3cHTd92zc8OZbNKSLfhGd1OAiv649Oh+HwIDAQABo4IC
# FzCCAhMwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCB4AwOgYDVR0lBDMwMQYK
# KwYBBAGCN2EBAAYIKwYBBQUHAwMGGSsGAQQBgjdh3cPmPYLch+F1hdKLTp64vXMw
# HQYDVR0OBBYEFGJqeKi5BOswo8H/8lmJH6l1WdnyMB8GA1UdIwQYMBaAFHacNnQT
# 0ZB9YV+zAuuA9JlLpT6FMGcGA1UdHwRgMF4wXKBaoFiGVmh0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMElEJTIwVmVyaWZpZWQl
# MjBDUyUyMEVPQyUyMENBJTIwMDEuY3JsMIGlBggrBgEFBQcBAQSBmDCBlTBkBggr
# BgEFBQcwAoZYaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9N
# aWNyb3NvZnQlMjBJRCUyMFZlcmlmaWVkJTIwQ1MlMjBFT0MlMjBDQSUyMDAxLmNy
# dDAtBggrBgEFBQcwAYYhaHR0cDovL29uZW9jc3AubWljcm9zb2Z0LmNvbS9vY3Nw
# MGYGA1UdIARfMF0wUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTAI
# BgZngQwBBAEwDQYJKoZIhvcNAQEMBQADggIBACfa87Ie9jt+7ey2Uzn+Pou704YY
# QlQzCi0P+smd4q/GYUeFg9Ln+B9zkfqIoUfmj3AG1jSAH0bUBhdFb7lW+lThjrq3
# lMSqRw1nPRAaadiYiKMV/vYueKPVHHWqD8zdbLj3W/qSqf8Xreuj0nvlYGGWsWXF
# 1/yhIIFgR9xEAdMnr2T8k981kvrXdSrGG+E181xIGl+rL5dvxCEkNU86T4Nxegft
# /ZI/QK/2GOgLGi2CY0dEd/njIaknp8PncarIUMJjQtbeIJ3zYnvY+Zfi4jggnp2p
# azZgdi7rcdQTY17b0sdBhHh2H1qyhRfCKm53j0OiFIfdXM88IdFh9dw+tIYsZocs
# jwiZNWaefqivWXl1G2vgpp+RC2sZ0NDueIBDTaKVD+y31AjiZQFEw6gcHQPLintO
# i3YA1DUAoUboI8esvKzbDA9kuLMqNiOos0MsROV/yAEXQi1/1yWRbpa5mVwzgWXl
# bNQGWj64egGI0wQtVlogsXsEdhBVLUPz2EDWbn8FZq2zjl0XObqBTiKqWdwOLUxs
# eh5AgS9aretZGE1gTMqrORi0+wCnH7l40+ij6jBfMy8wAoxT2j93vqKNu/jg6OtV
# 255/zuhh/Yuwixqbb+fII9Y5IPoLgdw/pyFYzu2/n8suL35ioqTGNjIN7hSVoboB
# aNwKUsNcxU9e4eJEMIIHWjCCBUKgAwIBAgITMwAAAAZKGvrPBWFqdAAAAAAABjAN
# BgkqhkiG9w0BAQwFADBjMQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTQwMgYDVQQDEytNaWNyb3NvZnQgSUQgVmVyaWZpZWQgQ29k
# ZSBTaWduaW5nIFBDQSAyMDIxMB4XDTIxMDQxMzE3MzE1NFoXDTI2MDQxMzE3MzE1
# NFowWjELMAkGA1UEBhMCVVMxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjErMCkGA1UEAxMiTWljcm9zb2Z0IElEIFZlcmlmaWVkIENTIEVPQyBDQSAwMTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMfjyD/0Id3GGcC7xcurrieH
# 06d5Z+xqrO7PJU1cn4DiVj9WgAcJNv6MXVY30h1KuDEz14pS+e6ov3x+2J3RCuCp
# 3d7uXHnRcK9mh0k6er5fzy9XQC/bH6A7zaXRtDf0fOAIWDaQUE4aTuPwasZgoJd4
# iEX4YdqBVTrok4g1Vr1wYO+m3I5x5xBLV87wFsCbtGwVO6EUakHneFVybSAlbfma
# ClEo6mOcFJYQHcB4ft9QZ6QTwsxbSlYi6esxLUcjsUXoGoBVPsi4F775ndOyAzdE
# tky2LomY08PpHGDraDYCq+5NAuhPVn9x+Ix2r5NjMahabYHy9IC/s20m/lQTSolU
# 9Jqs1ySCZlpqsNCvg9zCn5gnq93twm6z/heUbQm9F2hNLkXCT2SY1sHIgwcQSG5D
# ReBi9doZeb8nYBTJs0HDbqHSsl//95Sydattq6B1UtXILbC4KY1mGZQZYQk3FyXm
# d8bmib12Qfa3Cwl9eToFy9tbVFMCQixNu1eQBmcZDt4ueJoEgrMLTpllOACnfwf3
# tyrV7+lwVESrgLXns9RKYJaGmcEHo/ZeXTfVIfFtfQWYPSJS5fsR0V+Lw4jFgFH/
# +wDXuDKEvfBeOa++iBidIQtNhDLjGcQBK8GY9JZ9Gi+dxM5TGuSQokTm29FKCx3x
# knTSbDINLo9wwEA3VVkxAgMBAAGjggIOMIICCjAOBgNVHQ8BAf8EBAMCAYYwEAYJ
# KwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFHacNnQT0ZB9YV+zAuuA9JlLpT6FMFQG
# A1UdIARNMEswSQYEVR0gADBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wGQYJKwYBBAGCNxQC
# BAweCgBTAHUAYgBDAEEwEgYDVR0TAQH/BAgwBgEB/wIBADAfBgNVHSMEGDAWgBTZ
# QSmwDw9jbO9p1/XNKZ6kSGow5jBwBgNVHR8EaTBnMGWgY6Bhhl9odHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBJRCUyMFZlcmlm
# aWVkJTIwQ29kZSUyMFNpZ25pbmclMjBQQ0ElMjAyMDIxLmNybDCBrgYIKwYBBQUH
# AQEEgaEwgZ4wbQYIKwYBBQUHMAKGYWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwSUQlMjBWZXJpZmllZCUyMENvZGUlMjBT
# aWduaW5nJTIwUENBJTIwMjAyMS5jcnQwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vbmVv
# Y3NwLm1pY3Jvc29mdC5jb20vb2NzcDANBgkqhkiG9w0BAQwFAAOCAgEAai8Jn9iw
# dUI1IGtBu8xZGxnfDQUCxz9CjhQVjSRWYk7Sn6TtG2dln7Or+b6iCoxN9kOjPPRu
# GZFXL1rhAAPnb4y04UsvPWNP/5v1k0isGLYkdRMJ+8dZMPxYPd8EKbNgtVlI/tNP
# +rjaxfneDFScVdR6ASA/veWSFtCpKmaKZzgOMObz+E+XAaa2UAJT/7zBsgdB/fqR
# zaNI0/UPIHyiTcx0vYtQ4AZprnxnVvUwcrp6PBgIsxTIS5SLNPG+ZYpSJBOc9xTA
# FAK/l4CCNRTWZ2+NziOkHdszoo242H7q7F1AjRwvkUsCRpuVC8z8pmIIJyfpISTq
# u6EpajxqW6+9IRgXj8Pye/5pkqqe4U4LdJj4pEtYuGqfMfj98npmEoZxa4Fde+dk
# yPgLOvS34C7YZCE73+2xRwfL5iIWnWQjktL0wsdwfvzlXBDCzTtmydDvYpHNSakd
# Bb6se5wMDEUodxVaqLIMwW1p1ZECau6FhcDFXxSGJ+iz0WTLePLuojFAhQUj3XbD
# wP+pPOZhL/tPFOVgkO8nY9SlVdkx63v/Jix4npvcH/ws6IakZ7cTNhP8fjR8ukwT
# J0j0EaoYTX7joFAwFhGJpTP2RxmjyG+8Tr31ci0P+5emH6IE93qbcKeBjhkYx+c/
# oBvZKQSMfEK0ZejopZ5cURMaJJjH5S+5ddkwggeeMIIFhqADAgECAhMzAAAAB4ej
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
# rRw+p+fL4WrxSK5nMYIZuTCCGbUCAQEwcTBaMQswCQYDVQQGEwJVUzEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYDVQQDEyJNaWNyb3NvZnQgSUQg
# VmVyaWZpZWQgQ1MgRU9DIENBIDAxAhMzAAEH2jQUNwFhPC9IAAAAAQfaMA0GCWCG
# SAFlAwQCAQUAoF4wEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwLwYJKoZIhvcNAQkEMSIEIB4DoLXB0TvBAwHrRO5Q78+u8wIyrFgp
# R3f8BaL27G1RMA0GCSqGSIb3DQEBAQUABIIBgFo3uVMyKl+9B6vkrWDHPvuYOWKb
# +dsnvCSfDjYh0vAiSdxeG1GiRdBDYMn8oVbXm11RidmNgwbKWxp/aP4tfOpf1nqy
# SMHHn7e+FI3UbU9C3qsgm9a3YSUu5UHv5LYDSJMm3nEV2K6dKS/Qnz/UxMQlkCri
# wkFE7jwkyw0xKu5vZGrBN5C1dYbezp0lGPpZaRpDUiCDPtTk+t+IlhZmsdI/zK7O
# iKHTxzbNe27OEEx8Bej37/BXMBPSVfTOPpjGZOhqf8NfciEFNUyaPb0nJDxAkd6s
# FzjpXX/mGrga1kS3Wk6LXp7OVJgsl8j7RwRrbUrS/AdLhwx0utfm+stYBaa9XEtk
# uShQquAoFJCLsTYgrqNX8dWlkbSTErtcZBkgNXVbsh3CIbxRCU32iHeCAozCxn6q
# atk3o2+inKaBXXIhb9JgOOcU3md3KAn1MoDysz7WddbeoUFTMwcIkj2nKHc2TWRN
# Ex42Z3OVR9izUsxBEWyfgQILlBwzKnjY1WtmSKGCFzkwghc1BgorBgEEAYI3AwMB
# MYIXJTCCFyEGCSqGSIb3DQEHAqCCFxIwghcOAgEDMQ8wDQYJYIZIAWUDBAIBBQAw
# dwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQC
# AQUABCDlsYB5yhZtNU11QGyiDK6OTM+vAK0eljCfDy7WvtzAfwIQZNPE8AybYWC5
# kmvmNgvxDxgPMjAyNDEwMzAxNTE1MDVaoIITAzCCBrwwggSkoAMCAQICEAuuZrxa
# un+Vh8b56QTjMwQwDQYJKoZIhvcNAQELBQAwYzELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0
# IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0yNDA5MjYwMDAwMDBa
# Fw0zNTExMjUyMzU5NTlaMEIxCzAJBgNVBAYTAlVTMREwDwYDVQQKEwhEaWdpQ2Vy
# dDEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0YW1wIDIwMjQwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQC+anOf9pUhq5Ywultt5lmjtej9kR8YxIg7apnj
# pcH9CjAgQxK+CMR0Rne/i+utMeV5bUlYYSuuM4vQngvQepVHVzNLO9RDnEXvPghC
# aft0djvKKO+hDu6ObS7rJcXa/UKvNminKQPTv/1+kBPgHGlP28mgmoCw/xi6FG9+
# Un1h4eN6zh926SxMe6We2r1Z6VFZj75MU/HNmtsgtFjKfITLutLWUdAoWle+jYZ4
# 9+wxGE1/UXjWfISDmHuI5e/6+NfQrxGFSKx+rDdNMsePW6FLrphfYtk/FLihp/fe
# un0eV+pIF496OVh4R1TvjQYpAztJpVIfdNsEvxHofBf1BWkadc+Up0Th8EifkEEW
# dX4rA/FE1Q0rqViTbLVZIqi6viEk3RIySho1XyHLIAOJfXG5PEppc3XYeBH7xa6V
# TZ3rOHNeiYnY+V4j1XbJ+Z9dI8ZhqcaDHOoj5KGg4YuiYx3eYm33aebsyF6eD9MF
# 5IDbPgjvwmnAalNEeJPvIeoGJXaeBQjIK13SlnzODdLtuThALhGtyconcVuPI8Aa
# iCaiJnfdzUcb3dWnqUnjXkRFwLtsVAxFvGqsxUA2Jq/WTjbnNjIUzIs3ITVC6VBK
# AOlb2u29Vwgfta8b2ypi6n2PzP0nVepsFk8nlcuWfyZLzBaZ0MucEdeBiXL+nUOG
# hCjl+QIDAQABo4IBizCCAYcwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAw
# FgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJ
# YIZIAYb9bAcBMB8GA1UdIwQYMBaAFLoW2W1NhS9zKXaaL3WMaiCPnshvMB0GA1Ud
# DgQWBBSfVywDdw4oFZBmpWNe7k+SH3agWzBaBgNVHR8EUzBRME+gTaBLhklodHRw
# Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hB
# MjU2VGltZVN0YW1waW5nQ0EuY3JsMIGQBggrBgEFBQcBAQSBgzCBgDAkBggrBgEF
# BQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFgGCCsGAQUFBzAChkxodHRw
# Oi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2
# U0hBMjU2VGltZVN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQA9rR4f
# dplb4ziEEkfZQ5H2EdubTggd0ShPz9Pce4FLJl6reNKLkZd5Y/vEIqFWKt4oKcKz
# 7wZmXa5VgW9B76k9NJxUl4JlKwyjUkKhk3aYx7D8vi2mpU1tKlY71AYXB8wTLrQe
# h83pXnWwwsxc1Mt+FWqz57yFq6laICtKjPICYYf/qgxACHTvypGHrC8k1TqCeHk6
# u4I/VBQC9VK7iSpU5wlWjNlHlFFv/M93748YTeoXU/fFa9hWJQkuzG2+B7+bMDvm
# gF8VlJt1qQcl7YFUMYgZU1WM6nyw23vT6QSgwX5Pq2m0xQ2V6FJHu8z4LXe/371k
# 5QrN9FQBhLLISZi2yemW0P8ZZfx4zvSWzVXpAb9k4Hpvpi6bUe8iK6WonUSV6yPl
# MwerwJZP/Gtbu3CKldMnn+LmmRTkTXpFIEB06nXZrDwhCGED+8RsWQSIXZpuG4WL
# FQOhtloDRWGoCwwc6ZpPddOFkM2LlTbMcqFSzm4cd0boGhBq7vkqI1uHRz6Fq1IX
# 7TaRQuR+0BGOzISkcqwXu7nMpFu3mgrlgbAW+BzikRVQ3K2YHcGkiKjA4gi4OA/k
# z1YCsdhIBHXqBzR0/Zd2QwQ/l4Gxftt/8wY3grcc/nS//TVkej9nmUYu83BDtccH
# HXKibMs/yXHhDXNkoPIdynhVAku7aRZOwqw6pDCCBq4wggSWoAMCAQICEAc2N7ck
# VHzYR6z9KGYqXlswDQYJKoZIhvcNAQELBQAwYjELMAkGA1UEBhMCVVMxFTATBgNV
# BAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8G
# A1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MB4XDTIyMDMyMzAwMDAwMFoX
# DTM3MDMyMjIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0
# LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hB
# MjU2IFRpbWVTdGFtcGluZyBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAMaGNQZJs8E9cklRVcclA8TykTepl1Gh1tKD0Z5Mom2gsMyD+Vr2EaFEFUJf
# pIjzaPp985yJC3+dH54PMx9QEwsmc5Zt+FeoAn39Q7SE2hHxc7Gz7iuAhIoiGN/r
# 2j3EF3+rGSs+QtxnjupRPfDWVtTnKC3r07G1decfBmWNlCnT2exp39mQh0YAe9tE
# QYncfGpXevA3eZ9drMvohGS0UvJ2R/dhgxndX7RUCyFobjchu0CsX7LeSn3O9TkS
# Z+8OpWNs5KbFHc02DVzV5huowWR0QKfAcsW6Th+xtVhNef7Xj3OTrCw54qVI1vCw
# MROpVymWJy71h6aPTnYVVSZwmCZ/oBpHIEPjQ2OAe3VuJyWQmDo4EbP29p7mO1vs
# gd4iFNmCKseSv6De4z6ic/rnH1pslPJSlRErWHRAKKtzQ87fSqEcazjFKfPKqpZz
# QmiftkaznTqj1QPgv/CiPMpC3BhIfxQ0z9JMq++bPf4OuGQq+nUoJEHtQr8FnGZJ
# UlD0UfM2SU2LINIsVzV5K6jzRWC8I41Y99xh3pP+OcD5sjClTNfpmEpYPtMDiP6z
# j9NeS3YSUZPJjAw7W4oiqMEmCPkUEBIDfV8ju2TjY+Cm4T72wnSyPx4JduyrXUZ1
# 4mCjWAkBKAAOhFTuzuldyF4wEr1GnrXTdrnSDmuZDNIztM2xAgMBAAGjggFdMIIB
# WTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBS6FtltTYUvcyl2mi91jGog
# j57IbzAfBgNVHSMEGDAWgBTs1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8E
# BAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwgwdwYIKwYBBQUHAQEEazBpMCQGCCsG
# AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0
# dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQu
# Y3J0MEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydFRydXN0ZWRSb290RzQuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsG
# CWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEAfVmOwJO2b5ipRCIBfmbW2CFC
# 4bAYLhBNE88wU86/GPvHUF3iSyn7cIoNqilp/GnBzx0H6T5gyNgL5Vxb122H+oQg
# JTQxZ822EpZvxFBMYh0MCIKoFr2pVs8Vc40BIiXOlWk/R3f7cnQU1/+rT4osequF
# zUNf7WC2qk+RZp4snuCKrOX9jLxkJodskr2dfNBwCnzvqLx1T7pa96kQsl3p/yhU
# ifDVinF2ZdrM8HKjI/rAJ4JErpknG6skHibBt94q6/aesXmZgaNWhqsKRcnfxI2g
# 55j7+6adcq/Ex8HBanHZxhOACcS2n82HhyS7T6NJuXdmkfFynOlLAlKnN36TU6w7
# HQhJD5TNOXrd/yVjmScsPT9rp/Fmw0HNT7ZAmyEhQNC3EyTN3B14OuSereU0cZLX
# JmvkOHOrpgFPvT87eK1MrfvElXvtCl8zOYdBeHo46Zzh3SP9HSjTx/no8Zhf+yvY
# fvJGnXUsHicsJttvFXseGYs2uJPU5vIXmVnKcPA3v5gA3yAWTyf7YGcWoWa63VXA
# OimGsJigK+2VQbc61RWYMbRiCQ8KvYHZE/6/pNHzV9m8BPqC3jLfBInwAM1dwvnQ
# I38AC+R2AibZ8GV2QqYphwlHK+Z/GqSFD/yYlvZVVCsfgPrA8g4r5db7qS9EFUrn
# Ew4d2zc4GqEr9u3WfPwwggWNMIIEdaADAgECAhAOmxiO+dAt5+/bUOIIQBhaMA0G
# CSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0
# IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBaFw0zMTExMDkyMzU5
# NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQg
# Um9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL/mkHNo3rvk
# XUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4FutWxpdt
# HauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZanMylNEQRBAu
# 34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0
# QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL2pNe3I6PgNq2
# kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM
# 1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3JFxGj2T3wWmI
# dph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZ
# K37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhElRp2Yn72
# gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0viastkF13nqs
# X40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyh
# HsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIBNjAPBgNVHRMBAf8E
# BTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwPTzAfBgNVHSMEGDAW
# gBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMCAYYweQYIKwYBBQUH
# AQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYI
# KwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAE
# CjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0NcVec4X6CjdBs9thbX
# 979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnovLbc47/T/gLn4offy
# ct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65ZyoUi0mcudT6cGAxN3
# J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFWjuyk1T3osdz9HNj0
# d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPFmCLBsln1VWvPJ6ts
# ds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9ztwGpn1eqXijiuZQx
# ggN2MIIDcgIBATB3MGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1
# NiBUaW1lU3RhbXBpbmcgQ0ECEAuuZrxaun+Vh8b56QTjMwQwDQYJYIZIAWUDBAIB
# BQCggdEwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEP
# Fw0yNDEwMzAxNTE1MDVaMCsGCyqGSIb3DQEJEAIMMRwwGjAYMBYEFNvThe5i29I+
# e+T2cUhQhyTVhltFMC8GCSqGSIb3DQEJBDEiBCBZ4LiqvBIPZwI/RQJUI7FjctcZ
# pVxFclD1fU+qR8bkfjA3BgsqhkiG9w0BCRACLzEoMCYwJDAiBCB2dp+o8mMvH0ML
# OiMwrtZWdf7Xc9sF1mW5BZOYQ4+a2zANBgkqhkiG9w0BAQEFAASCAgBG3vSOZLJq
# ag9jg60/WqCPvB2mPIHKByJny7RKfO+XIe6Y0sRdMK2Hf0vFqMFxJ+pjNSiDC0Bx
# So+UFufnkVrEKPjU5tgfZgv2sIpsJno/KlXXWGJz/Il4Rzs4V0uYR52Y3Uji0Vus
# jG3tJIm8iLpbIOY1/3mlIbtaZWG4yobgox2GQ/Rzt+r7g0YkWBV0ZV7m6ufmMLcq
# Tb83plBRJObAb+htVESiDSOiDXU1pdmwlYDp2ONp6yYiC1dnGU98veiF3OHWqDJh
# l7+6WF3GeVXaXEdH90MHHJZV088/+FdyoEmh45L5XtmpzSq4hYz+86uxCUeODvsh
# kbgMkPY1EzlipuCgvb1OlUTZumdsDTpuHC9UM1mEH47Bg2Fue2BrE2p87ao6fwY5
# SkgpMFEU3+gvlB5ZhzdYodbfwYNiFU6+Vhgf8It4qKtWdHmBkvaAK0/RFyMKNxGs
# tbedm2wmzdxU5bMbN1umoYP68xy+OuBgSnbv76VXGhwjsc2/vyJgkuO2szX8Undj
# SS8rOA8llvHM/ozNIUH1aWbvG0Wcon5vzBe58cG8gGDGRsNGav/tRARNgklbFPfo
# /kdtMx5ZmKHtPvZqvNqunk1v5R8vxG5QrNI/aklIjFSJkCaN66VTfUDhlyMPUNtE
# RMEDxnFYQ7X1D0RCiE8NXq1ZEFxFkXef9w==
# SIG # End signature block

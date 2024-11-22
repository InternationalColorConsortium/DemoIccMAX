#
# DemoIccMAX Project | Build Leaf Projects | Build Script for Windows & VS2022C
# Refactor Date: 30-Sept-2024
# Author: David Hoyt
# Purpose: Automates the build and testing for the PCS_Refactor on Windows + VS2022C
#
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build_leaf_projects_release.ps1").Content
#
# ============================================================

# Start of Script
Write-Host "============================= Starting DemoIccMAX Leaf Projects Build =============================" -ForegroundColor Green
$env:VSCMD_ARG_HOST_ARCH = "x64"
$env:VSCMD_ARG_TGT_ARCH = "x64"
Write-Host "Copyright (c) 2024 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "Author: David Hoyt dhoyt@hoyt.net" -ForegroundColor Green

Write-Host "Fixups for bad project configs"
copy C:\test\vcpkg\installed\x64-windows\lib\tiff.lib C:\test\vcpkg\installed\x64-windows\lib\libtiff.lib
copy C:\test\vcpkg\installed\x64-windows-static\lib\tiff.lib C:\test\vcpkg\installed\x64-windows-static\lib\libtiff.lib 


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
msbuild /m /maxcpucount "C:\test\DemoIccMAX\Tools\CmdLine\IccApplyProfiles\iccApplyProfiles_v22.vcxproj"  /p:Configuration=Release /p:Platform=x64 /p:VcpkgTriplet=x64-windows-static /p:AdditionalIncludeDirectories="C:\test\vcpkg\installed\x64-windows-static\include" /p:AdditionalLibraryDirectories="C:\test\vcpkg\installed\x64-windows-static\lib" /p:CLToolAdditionalOptions="/MT /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/NODEFAULTLIB:msvcrt /LTCG /OPT:REF /INCREMENTAL:NO" /t:Clean,Build
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
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB22+YPS0lGbDSy
# DQ+ltaS1A4nNqq8L+hFtZHpLGY9dLqCCIqIwggXMMIIDtKADAgECAhBUmNLR1FsZ
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
# rRw+p+fL4WrxSK5nMYIZujCCGbYCAQEwcTBaMQswCQYDVQQGEwJVUzEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYDVQQDEyJNaWNyb3NvZnQgSUQg
# VmVyaWZpZWQgQ1MgRU9DIENBIDAxAhMzAAEH2jQUNwFhPC9IAAAAAQfaMA0GCWCG
# SAFlAwQCAQUAoF4wEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwLwYJKoZIhvcNAQkEMSIEIDvc01Dsc/tq+fOkjnNGTcrYqX1RtfkW
# jX8mkoG6T9Q6MA0GCSqGSIb3DQEBAQUABIIBgEehAcAxLzi/S+3nBDSVV+MXlcDL
# 0KQTAUd5kiFB4U7r9ZkUK18scFTZdxztNnDCVGlcFnafUhLb0pBT6lg3ViL4cSYX
# +vBxAMv7DGiNzgNeDIqGVxxrvd083PhZtQIKTDXsntG+4HRN781u9tGmNiH9MAuf
# agnYOjOGkmcmRYzM+JkRGgK3IZ2HP1vphx3cT6F4hY+ibl72KcPnzRpscJ4w6pU5
# xvHtxrBY+OkyMk7dQt0/JnWag/dCEW6EST2DnRuaOR37ppn/np0WJ8EGAkJO+Vel
# mZNA7dzfFH5kDKhtYaCbj5jMHsItNvpfYGjYktGI2mayvL6dB57CriHFEO+Xk2Q8
# pACBghUgnVYF6ryCGvK3kPm2KPXII0jv+uowLsfdEjhiAaWrGiWaHAaCPX29F9GF
# To/vAand707CBJmt14EPI0LqkI/wr6gJ1b8xlIZ2N6InkYPEY9bR39EJlR58kB6X
# EgR3tZpC8zsIRNSolFOEU4w+LRM8xkjLR7UdJqGCFzowghc2BgorBgEEAYI3AwMB
# MYIXJjCCFyIGCSqGSIb3DQEHAqCCFxMwghcPAgEDMQ8wDQYJYIZIAWUDBAIBBQAw
# eAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQC
# AQUABCDB2C8ePHEmBhDuVY1wiVlJqmm3Q9LMUY7ldzwygxjbOQIRAKTtlGh4k8mk
# mFH6nFAygHAYDzIwMjQxMDMwMTUxNTE1WqCCEwMwgga8MIIEpKADAgECAhALrma8
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
# DxcNMjQxMDMwMTUxNTE1WjArBgsqhkiG9w0BCRACDDEcMBowGDAWBBTb04XuYtvS
# Pnvk9nFIUIck1YZbRTAvBgkqhkiG9w0BCQQxIgQgIhivrZ3N/SwO1PQxqPqkmlh3
# ZJxEBqkgzNRqY8LVfIAwNwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgdnafqPJjLx9D
# CzojMK7WVnX+13PbBdZluQWTmEOPmtswDQYJKoZIhvcNAQEBBQAEggIAoE7bgnz1
# UeuziPDtPUL4dXQ27xOyJ0KijlxC9zH/5qGC11+9E/XeURQkj+gaL3parQXuaq7T
# EDJ8OZJKRqksVp6kuo1fLB+PtKzALmayKjx5JCkJZ4GsRpW9u3bdkqMkga22tqeg
# 5QFoDK+XAD0jIZpd2KyhY/EnJG4bGroNSmwVD4ufLHCZiGi98lIjXx45mPg1ivNr
# 8jaxPBH74Dy1/7wBQ/tydKuFAysdPaBXJo3PUqvLSN2BeCzpsbise4+VvLAfLoA3
# 2qVkESPO4wkXjBKOYLqFp6dhbqTMftmBBj+eM54GRfyaWx0d5xGmKQanGhfjN1Q3
# 0H33h4sQHAx6IWzu27MFawCD2RoKc8xukjaZs2IopaRqkqdfzQf8nrTQOCT7KrYg
# F+SVHIxCDWVRTqpvjxHNdLZvlFTp/sldFhlkqyJ7njsU/28XcCK9Wk+RZYlOMR6Q
# 7C5fIKsuoGsmsr0KMedXIrmTTMrj0VAdZa2XFumCazv8vIHo2TBfCeKwMmJ3yFdk
# X6Ld3XCGqR2uZ+BlHh8hv6d4uETPm98ncU5n0PZ97p7re/32vL/YXiVh0ORAZIeI
# a95pqIJTDmFoYRLp5k73dbw1jr/oIKIlHTBc9pPBFwfqZrOUjTzmzrajeUra/KQL
# 3FSj/m4qs75ibpmpvhtPA1BTVSzHr/02gd8=
# SIG # End signature block

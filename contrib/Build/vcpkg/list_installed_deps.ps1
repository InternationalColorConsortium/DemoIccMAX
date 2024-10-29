# List all packages installed for x64-windows triplet
.\vcpkg.exe list | Select-String "x64-windows"

# List all packages installed for x64-windows-static triplet
.\vcpkg.exe list | Select-String "x64-windows-static"

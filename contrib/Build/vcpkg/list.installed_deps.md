# List installed vcpkg packages

1. Verify the Correct Packages Are Installed for the Triplet
Use the vcpkg list command with a filter for the x64-windows and x64-windows-static triplets separately to ensure the correct libraries are installed under that triplet.

# List all packages installed for x64-windows triplet

```
.\vcpkg.exe list | Select-String "x64-windows"
```

# List all packages installed for x64-windows-static triplet
```
.\vcpkg.exe list | Select-String "x64-windows-static"
```

This will help you verify which libraries are associated with each triplet. If you don’t see the expected packages, you may need to install them.

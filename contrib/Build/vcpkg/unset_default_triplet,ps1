# Unset VCPKG_DEFAULT_TRIPLET if it's set to x86
if ($env:VCPKG_DEFAULT_TRIPLET -eq "x86-windows") {
    Log-Message "Unsetting VCPKG_DEFAULT_TRIPLET as it is set to x86-windows..."
    Remove-Item Env:\VCPKG_DEFAULT_TRIPLET
}

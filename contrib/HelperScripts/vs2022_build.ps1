# Define the repository URL and the commit to revert
$repoUrl = "https://github.com/InternationalColorConsortium/DemoIccMAX.git"
$commitToRevert = "b90ac3933da99179df26351c39d8d9d706ac1cc6"
$workspace = "C:\tmp\"  # Adjust this path as needed

# Step: Ensure the workspace directory exists
if (-Not (Test-Path -Path $workspace)) {
    New-Item -ItemType Directory -Path $workspace -Force
}

# Step: Clone repository
Write-Output "Cloning repository..."
cd $workspace
Start-Process -FilePath git -ArgumentList "clone $repoUrl" -Wait -NoNewWindow
cd DemoIccMAX

# Step: Configure git user
Write-Output "Configuring Git user..."
Start-Process -FilePath git -ArgumentList 'config user.email "you@example.com"' -Wait -NoNewWindow
Start-Process -FilePath git -ArgumentList 'config user.name "Your Name"' -Wait -NoNewWindow

# Step: Revert the specified commit
Write-Output "Reverting commit..."
Start-Process -FilePath git -ArgumentList "revert $commitToRevert --no-edit" -Wait -NoNewWindow

# Step: Download vswhere
Write-Output "Downloading vswhere..."
$vswherePath = Join-Path $workspace "vswhere.exe"
Invoke-WebRequest -Uri "https://github.com/microsoft/vswhere/releases/download/2.8.4/vswhere.exe" -OutFile $vswherePath
$env:VSWHERE_PATH = $vswherePath

# Step: Setup vcpkg
Write-Output "Setting up vcpkg..."
cd $workspace
Start-Process -FilePath git -ArgumentList "clone https://github.com/microsoft/vcpkg.git" -Wait -NoNewWindow
cd vcpkg
Invoke-WebRequest -Uri "https://github.com/microsoft/vcpkg-tool/releases/download/2024-08-01/vcpkg.exe" -OutFile "./vcpkg.exe"
./vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows libjpeg-turbo:x64-windows libpng:x64-windows zlib:x64-windows pcre2:x64-windows expat:x64-windows
cd ..

# Step: Find MSBuild Path
Write-Output "Finding MSBuild path..."
$msbuildPath = & "$env:VSWHERE_PATH" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe
$env:MSBUILD_PATH = $msbuildPath

# Step: Update platform toolset to v143
Write-Output "Updating platform toolset to v143..."
cd "$workspace\DemoIccMAX"
Get-ChildItem -Recurse -Filter *.vcxproj | ForEach-Object {
    (Get-Content $_.FullName) -replace '<PlatformToolset>v142</PlatformToolset>', '<PlatformToolset>v143</PlatformToolset>' | Set-Content $_.FullName
}

# Step: Copy missing libraries
Write-Output "Copying missing libraries..."
$installedLibDir = Join-Path $workspace "vcpkg\installed\x64-windows\lib"
$packagesDir = Join-Path $workspace "vcpkg\packages"
$libMapping = @{
    "wxjpegd.lib" = "libjpeg-turbo_x64-windows\lib\jpeg.lib"
    "wxpngd.lib" = "libpng_x64-windows\lib\libpng16.lib"
    "wxzlibd.lib" = "zlib_x64-windows\lib\zlib.lib"
    "wxregexd.lib" = "pcre2_x64-windows\lib\pcre2-8.lib"
    "wxexpatd.lib" = "expat_x64-windows\lib\libexpat.lib"
}

function Copy-Library {
    param (
        [string]$linkName,
        [string]$targetPath
    )
    $linkPath = Join-Path $installedLibDir $linkName
    $targetFullPath = Join-Path $packagesDir $targetPath
    if (Test-Path $targetFullPath) {
        Copy-Item -Path $targetFullPath -Destination $linkPath -Force
    }
}

foreach ($lib in $libMapping.GetEnumerator()) {
    Copy-Library -linkName $lib.Key -targetPath $lib.Value
}

# Step: Build IccProfLib
Write-Output "Building IccProfLib..."
$msbuild = $env:MSBUILD_PATH
& $msbuild .\IccProfLib\IccProfLib_v19.vcxproj /p:Configuration=Debug /p:Platform=x64 /m /p:CLToolAdditionalOptions="/fsanitize=address" /p:LinkToolAdditionalOptions="/fsanitize=address"

# Step: Build with MSBuild
Write-Output "Building the solution with MSBuild..."
& $msbuild .\Build\MSVC\BuildAll_v19.sln /p:Configuration=Debug /p:Platform=x64 /m /p:CLToolAdditionalOptions="/fsanitize=address" /p:LinkToolAdditionalOptions="/fsanitize=address"
& $msbuild .\Tools\CmdLine\IccApplyToLink\iccApplyToLink_v16.vcxproj /p:Configuration=Debug /p:Platform=x64 /m /p:CLToolAdditionalOptions="/fsanitize=address" /p:LinkToolAdditionalOptions="/fsanitize=address"
& $msbuild .\Tools\CmdLine\IccFromCube\iccFromCube_v16.vcxproj /p:Configuration=Debug /p:Platform=x64 /m /p:CLToolAdditionalOptions="/fsanitize=address" /p:LinkToolAdditionalOptions="/fsanitize=address"

# Step: Identify and list output files
Write-Output "Identifying and listing output files..."
$outputPackageDir = Join-Path $workspace "DemoIccMAX\Package"
New-Item -ItemType Directory -Path $outputPackageDir -Force
$libFiles = @()
$dllFiles = @()
$exeFiles = @()

function Categorize-Files {
    param (
        [string]$filePath
    )
    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
    switch ($extension) {
        ".lib" { $global:libFiles += $filePath }
        ".dll" { $global:dllFiles += $filePath }
        ".exe" { $global:exeFiles += $filePath }
    }
}

$allFiles = Get-ChildItem -Path "$workspace\DemoIccMAX" -Recurse -File
foreach ($file in $allFiles) {
    Categorize-Files -filePath $file.FullName
}

Write-Output "Library (.lib) files:" | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append
$libFiles | ForEach-Object { $_ | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append }
Write-Output "`nDLL (.dll) files:" | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append
$dllFiles | ForEach-Object { $_ | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append }
Write-Output "`nExecutable (.exe) files:" | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append
$exeFiles | ForEach-Object { $_ | Out-File -FilePath "$outputPackageDir\file_list.txt" -Append }

# Step: Package and zip the files
Write-Output "Packaging and zipping the files..."
$zipFilePath = Join-Path $workspace "DemoIccMAX\ReleasePackage.zip"
New-Item -ItemType Directory -Path "$outputPackageDir\bin" -Force

function Copy-FilesWithDependencies {
    param (
        [string[]]$files,
        [string]$destination
    )

    foreach ($file in $files) {
        $sourceDir = Split-Path $file -Parent
        Copy-Item -Path $file -Destination $destination -Force

        # Copy dependencies if any
        $dependencyFiles = Get-ChildItem -Path $sourceDir -Filter *.dll -Recurse
        foreach ($dep in $dependencyFiles) {
            Copy-Item -Path $dep.FullName -Destination $destination -Force
        }
    }
}

Copy-FilesWithDependencies -files $exeFiles -destination "$outputPackageDir\bin"
Copy-FilesWithDependencies -files $libFiles -destination "$outputPackageDir\bin"
Copy-FilesWithDependencies -files $dllFiles -destination "$outputPackageDir\bin"

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($outputPackageDir, $zipFilePath)

Write-Output "Release package created at $zipFilePath"

@echo off
REM Set environment variables
set LIBXML2_VERSION=2.12.6
set LIBXML2_TARBALL=libxml2-%LIBXML2_VERSION%.tar.xz
set LIBXML2_URL=https://download.gnome.org/sources/libxml2/2.12/%LIBXML2_TARBALL%
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..\..\..
set BUILD_DIR=%PROJECT_ROOT%\Build
set LIBXML2_DIR=%BUILD_DIR%\libxml2-%LIBXML2_VERSION%
set LIBXML2_BUILD_DIR=%BUILD_DIR%\libxml2-%LIBXML2_VERSION%-build
set INSTALL_DIR=%BUILD_DIR%\libxml

REM Ensure the Build directory exists
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Download the tarball if it doesn't exist or is corrupted
if not exist "%BUILD_DIR%\%LIBXML2_TARBALL%" (
    echo Downloading %LIBXML2_TARBALL%...
    curl -o "%BUILD_DIR%\%LIBXML2_TARBALL%" %LIBXML2_URL%
    if %errorlevel% neq 0 (
        echo Error downloading %LIBXML2_TARBALL%. Please check the URL or your internet connection.
        exit /b 1
    )
) else (
    echo %LIBXML2_TARBALL% already downloaded.
)

REM Extract the tarball if the directory doesn't exist
if not exist "%LIBXML2_DIR%" (
    echo Extracting %LIBXML2_TARBALL%...
    cmake -E tar xf "%BUILD_DIR%\%LIBXML2_TARBALL%" -C "%BUILD_DIR%"
    if %errorlevel% neq 0 (
        echo Error extracting %LIBXML2_TARBALL%. The archive may be corrupted.
        exit /b 1
    )
) else (
    echo %LIBXML2_DIR% already extracted.
)

REM Configure and build the library
echo Configuring and building libxml2-%LIBXML2_VERSION%...
cmake -S "%LIBXML2_DIR%" -B "%LIBXML2_BUILD_DIR%" -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -G "NMake Makefiles"
if %errorlevel% neq 0 (
    echo Configuration failed.
    exit /b 1
)
cmake --build "%LIBXML2_BUILD_DIR%"
if %errorlevel% neq 0 (
    echo Build failed.
    exit /b 1
)
cmake --install "%LIBXML2_BUILD_DIR%"
if %errorlevel% neq 0 (
    echo Installation failed.
    exit /b 1
)

REM Report results
if exist "%INSTALL_DIR%\lib\libxml2.a" (
    echo libxml2-%LIBXML2_VERSION% built and installed successfully in %INSTALL_DIR%.
) else (
    echo Failed to build and install libxml2-%LIBXML2_VERSION%.
)

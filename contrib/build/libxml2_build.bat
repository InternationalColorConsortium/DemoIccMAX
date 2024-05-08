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
set XCODE_LIBXML_DIR=%BUILD_DIR%\XCode\libxml
set REQUIRED_HEADERS=c14n.h catalog.h chvalid.h debugXML.h dict.h DOCBparser.h encoding.h entities.h globals.h hash.h HTMLparser.h HTMLtree.h list.h nanoftp.h nanohttp.h parser.h parserInternals.h pattern.h relaxng.h SAX.h SAX2.h schemasInternals.h threads.h tree.h uri.h valid.h xinclude.h xlink.h xmlautomata.h xmlerror.h xmlexports.h xmlIO.h xmlmemory.h xmlmodule.h xmlreader.h xmlregexp.h xmlsave.h xmlschemas.h xmlschemastypes.h xmlstring.h xmlunicode.h xmlversion.h xmlwin32version.h xmlwriter.h xpath.h xpathInternals.h xpointer.h

REM Ensure the Build directories exist
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%XCODE_LIBXML_DIR%" mkdir "%XCODE_LIBXML_DIR%"

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

REM Copy the required header files to the XCode\libxml folder
for %%h in (%REQUIRED_HEADERS%) do (
    if exist "%INSTALL_DIR%\include\libxml2\libxml\%%h" (
        copy "%INSTALL_DIR%\include\libxml2\libxml\%%h" "%XCODE_LIBXML_DIR%\" /Y
        echo Copied %%h to %XCODE_LIBXML_DIR%.
    ) else (
        echo Missing header: %%h
    )
)

REM Report results
if exist "%INSTALL_DIR%\lib\libxml2.a" (
    echo libxml2-%LIBXML2_VERSION% built and installed successfully in %INSTALL_DIR%.
) else (
    echo Failed to build and install libxml2-%LIBXML2_VERSION%.
)

@echo off
REM Directories
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..\..\..
set BUILD_DIR=%PROJECT_ROOT%\Build
set ICC_PROF_LIB_DIR=%BUILD_DIR%\IccProfLib
set ICC_XML_DIR=%BUILD_DIR%\IccXML
set XCODE_LIB_DIR=%BUILD_DIR%\XCode\lib

REM Ensure the XCode\lib directory exists
if not exist "%XCODE_LIB_DIR%" mkdir "%XCODE_LIB_DIR%"

REM Required files
set DESIRED_CONTENTS=DesiredContentsAfterBuild.txt libIccProfLib.a libIccXML.a

REM Create the DesiredContentsAfterBuild.txt
(
    echo The desired files in this folder after a successful build are as follows:
    echo.
    echo DesiredContentsAfterBuild.txt - this file
    echo libIccProfLib.a - IccProfLib library
    echo libIccXML.a - IccXML library
) > "%XCODE_LIB_DIR%\DesiredContentsAfterBuild.txt"

REM Copy files to the XCode\lib directory
copy "%ICC_PROF_LIB_DIR%\libIccProfLib2-static.a" "%XCODE_LIB_DIR%\libIccProfLib.a" /Y
copy "%ICC_XML_DIR%\libIccXML2-static.a" "%XCODE_LIB_DIR%\libIccXML.a" /Y

REM Verify the files
for %%h in (%DESIRED_CONTENTS%) do (
    if exist "%XCODE_LIB_DIR%\%%h" (
        echo Copied %%h to %XCODE_LIB_DIR%.
    ) else (
        echo Missing file: %%h
    )
)

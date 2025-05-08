@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: ---- CONFIG ----
set "PORT=8183"
set "ENDPOINT=http://localhost:%PORT%/icctoxml"
set "BINARY=iccToXml_http_service.exe"

:: ---- PARSE ARG ----
set "MODE=default"
if not "%~1"=="" set "MODE=%~1"

echo.
if /I "!MODE!"=="--fuzz-stdin" (
    goto :run_cli
) else (
    goto :run_http
)

:: ---- RUN CLI MODE ----
:run_cli
echo [*] Running in CLI (fuzz) mode...
if not exist "%BINARY%" (
    echo [!] ERROR: %BINARY% not found in current directory.
    goto :fail
)
"%BINARY%" --fuzz-stdin
goto :end

:: ---- RUN HTTP MODE ----
:run_http
echo [*] Starting ICC XML HTTP Service on: %ENDPOINT%
if not exist "%BINARY%" (
    echo [!] ERROR: %BINARY% not found in current directory.
    goto :fail
)
"%BINARY%"
goto :end

:: ---- FAIL EXIT ----
:fail
echo.
echo [!] Press [Enter] to exit.
pause >nul
endlocal
exit /b 1

:end
endlocal
exit /b 0

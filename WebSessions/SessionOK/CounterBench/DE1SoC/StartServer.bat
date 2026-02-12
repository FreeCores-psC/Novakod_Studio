@echo off
REM === FPGA Web Server Launcher ===
title FPGA Demo Web Server
echo Starting local web server on http://localhost:8000/
echo Serving files from: %~dp0
echo.
cd /d "%~dp0"

REM Start Python HTTP server
python -m http.server 8000

echo.
echo Server stopped.
pause



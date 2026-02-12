@echo off

rem -------------------------------------
rem Save current directory
set CURRENTDIR=%~dp0

rem -------------------------------------
echo Compiling for simulation
cd /d %CURRENTDIR%
call compile

rem -------------------------------------
echo Running simulation
start /WAIT execute 2000 0 0 0

rem -------------------------------------
setlocal ENABLEDELAYEDEXPANSION

rem Timestamp for unique VCD
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set D=%%d%%b%%c
)
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set T=%%a%%b%%c
)
set T=%T: =0%

set LOCAL_VCD_DIR=C:\Novakod_Studio\WebVcdFiles
set VCD_NAME=Simulation_%D%_%T%.vcd

echo Copying VCD: %VCD_NAME%
copy "%CURRENTDIR%\targets\Simulation.vcd" "%LOCAL_VCD_DIR%\%VCD_NAME%"

cd /d %LOCAL_VCD_DIR%

rem -------------------------------------
echo Updating Git repository
rem git pull --rebase origin main         

rem git add "%VCD_NAME%"
git add -A
git commit -m "Add %VCD_NAME%"
git push origin main

rem -------------------------------------
echo Opening waveform in browser
start "" "https://vc.drom.io/?github=FreeCores-psC/vcdFiles/main/%VCD_NAME%"

cd /d %CURRENTDIR%
endlocal

echo off    

rem -- Test parameters
if "%1"=="" goto MissingParam
set Step=%1
if "%2"=="" goto MissingParam
set ConsolePort=%2
if "%3"=="" goto MissingParam
set BoardPort=%3
if "%4"=="" goto MissingParam
set DebugPort=%4

set prjDir=%~dp0
rem   -- File path set to current directory
set brdFile=%prjDir%!!gen!!.brd

set binPath=C:\Novakod_Studio\bin\
set rvm=%binPath%rvm.exe
set GenEnvFile=%binPath%WebGenEnvFile.exe
set GenVcdFile=%binPath%GenVcdFile.exe

rem -- Generate environment file
start /WAIT /MIN %GenEnvFile% %prjDir% Wave Simulation %ConsolePort% %BoardPort% %DebugPort%

echo Start RVM
echo =========

start /WAIT /MIN /D %binPath% %rvm% %brdFile% -MODE SIMULATION -FREQUENCY 50MHZ -MAXSTEP %Step% -NOCONSOLE

rem -- Generate .vcd file
start /WAIT /MIN /D %binPath% %GenVcdFile% -prj %prjDir% -trg Simulation -step 0.02usec

goto done

:MissingParam  
echo Execute.bat missing parameters: Step ConsolePort BoardPort DebugPort

:done
exit


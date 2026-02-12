echo off    

rem -- Test parameters
if "%1"=="" goto MissingParam
set SessionID=%1
if "%2"=="" goto MissingParam
set Step=%2
if "%3"=="" goto MissingParam
set ConsolePort=%3
if "%4"=="" goto MissingParam
set BoardPort=%4
if "%5"=="" goto MissingParam
set DebugPort=%5

set prjDir=%~dp0
rem   -- File path set to current directory
set brdFile=%prjDir%!!gen!!.brd

set binPath=C:\Novakod_Studio\bin\
set rvm=%binPath%rvm.exe
set GenEnvFile=%binPath%WebGenEnvFile.exe
set GenVcdFile=%binPath%GenVcdFile.exe

rem -- Generate environment file
start /WAIT /MIN %GenEnvFile% %prjDir% Wave %SessionID% %ConsolePort% %BoardPort% %DebugPort%

rem -- Copy the .evi and .evo files
copy %prjDir%targets\Simulation.evi  %prjDir%targets\%SessionID%.evi
copy %prjDir%targets\Simulation.evo  %prjDir%targets\%SessionID%.evo

echo Start RVM
echo =========

start /WAIT /MIN /D %binPath% %rvm% %brdFile% -MODE SIMULATION -FREQUENCY 50MHZ -MAXSTEP %Step% -NOCONSOLE

rem -- Generate .vcd file
start /WAIT /MIN /D %binPath% %GenVcdFile% -prj %prjDir% -trg %SessionID% -step 0.02usec

goto done

:MissingParam  
echo Execute.bat missing parameters: TargetName Step ConsolePort BoardPort DebugPort

:done
exit


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
set brdFile=%prjDir%\!!gen!!.brd

set binPath=C:\Novakod_Studio\bin\
set rvm=%binPath%rvm.exe
set GenEnvFile=%binPath%WebGenEnvFile.exe

rem -- Generate environment file
start /WAIT /MIN %GenEnvFile% %prjDir% Console virtualboard %ConsolePort% %BoardPort% %DebugPort%

echo Start RVM
echo =========
start "%SessionID%" /MIN /D %binPath% %rvm% %brdFile% -MODE SIMULATION -FREQUENCY 50MHZ -MAXSTEP %Step% -NOCONSOLE

goto done

:MissingParam  
echo Execute.bat missing parameters: Step ConsolePort BoardPort DebugPort

:done
exit


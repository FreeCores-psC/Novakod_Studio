echo off
rem   -- File path set to current directory
set prjDir=%~dp0
set brdFile=%prjDir%\!!gen!!.brd

set rvmPath=C:\Novakod_Studio\bin\
set rvm=%compPath%rvm.exe

echo Start RVM
echo =========
start /B /D %rvmPath% %rvm% %brdFile% -MODE SIMULATION -FREQUENCY 50MHZ -NOCONSOLE

exit


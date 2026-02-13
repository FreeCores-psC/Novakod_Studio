echo off
set SessionID=%1
set currentdir=%~dp0
set LocalVcdDir=C:\Novakod_Studio\WebVcdFiles\

REM ---------------------------------------
REM Copy vcd file to LocalVcdDir
REM ---------------------------------------
set vcdfile=%LocalVcdDir%%SessionID%.vcd
copy %currentdir%\targets\%SessionID%.vcd  %vcdfile%

REM ---------------------------------------
REM Add, commit and push to github
REM ---------------------------------------
cd /d %LocalVcdDir%
set MSG=Waveform update %SessionID%
git status
git add -A
git commit -m "%MSG%"
git push

REM ---------------------------------------
REM Display waveform on https://vc.drom.io
REM ---------------------------------------
start https://vc.drom.io/?github=FreeCores-psC/vcdFiles/main/%SessionID%.vcd

rem cleanup to prevent accumulation of files
rem del  %currentdir%\targets\%SessionID%.*
rem del  %vcdfile%

exit

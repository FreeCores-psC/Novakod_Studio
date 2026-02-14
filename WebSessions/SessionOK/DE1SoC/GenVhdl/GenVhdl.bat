rem This batch compiles the .psC file
rem   -- File path set to current directory
set prjDir=%~dp0

rem First clear previous data
del !!gen!!.unp.psC
del !!gen!!.log
del !!gen!!.sym
del !!gen!!.env
del /Q vhdl\*.*
del /Q AMD\*.*
del /Q Intel\*.*

set binPath=C:\Novakod_Studio\bin\
set compiler=%binPath%pscc.exe

echo ...Calling compiler: %compiler% %prjDir%

cd %prjDir%\
start /B /WAIT /D %prjDir%\ %compiler% %prjDir%!!gen!!.psC !!gen!!.sym !!gen!!.env -log !!gen!!.log -VHDL 20 -web

exit     

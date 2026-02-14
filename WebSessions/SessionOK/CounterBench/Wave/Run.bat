echo off
rem    -- Save current directory
set currentdir=%~dp0

echo -------------------------------------
echo Compiling for simulation:   %%~nxf
echo -------------------------------------
cd %currentdir%      
call compile   

rem ============================================================================
rem this code is only to simulate random SessionID
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem This is used to specify the required length of the random string
set len=12

:: This specifies the characters that will be used to generate the random string
set charpool=0123456789ABCDEF 

rem This specifies the length of the character pool above used to generate the string
set len_charpool=16

set SessionID=

rem Loop %len% times
for /L %%b IN (1, 1, %len%) do (

rem %RANDOM% / !RANDOM! is replaced with a random variable between 0 and 32768

rem This is used as our source of randomness so we use some simple math to 

rem restrict the random range to be within the length of len_charpool
  set /A rnd_index=!RANDOM! * %len_charpool% / 32768

rem Use for to allow us to expand and use the variable with batch's substring

rem functionality, and append the substring at the random index determined above

rem to the SessionID variable. See set /? for more information.
  for /F %%i in ('echo %%charpool:~!rnd_index!^,1%%') do set SessionID=!SessionID!%%i
)
rem ============================================================================

echo -------------------------------------
echo Execution in simulation:    %%~nxf
echo -------------------------------------
cd %currentdir%   
start /WAIT execute %SessionID% 2000 0 0 0


echo -------------------------------------
echo Displaying waveform:    %%~nxf
echo Parameter is SessionID
echo -------------------------------------
cd %currentdir%      
rem call DisplayWaveform.bat %SessionID%

exit                  
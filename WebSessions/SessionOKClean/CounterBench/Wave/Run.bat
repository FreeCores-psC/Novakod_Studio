echo off
rem    -- Save current directory
set currentdir=%~dp0

echo -------------------------------------
echo Compiling for simulation:   %%~nxf
echo -------------------------------------
cd %currentdir%      
call compile   

echo -------------------------------------
echo Execution in simulation:    %%~nxf
echo -------------------------------------
cd %currentdir%   
start /WAIT execute Simulation 2000 0 0 0


echo -------------------------------------
echo Displaying waveform:    %%~nxf
echo Parameter is SessionID
echo -------------------------------------

exit
               
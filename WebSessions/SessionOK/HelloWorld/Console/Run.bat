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
start execute SessionID 50000000 9001 0 0

start index.html

  

                         


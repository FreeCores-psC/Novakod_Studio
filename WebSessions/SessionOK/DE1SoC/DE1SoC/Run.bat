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
start execute

start StartServer.bat

start StartClient.bat
  
exit
                         


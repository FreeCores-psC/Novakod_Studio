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
start execute SessionID 50000000 0 9001 0

start C:\Novakod_Studio\WebViewer\DE1SoC\StartServer.bat

start C:\Novakod_Studio\WebViewer\DE1SoC\StartClient.bat
  
exit
                         

echo off
rem    -- Save current directory
set currentdir=%~dp0

echo -------------------------------------
echo Compiling for simulation
echo -------------------------------------
cd %currentdir%      
call compile   

echo -------------------------------------
echo Execution in simulation
echo -------------------------------------
cd %currentdir%   
start /WAIT execute Simulation 2000 0 0 0


echo -------------------------------------
echo Displaying waveform
echo    Open "Simulation.vcd" in Surfer page
echo -------------------------------------

cd C:\Novakod_Studio\WebViewer\Surfer\vcd
start C:\Novakod_Studio\WebViewer\Surfer\StartServer.bat
start C:\Novakod_Studio\WebViewer\Surfer\StartClient.bat

pause

exit
                  
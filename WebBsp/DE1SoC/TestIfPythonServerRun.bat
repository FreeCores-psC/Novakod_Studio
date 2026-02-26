netstat -aon | findstr :8000
netstat -aon | findstr :9001
echo off
echo =====================================
echo If you see sistening kill the process
echo "taskkill /PID <PID> /F"

pause

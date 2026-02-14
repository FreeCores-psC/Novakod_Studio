echo off
quartus_pgm --mode=JTAG  "%project_vhdl_path%/top_main.cdf"

echo ===============================
IF %errorlevel% == 0 (
  echo Success programming DE1SoC FPGA
) else (
  echo FAILED to rogram DE1SoC FPGA
  )
echo ===============================

TIMEOUT /T 3


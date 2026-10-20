echo off
rem Create ProjectDir\vhdl\lib
if not exist "%project_vhdl_path%"      mkdir "%project_vhdl_path%"
if not exist "%project_vhdl_path%\lib\" mkdir "%project_vhdl_path%\lib\
if not exist "%project_path%\mif\"      mkdir "%project_path%\mif\

rem Copy Novakod std library                                                    
xcopy /y "%std_lib_path%\*.vhd"       "%project_vhdl_path%\lib\"
xcopy /y "%std_lib_path%\mif\*.mif"   "%project_path%\mif\"

rem Copy board library                                                     
xcopy /e /y "%config_lib_path%\*.*" "%project_vhdl_path%\lib\"
xcopy /e /y "%config_lib_path%\*.*" "%project_vhdl_path%\lib\"

rem Copy Quartus Project File                                                     
xcopy /e /y "%config_lib_path%\*.qpf" "%project_vhdl_path%\"
                        
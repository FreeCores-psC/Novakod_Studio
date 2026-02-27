rem CopyFile.bat is called here for normal compilation
rem For web compilation it is calles in GenVhdl.bat
call %project_vhdl_path%\CopyFile.bat

cd /D "%project_vhdl_path%"

rem Start synthesis
quartus_map -f "%project_vhdl_path%/option_map"       
   
pause                       
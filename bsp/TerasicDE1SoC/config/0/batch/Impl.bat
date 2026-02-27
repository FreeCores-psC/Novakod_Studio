cd "%project_vhdl_path%"

quartus_fit -f "%project_vhdl_path%/option_fit"
quartus_asm -f "%project_vhdl_path%/option_fit2"
quartus_sta -f "%project_vhdl_path%/option_fit2"

rem copy "%work_vhdl_path%/*.rpt"         "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/*.summary"     "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/top_main.sof"  "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/top_main.cdf"  "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/top_main.pin"  "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/top_main.sdc"  "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/top_main.qsf"  "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/*.qpf"         "%project_vhdl_path%/"
rem copy "%work_vhdl_path%/prog.bat"      "%project_vhdl_path%/"
rem xcopy /I /S /Y "%work_vhdl_path%/MemPLL/*.*" "%project_vhdl_path%/"

prog.bat
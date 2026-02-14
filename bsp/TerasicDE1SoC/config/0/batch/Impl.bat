cd "%work_vhdl_path%"

quartus_fit -f "%work_vhdl_path%/option_fit"
quartus_asm -f "%work_vhdl_path%/option_fit2"
quartus_sta -f "%work_vhdl_path%/option_fit2"

copy "%work_vhdl_path%/*.rpt"         "%project_vhdl_path%/"
copy "%work_vhdl_path%/*.summary"     "%project_vhdl_path%/"
copy "%work_vhdl_path%/top_main.sof"  "%project_vhdl_path%/"
copy "%work_vhdl_path%/top_main.cdf"  "%project_vhdl_path%/"
copy "%work_vhdl_path%/top_main.pin"  "%project_vhdl_path%/"
copy "%work_vhdl_path%/top_main.sdc"  "%project_vhdl_path%/"
copy "%work_vhdl_path%/top_main.qsf"  "%project_vhdl_path%/"
copy "%work_vhdl_path%/*.qpf"         "%project_vhdl_path%/"
copy "%work_vhdl_path%/prog.bat"      "%project_vhdl_path%/"
xcopy /I /S /Y "%work_vhdl_path%/MemPLL/*.*" "%project_vhdl_path%/"

prog.bat
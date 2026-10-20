cd "%project_vhdl_path%"

quartus_fit -f "%project_vhdl_path%/option_fit"
quartus_asm -f "%project_vhdl_path%/option_fit2"
quartus_sta -f "%project_vhdl_path%/option_fit2"
quartus_sh -t generate_report.tcl

prog.bat
Content of the directory
========================
Board and driver configuration files for simulation
---------------------------------------------------

batch   --> Batch files to call quartus synthesis tools
            need %...% substitution,
            copy to "psCprojectFile"\vhdl
           
lib     --> Board configuration specific library files
            no need for substitution,
            copy to "psCprojectFile"\vhdl
                     
vhdl    --> top_main.vhd
            copy to "psCprojectFile"\vhdl

vhdlCpy --> Quartus project files, no need for substitution,
            copy to "psCprojectFile"\vhdl

vhdlRpl --> Quartus project files, need %...% substitution,
            copy to "psCprojectFile"\vhdl

           
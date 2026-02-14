Content of the directory
========================
Board and driver configuration files for simulation
---------------------------------------------------

batch   --> Batch files to call quartus synthesis tools
            need %...% substitution,
            copy to C:\Novakod_Studio\Temp
           
lib     --> Board configuration specific library files
            no need for substitution,
            copy to C:\Novakod_Studio\Temp\vhdl
                     
vhdl    --> top_main.vhd
            copy to C:\Novakod_Studio\Temp\vhdl

vhdlCpy --> Quartus project files, no need for substitution,
            copy to C:\Novakod_Studio\Temp\vhdl

vhdlRpl --> Quartus project files, need %...% substitution,
            copy to C:\Novakod_Studio\Temp\vhdl

           
// ====================================
// Hello World Processor
// ====================================
// Device used for performances:
//     	
// FPGA speed:		
//     fMax  	
// FPGA resources:		
//     Combinational ALUT        
//     Dedicated logic registers  
//     Total block memory bits   
// ====================================
library StdioLib
{
    // These ports must be declared 
    //       in the component calling puts()
    extern in  active ubyte iWebConsole;
	extern out active ubyte oWebConsole;
    
    // ====================================
    // C++ like puts() - put string
    //=====================================
    function puts(ubyte& str)
        // Local variable declaration
        uint:5 i
    {
        i = (uint:5)0;
        while(str[i] != 0)   
        {          
            oWebConsole := str[i];
            i++;
        };
        return;
    }   
};

// ====================================
// Schematic component: main
// ====================================
component main(
    in ubyte  iWebConsole,
	out ubyte oWebConsole)
{
    // ====================================
    // CConsole component
    // ====================================
    component CConsole(
        in  active ubyte iWebConsole,
        out active ubyte oWebConsole
    )
    {   
        // const, types, variables...
        
        //=====================================
        //    ARDUINO setup() function
        //=====================================
        setup()
        { 
            return;
        }
         
        //=====================================
        //    ARDUINO loop() function
        //=====================================
        loop()
        {
            while(!istrig(iWebConsole)){};
            oWebConsole := iWebConsole;
        }
    };

    // ====================================
    // Processes and signals
    // ====================================
    main::CConsole  PConsole;

    ubyte signal0 = {iWebConsole, PConsole.iWebConsole};
    ubyte signal1 = {PConsole.oWebConsole, oWebConsole};
};

// ====================================
// Hello World Processor
// ====================================
// Device used for performances:
//     Cyclone V  5CSEMA5F31C6	
// FPGA speed:		
//     fMax  314 Mhz	
// FPGA resources:		
//     Combinational ALUT          52 / 85,000     < 1 %
//     Dedicated logic registers   23 / 64,140     < 1 %
//     Total block memory bits    176 / 4,065,280  < 1 %
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

component main(
    in  ubyte iWebConsole,
    out ubyte oWebConsole)
{
    // ====================================
    // CHello component
    // ====================================
    component CHello(
        in  active ubyte iWebConsole,
    	out active ubyte oWebConsole)
    {
        // Constant string declaration
        const string cHelloWorld = "Hello Novakod World!\n";
        uint:5 i;
    
        // Working memory, simulates CPU memory        
        ubyte memory 
        {
            sHelloWorld[22]
        };
        
        //=====================================
        //    ARDUINO setup() function
        //=====================================
        setup()
        { 
            // Need to copy constant string to memory
            i = (uint:5)0; 
            while(cHelloWorld[i] != 0 )
            {
                sHelloWorld[i] = cHelloWorld[i];  
                i++;  
            }
            return;
        }
         
        //=====================================
        //    ARDUINO loop() function
        //=====================================
        loop()
        {
            // Wait for a char to start
            while(!istrig(iWebConsole)) {};
           
            // Call puts() as in C++
            call puts(sHelloWorld); 
           
            // As for Arduino, loops forever
            // Type another character to repeat
        }    
    };

    // ====================================
    // Processes and signals
    // ====================================
    main::CHello  PHello;

    ubyte sConsoleIn  = {PHello.iWebConsole, iWebConsole};
    ubyte sConsoleOut = {PHello.oWebConsole, oWebConsole};
};

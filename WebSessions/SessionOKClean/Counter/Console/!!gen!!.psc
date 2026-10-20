
// ===========================================================
//{!CIRCUIT_PATH=main }
// ===========================================================
component main(in ubyte iWebConsole,
				out ubyte oWebConsole)
{
    
    
    // ===========================================================
    //{!CIRCUIT_PATH=main.CCounter }
    // ===========================================================
    component CCounter (in  active ubyte iWebConsole    /*$ Default */,
    				    out active ubyte oWebConsole    /*$ Default */)
    {
        start()
        {
            oWebConsole := '0'ub;
        }
    
        ControlCounter(0) on iWebConsole
        {
            oWebConsole := switch(iWebConsole)
            {
                // The counter counts from '0'  
                //     the character number is displayed on the console
                case 1: case '1': case 'r': case 'R': '0'ub;
                case 2: case '2': case 'u': case 'U': (oWebConsole == '9')?('0'ub):(oWebConsole + 1ub);
                case 3: case '3': case 'd': case 'D': (oWebConsole == '0')?('9'ub):(oWebConsole - 1ub);;
            };
        }
    };



  // ===========================================================
  //{!CIRCUIT_PATH=main }
  // ===========================================================
    main::CCounter  PCounter;

    ubyte signal0 = {iWebConsole, PCounter.iWebConsole};
    ubyte signal1 = {PCounter.oWebConsole, oWebConsole};
};

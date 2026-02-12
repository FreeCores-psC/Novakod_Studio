
// ===========================================================
//{!CIRCUIT_PATH=MainLib }
// ===========================================================
library MainLib
{
    enum CounterCmd_t { cReset, cUp, cDown, cLoad};

    component CCounter( 
      in  active  CounterCmd_t iCmd,
      in  passive ubyte iLoadVal,
      out active  ubyte oValue)
    {
      setup()
      {
          oValue = 0ub;
          return;
      }

      loop()
      {
          while(!istrig(iCmd)) {};
          switch(iCmd)
          {
              case cReset: 
                  oValue := 0ub;
                  break;
              case cUp:    
                  oValue := oValue + 1ub;
                  break;
              case cDown:  
                  oValue := oValue - 1ub;
                  break;
              case cLoad : 
                  oValue := iLoadVal;
          }
      }
    };
};



// ===========================================================
//{!CIRCUIT_PATH=main }
// ===========================================================
component main(out ubyte oValue,
				out uint:2 iCmd,
				out ubyte iLoadVal)
{
    
    
    // ===========================================================
    //{!CIRCUIT_PATH=main.TestBench }
    // ===========================================================
    component TestBench 
        ( out active  CounterCmd_t oCmd,
          out passive ubyte oLoadVal
        )
    { 
        // Define each test signals
        const identifier TestCmd[] = 
            { cUp, cUp, cUp, cUp, cUp, cUp, cUp, 
              cDown, cDown, cDown, 
              cLoad,
              cUp, cUp, cUp, cUp, cUp, cUp, cUp, 
              cReset, cUp, cUp, cUp
            }; 
    
        const int LoadVal[] = 
            { 0, 0, 0, 0, 0, 0, 0, 
              0, 0, 0, 
              20,
              0, 0, 0, 0, 0, 0, 0, 
              0, 0, 0, 0
            }; 
    
            int i;
        function Wait10()
        {
            i = 0;
            while(i++ < 6) {};
            return;
        }
    
        loop()
        {
            foreach C in <TestCmd> L in <LoadVal>
                call Wait10();
                oLoadVal = ubyte(L); 
                oCmd    := CounterCmd_t(C);
            end
    
    // Or else use { } to execute both instruction 
    //           simultaneously in the same  step.
    /* 
            foreach C in <TestCmd> L in <LoadVal>
                call Wait10();
                {
                    oLoadVal = ubyte(L); 
                    oCmd    := CounterCmd_t(C);
                }
            end
    */
            while(true){}; // Just stop
    }
    
    
    
    };



  // ===========================================================
  //{!CIRCUIT_PATH=main }
  // ===========================================================
    main::TestBench  PTestBench;
    MainLib::CCounter  PCounter;

    CounterCmd_t signal0 = {PTestBench.oCmd, PCounter.iCmd, iCmd};
    ubyte signal1 = {PCounter.oValue, oValue};
    ubyte signal2 = {PTestBench.oLoadVal, PCounter.iLoadVal, iLoadVal};
};

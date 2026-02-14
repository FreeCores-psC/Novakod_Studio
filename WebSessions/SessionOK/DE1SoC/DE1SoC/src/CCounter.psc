component CCounter (in  active  uint:4  iCommand      /*$ Default */,
			    	in  passive uint:10 iLoadValue    /*$ Default */,
				out passive ushort oValue    /*$ Default */,
				out passive ushort oLoadValue    /*$ Default */,
			        out passive uint:10 oLeds         /*$ Default */)
{
    enum KeyCmd_t { RESET = 1, INC = 2, DEC = 4, LOAD = 8 };

    start()
    {
       // Test start event
       oLeds = 0x55ub;
    }

    ExecuteCommand(0) on iCommand
    {
        //oLeds++;
        switch(iCommand)
        {
            case RESET: { oLeds = 0ub; };
            case INC:   { oLeds++; };
            case DEC:   { oLeds--; };
            case LOAD:  { oLeds = iLoadValue; };
        }
    }

    always()
    {
        oLoadValue = (ushort)iLoadValue;
        oValue     = (ushort)oLeds;
    }
};
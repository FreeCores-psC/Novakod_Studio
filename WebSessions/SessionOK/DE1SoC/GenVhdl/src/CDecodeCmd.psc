component CDecodeCmd (in  active uint:4 iCommand    /*$ Default */,
				      out active bit    oReset      /*$ Default */,
				      out active bit    oUp         /*$ Default */,
				      out active bit    oDown       /*$ Default */,
				      out active bit    oLoad       /*$ Default */)
{
    DecodeCommand(0) on iCommand
    {
        if(iCommand == 1) { oReset:;};
        if(iCommand == 2) { oUp:;   };
        if(iCommand == 4) { oDown:; };
        if(iCommand == 8) { oLoad:; };
    }
};
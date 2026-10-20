
// ===========================================================
//{!CIRCUIT_PATH=TerasicDE2SoCLib }
// ===========================================================
// ----------------------------------------------------------------------------
//    Teresic DE1SoC library for peripherals:
//        7-segments display, VGA
// ----------------------------------------------------------------------------
// Copyright (c) 2018 by ICI Techno.
// ----------------------------------------------------------------------------
//
// Permission:
//
//    ICI Techno grants permission to use and to modify this code for use in 
//    project with Novakod Studio IDE.
//
// Disclaimer:
//
//    This psC source code is intended as a design reference which illustrates
//    how these types of functions can be implemented. It is the user's 
//    responsability to verify their design for consistency and functionality 
//    through the use of test methods. Novakod provides no warranty regarding
//    the use or functionality of this code.
//
// ----------------------------------------------------------------------------
//   Version 1.0
// ----------------------------------------------------------------------------

library TerasicDE2SoCLib
{
    /*
        7-segment display (one)
        
        Input:
            iValue:  Value to display (from 0 to 15 'F')
            iPoint:  Turn On point
    
        Output:
            oHex:   7-segment connection
    */
    component C1Hex7 (in  passive uint:4 iValue,
                      in  passive bit    iPoint,
                      out passive ubyte  oHex)
    {
        define ubyte tHex = switch(iValue)
                            {
                                case 0:  01000000ub; 
                                case 1:  01111001ub; 
                                case 2:  00100100ub; 
                                case 3:  00110000ub; 
                                case 4:  00011001ub; 
                                case 5:  00010010ub; 
                                case 6:  00000010ub; 
                                case 7:  01111000ub; 
                                case 8:  00000000ub; 
                                case 9:  00010000ub; 
                                case 10: 00001000ub; // A   
                                case 11: 00000011ub; // b
                                case 12: 01000110ub; // C
                                case 13: 00100001ub; // d
                                case 14: 00000110ub; // E
                                case 15: 00001110ub; // F
                            };
        define ubyte tHexPoint = tHex | (((ubyte)(!iPoint)) << 7ub);
        always()
        {
            oHex = tHex;
        }
    };

    /*
        7-segment displays (two)
        
        Input:
            iValue:  Value to display (from 0 to 255 'FF')
            iPoints: Position of point 0: None
                                       1: hex0
                                       2: hex1
    
        Output:
            o7Hex0:  First 7-segment connection
            o7Hex1:  Second 7-segment connection
    */
    component C2Hex7 (in  ubyte  iValue,
                      in  uint:2 iPoints,
                      out ubyte  o7Hex0,
                      out ubyte  o7Hex1)
    {
        component C2SeparateValue(in  passive ubyte  iValue,
                                  in  passive uint:2 iPoints,
                                  out passive uint:4 oHex0,
                                  out passive bit    oPoint0,
                                  out passive uint:4 oHex1,
                                  out passive bit    oPoint1)
        {
            always()
            {
                oHex0 = (uint:4)bits(iValue, 3ub, 0ub);
                oHex1 = (uint:4)bits(iValue, 7ub, 4ub);
                oPoint0 = bit(iPoints, 0ub);
                oPoint1 = bit(iPoints, 1ub);
            }
        };
    
        C2SeparateValue P1;
        C1Hex7 P2;
        C1Hex7 P3;
    
        ubyte  s0 = {iValue, P1.iValue};
        uint:2 s1 = {iPoints, P1.iPoints};
        uint:4 s2 = {P1.oHex0, P2.iValue};
        bit    s3 = {P1.oPoint0, P2.iPoint};
        uint:4 s4 = {P1.oHex1, P3.iValue};
        bit    s5 = {P1.oPoint1, P3.iPoint};
        ubyte  s6 = {P2.oHex, o7Hex0};
        ubyte  s7 = {P3.oHex, o7Hex1};
    };

    /*
        7-segment displays (four)
        
        Input:
            iValue:  Value to display (from 0 to 65535 'FFFF')
            iPoints: Position of point 0: None
                                       1: hex0
                                       2: hex1
                                       4: hex2
                                       8: hex3
    
        Output:
            o7Hex0:  First 7-segment connection
            o7Hex1:  Second 7-segment connection
            o7Hex2:  Third 7-segment connection
            o7Hex3:  Fourth 7-segment connection
    */
    component C4Hex7 (in  ushort iValue,
                      in  uint:4 iPoints,
                      out ubyte  o7Hex0,
                      out ubyte  o7Hex1,
                      out ubyte  o7Hex2,
                      out ubyte  o7Hex3)
    {
        component C4SeparateValue(in  passive ushort iValue,
                                  in  passive uint:4 iPoints,
                                  out passive uint:4 oHex0,
                                  out passive bit    oPoint0,
                                  out passive uint:4 oHex1,
                                  out passive bit    oPoint1,
                                  out passive uint:4 oHex2,
                                  out passive bit    oPoint2,
                                  out passive uint:4 oHex3,
                                  out passive bit    oPoint3)
        {
            always()
            {
                oHex0 = (uint:4)bits(iValue, 3ub, 0ub);
                oHex1 = (uint:4)bits(iValue, 7ub, 4ub);
                oHex2 = (uint:4)bits(iValue, 11ub, 8ub);
                oHex3 = (uint:4)bits(iValue, 15ub, 12ub);
                oPoint0 = bit(iPoints, 0ub);
                oPoint1 = bit(iPoints, 1ub);
                oPoint2 = bit(iPoints, 2ub);
                oPoint3 = bit(iPoints, 3ub);
            }
        };
    
        C4SeparateValue P1;
        C1Hex7 P2;
        C1Hex7 P3;
        C1Hex7 P4;
        C1Hex7 P5;
    
        ushort s0 = {iValue, P1.iValue};
        uint:4 s1 = {iPoints, P1.iPoints};
        uint:4 s2 = {P1.oHex0, P2.iValue};
        bit    s3 = {P1.oPoint0, P2.iPoint};
        uint:4 s4 = {P1.oHex1, P3.iValue};
        bit    s5 = {P1.oPoint1, P3.iPoint};
        uint:4 s6 = {P1.oHex2, P4.iValue};
        bit    s7 = {P1.oPoint2, P4.iPoint};
        uint:4 s8 = {P1.oHex3, P5.iValue};
        bit    s9 = {P1.oPoint3, P5.iPoint};
        ubyte  s10 = {P2.oHex, o7Hex0};
        ubyte  s11 = {P3.oHex, o7Hex1};
        ubyte  s12 = {P4.oHex, o7Hex2};
        ubyte  s13 = {P5.oHex, o7Hex3};
    };

    /*
        7-segment displays (six)
        
        Input:
            iValue:  Value to display (from 0 to 4294967295 'FFFFFFFF')
            iPoints: Position of point 0:  None
                                       1:  hex0
                                       2:  hex1
                                       4:  hex2
                                       8:  hex3
                                       16: hex4
                                       32: hex5
    
        Output:
            o7Hex0:  1st 7-segment connection
            o7Hex1:  2nd 7-segment connection
            o7Hex2:  3rd 7-segment connection
            o7Hex3:  4th 7-segment connection
            o7Hex4:  5th 7-segment connection
            o7Hex5:  6th 7-segment connection
    */
    component C6Hex7 (in  uint:24 iValue,
                      in  uint:6  iPoints,
                      out ubyte   oHex0,
                      out ubyte   oHex1,
                      out ubyte   oHex2,
                      out ubyte   oHex3,
                      out ubyte   oHex4,
                      out ubyte   oHex5)
    {
        component C6SeparateValue(in  passive uint:24 iValue,
                                  in  passive uint:6  iPoints,
                                  out passive uint:4  oHex0,
                                  out passive bit     oPoint0,
                                  out passive uint:4  oHex1,
                                  out passive bit     oPoint1,
                                  out passive uint:4  oHex2,
                                  out passive bit     oPoint2,
                                  out passive uint:4  oHex3,
                                  out passive bit     oPoint3,
                                  out passive uint:4  oHex4,
                                  out passive bit     oPoint4,
                                  out passive uint:4  oHex5,
                                  out passive bit     oPoint5)
        {
            always()
            {
                oHex0 = (uint:4)bits(iValue, 3ub,  0ub);
                oHex1 = (uint:4)bits(iValue, 7ub,  4ub);
                oHex2 = (uint:4)bits(iValue, 11ub, 8ub);
                oHex3 = (uint:4)bits(iValue, 15ub, 12ub);
                oHex4 = (uint:4)bits(iValue, 19ub, 16ub);
                oHex5 = (uint:4)bits(iValue, 23ub, 20ub);
                oPoint0 = bit(iPoints, 0ub);
                oPoint1 = bit(iPoints, 1ub);
                oPoint2 = bit(iPoints, 2ub);
                oPoint3 = bit(iPoints, 3ub);
                oPoint4 = bit(iPoints, 4ub);
                oPoint5 = bit(iPoints, 5ub);
            }
        };
    
        C6SeparateValue P1;
        C1Hex7 P2;
        C1Hex7 P3;
        C1Hex7 P4;
        C1Hex7 P5;
        C1Hex7 P6;
        C1Hex7 P7;
    
        uint:24 s0  = {iValue,   P1.iValue};
        uint:6  s1  = {iPoints,  P1.iPoints};
        uint:4  s2  = {P1.oHex0, P2.iValue};
        bit     s3  = {P1.oPoint0, P2.iPoint};
        uint:4  s4  = {P1.oHex1, P3.iValue};
        bit     s5  = {P1.oPoint1, P3.iPoint};
        uint:4  s6  = {P1.oHex2, P4.iValue};
        bit     s7  = {P1.oPoint2, P4.iPoint};
        uint:4  s8  = {P1.oHex3, P5.iValue};
        bit     s9  = {P1.oPoint3, P5.iPoint};
        uint:4  s10 = {P1.oHex4, P6.iValue};
        bit     s11 = {P1.oPoint4, P6.iPoint};
        uint:4  s12 = {P1.oHex5, P7.iValue};
        bit     s13 = {P1.oPoint5, P7.iPoint};
        ubyte   s14 = {P2.oHex, oHex0};
        ubyte   s15 = {P3.oHex, oHex1};
        ubyte   s16 = {P4.oHex, oHex2};
        ubyte   s17 = {P5.oHex, oHex3};
        ubyte   s18 = {P6.oHex, oHex4};
        ubyte   s19 = {P7.oHex, oHex5};
    };
    
    /*
        640 X 480 VGA driver
        A 800x600 SVGA driver is under construction
        
        The driver outputs the line and column of the next pixel to be 
        displayed with events. On an event, simply give the driver the 
        RGB values to display for this pixel.

        In normal operation, the delay between pixel color request is
        one step.  In that case, the Horizontal Offset is set to 1.
        If your pixel color processing needs more steps, adjust the
        ofset accordingly. For example, if you need 4 steps set  
        offset to 4.

        Template:
            pHorizontalOffset: integer, see above
        
        Input:
            iR:        Red
            iG:        Green
            iB:        Blue
    
        Output:
            oVgaR:     \
            oVgaG:      \
            oVgaB:       \
            oVgaVS:       \ Connect to the corresponding 
            oVgaHS:       /          VGA pins
            oVgaClk:     /
            oVgaBlankN: /   
            oVgaSyncN: /
            oLine:   Next pixel line number
            oColumn: Next pixel column number
    */
    template<int pHorizontalOffset>
    component CVgaDE1SoC( out passive bit    oVgaVS,
                          out passive bit    oVgaHS,
                          out passive bit    oVgaClk,
                          out passive bit    oVgaBlankN,
                          out passive bit    oVgaSyncN,
                          out passive uint:12 oLine   /*$ Left */,
                          out active  uint:12 oColumn /*$ Left */)
    {
        const uint:12 cBeginVisibleH    = (uint:12)0;                                                  // VGA  Mini driver
        const uint:12 cBeginFrontPorchH = (uint:12)(cBeginVisibleH    + g_is_fpga_target * 576 + 64);  // 640   64    
        const uint:12 cBeginHS          = (uint:12)(cBeginFrontPorchH + g_is_fpga_target * 14  + 2);   // 16    2
        const uint:12 cBeginBackPorchH  = (uint:12)(cBeginHS          + g_is_fpga_target * 94  + 2);   // 96    2
        const uint:12 cTotalWidth       = (uint:12)(cBeginBackPorchH  + g_is_fpga_target * 46  + 2);   // 48    2        
    
        const uint:12 cBeginVisibleV    = (uint:12)0;
        const uint:12 cBeginFrontPorchV = (uint:12)(cBeginVisibleV    + g_is_fpga_target * 432 + 48);  // 480   48  
        const uint:12 cBeginVS          = (uint:12)(cBeginFrontPorchV + g_is_fpga_target * 8   + 2);   // 10    2
        const uint:12 cBeginBackPorchV  = (uint:12)(cBeginVS          + 2);                            // 2     2
        const uint:12 cTotalHeight      = (uint:12)(cBeginBackPorchV  + g_is_fpga_target * 31  + 2);   // 33    2

        // Blanking after line offset: offset to 639+offset
        define bit tBlank  = ((oColumn <= (cTotalWidth - 2)) && (oColumn > (cBeginFrontPorchH + pHorizontalOffset))) 
                         || (oLine >= cBeginFrontPorchV);  

        start()
        {
            oVgaVS  = 1t;
            oVgaHS  = 1t;
            oColumn:= (uint:12)0; // Request first pixel
            oLine   = (uint:12)0;
            oVgaBlankN = 0t;
            oVgaSyncN  = 1t;
        }
    
        always()
        {
            oVgaClk = !oVgaClk;
            
            if(oVgaClk) // On the falling clock
            {
                oVgaBlankN = !tBlank;
                oVgaSyncN  = 1t;
        
                if(oColumn < cTotalWidth - 1)
                {
                    oColumn++:;
                }
                else
                {
                    oColumn:= (uint:12)0;

                    if (oLine < cTotalHeight - 1)
                    {
                        oLine++;
                    }
                    else
                    {
                        oLine = (uint:12)0;
                    };
                };
        
                oVgaHS = ((oColumn >= (cBeginHS + pHorizontalOffset - 1)) && (oColumn < (cBeginBackPorchH + pHorizontalOffset - 1))) ? (0t) : (1t);
                oVgaVS = ((oLine   >= cBeginVS) && (oLine   < cBeginBackPorchV)) ? (0t) : (1t);
            }
        }
    };
};



// ===========================================================
//{!CIRCUIT_PATH=main }
// ===========================================================
component main(in uint:4 Keys,
				in uint:10 Switches,
				out uint:10 Leds,
				out ubyte Hex0,
				out ubyte Hex1,
				out ubyte Hex4,
				out ubyte Hex5,
				out ubyte Hex2,
				out ubyte Hex3)
{
    
    
    // ===========================================================
    //{!CIRCUIT_PATH=main.CCounter }
    // ===========================================================
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



  // ===========================================================
  //{!CIRCUIT_PATH=main }
  // ===========================================================
    main::CCounter  PCounter;
    TerasicDE2SoCLib::C4Hex7  PDisplayValue;
    TerasicDE2SoCLib::C4Hex7  PLoadValue;

    uint:4 signal0 = {Keys, PCounter.iCommand};
    uint:10 signal1 = {Switches, PCounter.iLoadValue};
    uint:10 signal2 = {PCounter.oLeds, Leds};
    ushort signal3 = {PCounter.oValue, PDisplayValue.iValue};
    ushort signal4 = {PCounter.oLoadValue, PLoadValue.iValue};
    ubyte signal5 = {PDisplayValue.o7Hex0, Hex0};
    ubyte signal6 = {PDisplayValue.o7Hex1, Hex1};
    ubyte signal7 = {PLoadValue.o7Hex1, Hex4};
    ubyte signal8 = {PLoadValue.o7Hex2, Hex5};
    ubyte signal9 = {PDisplayValue.o7Hex2, Hex2};
    ubyte signal10 = {PLoadValue.o7Hex0, Hex3};
};

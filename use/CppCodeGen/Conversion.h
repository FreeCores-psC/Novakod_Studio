//--------------------------------------------------------------------
// File Conversion.h
//    Functions to manipulate "fix point types" and "bounded types"
//
//-------------------------------------------------------------------------
//  Copyright (c) 2002-2020 Luc Morin   ICI Techno
//        All rights reserved
//-------------------------------------------------------------------------  */


//--------------------------------------------------------------------
// Functions to convert a fixed point number into a double
//
// Param:
//    FixSize - number of bits of fixed point number (8, 16 or 32)
//    val     - the value of the fix point number stored as an integer
// Return:
//    The converted result
//
double FixToDouble  ( int FixSize, int *val );  //  fix8, fix16, fix32
double Fix64ToDouble( __int64 *val );           //  fix64

//--------------------------------------------------------------------
// Functions to convert a double number to a fixed point number  
//
// Param:
//    FixSize - number fo bits of fixed point number (8, 16 or 32)
//    val     - the double value to be converted
// Return:
//    The converted fixed number result, stored into an integer
//
int     DoubleToFix  ( int FixSize, double val );  //  fix8, fix16, fix32
__int64 DoubleToFix64( double val );               //  fix64

//--------------------------------------------------------------------
// Functions to extract and sign extend a bounded integer number 
//     and place the result in an integer
//
// Param:
//    pVal      - pointer to the bounded value to be converted
//    nSize     - size of the bounded value (1 to 64)
//    bUnsigned - sign of the bounded value, true for unsigned
// Return:
//    The converted value, stored into a integer
//
char    Get8BitFromBounded	(void* pVal, int nSize, bool bUnsigned);
short   Get16BitFromBounded	(void* pVal, int nSize, bool bUnsigned);
int     Get32BitFromBounded	(void* pVal, int nSize, bool bUnsigned); 
__int64 Get64BitFromBounded	(void* pVal, int nSize, bool bUnsigned); 

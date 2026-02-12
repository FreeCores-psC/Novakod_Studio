//--------------------------------------------------------------------
// File Conversion.cpp
//    Functions to manipulate "fix point types" and "bounded types"
//
//-------------------------------------------------------------------------
//  Copyright (c) 2002-2020 ICI Techno
//        All rights reserved
//-------------------------------------------------------------------------  */


#pragma warning(disable: 4244)
#include <math.h>

//--------------------------------------------------------------------
static double round(double val)
{
	return floor(val + 0.5);
}

//--------------------------------------------------------------------
double FixToDouble( int FixSize, int *val )
{ 
	switch(FixSize)
	{
		case 8:
			return ((double)*((char*) val)) / 16.0;
		case 16:
			return ((double)*((short*)val)) / 256.0;
		case 32:
			return ((double)*((int*)  val)) / 65536.0;
		default: 
			return 0.0;
	}
}

//--------------------------------------------------------------------
double Fix64ToDouble( __int64 *val )
{ 
	return ((double)*((__int64*)val)) / (double)4294967296;
}

//--------------------------------------------------------------------
int DoubleToFix( int FixSize, double val )
{
	double tmp = 0.0;
	switch(FixSize)
	{
		case 8:
			tmp = val * 16.0;
			tmp = (tmp>=255.0)?(255.0):(tmp);
			break;
		case 16:
			tmp = val * 256.0;
			tmp = (tmp>=65535.0)?(65535.0):(tmp);
			break;
		case 32:
			tmp = val * 65536.0;
			tmp = (tmp>=4294967295.0)?(4294967295.0):(tmp);
			break;
	}
    return (int)round(tmp);
}

//--------------------------------------------------------------------
__int64 DoubleToFix64( double val )
{
	double tmp = 0.0;
	tmp = val * 4294967296.0;
	tmp = (tmp>=18446744073709551615.0)?(18446744073709551615.0):(tmp);
    return (__int64)round(tmp);
}

//--------------------------------------------------------------------
static unsigned __int64 bit_masks64[64] = 
             {0x0000000000000001, 0x0000000000000002, 0x0000000000000004, 0x0000000000000008, 
              0x0000000000000010, 0x0000000000000020, 0x0000000000000040, 0x0000000000000080,
              0x0000000000000100, 0x0000000000000200, 0x0000000000000400, 0x0000000000000800,
              0x0000000000001000, 0x0000000000002000, 0x0000000000004000, 0x0000000000008000,
              0x0000000000010000, 0x0000000000020000, 0x0000000000040000, 0x0000000000080000,
              0x0000000000100000, 0x0000000000200000, 0x0000000000400000, 0x0000000000800000, 
              0x0000000001000000, 0x0000000002000000, 0x0000000004000000, 0x0000000008000000,
              0x0000000010000000, 0x0000000020000000, 0x0000000040000000, 0x0000000080000000,
              0x0000000100000000, 0x0000000200000000, 0x0000000400000000, 0x0000000800000000,
              0x0000001000000000, 0x0000002000000000, 0x0000004000000000, 0x0000008000000000,
              0x0000010000000000, 0x0000020000000000, 0x0000040000000000, 0x0000080000000000,
              0x0000100000000000, 0x0000200000000000, 0x0000400000000000, 0x0000800000000000, 
              0x0001000000000000, 0x0002000000000000, 0x0004000000000000, 0x0008000000000000,
              0x0010000000000000, 0x0020000000000000, 0x0040000000000000, 0x0080000000000000,
              0x0100000000000000, 0x0200000000000000, 0x0400000000000000, 0x0800000000000000,
              0x1000000000000000, 0x2000000000000000, 0x4000000000000000, 0x8000000000000000};

//--------------------------------------------------------------------
static unsigned __int64 bit_masks32[32] = 
             {0x00000001, 0x00000002, 0x00000004, 0x00000008, 
              0x00000010, 0x00000020, 0x00000040, 0x00000080,
              0x00000100, 0x00000200, 0x00000400, 0x00000800,
              0x00001000, 0x00002000, 0x00004000, 0x00008000,
              0x00010000, 0x00020000, 0x00040000, 0x00080000,
              0x00100000, 0x00200000, 0x00400000, 0x00800000, 
              0x01000000, 0x02000000, 0x04000000, 0x08000000,
              0x10000000, 0x20000000, 0x40000000, 0x80000000};

//--------------------------------------------------------------------
static unsigned __int64 bit_masks16[16] =  
               {0x0001, 0x0002, 0x0004, 0x0008, 
                0x0010, 0x0020, 0x0040, 0x0080,
                0x0100, 0x0200, 0x0400, 0x0800,
                0x1000, 0x2000, 0x4000, 0x8000};

//--------------------------------------------------------------------
static unsigned __int64 bit_masks8[8] =  
               {0x01, 0x02, 0x04, 0x08, 
                0x10, 0x20, 0x40, 0x80};


//--------------------------------------------------------------------
static unsigned __int64 length_bit_mask64[65] =
   {
     0x0000000000000000, 0x0000000000000001, 0x0000000000000003, 0x0000000000000007,
     0x000000000000000f, 0x000000000000001f, 0x000000000000003f, 0x000000000000007f,
     0x00000000000000ff, 0x00000000000001ff, 0x00000000000003ff, 0x00000000000007ff,
     0x0000000000000fff, 0x0000000000001fff, 0x0000000000003fff, 0x0000000000007fff,
     0x000000000000ffff, 0x000000000001ffff, 0x000000000003ffff, 0x000000000007ffff,
     0x00000000000fffff, 0x00000000001fffff, 0x00000000003fffff, 0x00000000007fffff,
     0x0000000000ffffff, 0x0000000001ffffff, 0x0000000003ffffff, 0x0000000007ffffff,
     0x000000000fffffff, 0x000000001fffffff, 0x000000003fffffff, 0x000000007fffffff,
     0x00000000ffffffff, 0x00000001ffffffff, 0x00000003ffffffff, 0x00000007ffffffff,
     0x0000000fffffffff, 0x0000001fffffffff, 0x0000003fffffffff, 0x0000007fffffffff,
     0x000000ffffffffff, 0x000001ffffffffff, 0x000003ffffffffff, 0x000007ffffffffff,
     0x00000fffffffffff, 0x00001fffffffffff, 0x00003fffffffffff, 0x00007fffffffffff,
     0x0000ffffffffffff, 0x0001ffffffffffff, 0x0003ffffffffffff, 0x0007ffffffffffff,
     0x000fffffffffffff, 0x001fffffffffffff, 0x003fffffffffffff, 0x007fffffffffffff,
     0x00ffffffffffffff, 0x01ffffffffffffff, 0x03ffffffffffffff, 0x07ffffffffffffff,
     0x0fffffffffffffff, 0x1fffffffffffffff, 0x3fffffffffffffff, 0x7fffffffffffffff,
     0xffffffffffffffff
   };

//--------------------------------------------------------------------
static bool IsBoundedPositive(void* pVal, int size)
{
	if (((*(__int64*)pVal) & bit_masks64[(size - 1)]) != 0)
		return false;
	else
		return true;
}

//--------------------------------------------------------------------
char Get8BitFromBounded	(void* pVal, int nSize, bool bUnsigned) 
{

	// If the bounded is positive or unsigned (i.e. no sign bit)
	if (bUnsigned || IsBoundedPositive(pVal, nSize)) 
	{
		return (char) (*(char*)pVal & length_bit_mask64[nSize]);
	}
	else 
	{
		// It's a negative bounded, we mask to the bounded limits then pad with ones
		// to keep a 2's complement negative representation.
		return (char) (*(char*)pVal & length_bit_mask64[nSize]) | ~length_bit_mask64[nSize];		
	}
}


//--------------------------------------------------------------------
short Get16BitFromBounded	(void* pVal, int nSize, bool bUnsigned) 
{

	// If the bounded is positive or unsigned (i.e. no sign bit)
	if (bUnsigned || IsBoundedPositive(pVal, nSize)) 
	{
		return (short) (*(short*)pVal & length_bit_mask64[nSize]);
	}
	else 
	{
		// It's a negative bounded, we mask to the bounded limits then pad with ones
		// to keep a 2's complement negative representation.
		return (short) (*(short*)pVal & length_bit_mask64[nSize]) | ~length_bit_mask64[nSize];		
	}

}

//--------------------------------------------------------------------
int Get32BitFromBounded	(void* pVal, int nSize, bool bUnsigned) 
{

	// If the bounded is positive or unsigned (i.e. no sign bit)
	if (bUnsigned || IsBoundedPositive(pVal, nSize)) 
	{
		return (int) (*(int*)pVal & length_bit_mask64[nSize]);
	}
	else 
	{
		// It's a negative bounded, we mask to the bounded limits then pad with ones
		// to keep a 2's complement negative representation.
		return (int) (*(int*)pVal & length_bit_mask64[nSize]) | ~length_bit_mask64[nSize];		
	}

}

//--------------------------------------------------------------------
__int64 Get64BitFromBounded	(void* pVal, int nSize, bool bUnsigned) 
{
	
	// If the bounded is positive or unsigned (i.e. no sign bit)
	if (bUnsigned || IsBoundedPositive(pVal, nSize)) 
	{
		return (__int64) (*(__int64*)pVal & length_bit_mask64[nSize]);
	}
	else 
	{
		// It's a negative bounded, we mask to the bounded limits then pad with ones
		// to keep a 2's complement negative representation.
		return (__int64) (*(__int64*)pVal & length_bit_mask64[nSize]) | ~length_bit_mask64[nSize];		
	}
}

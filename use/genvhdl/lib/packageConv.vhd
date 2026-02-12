--	Package File Template
--
--	Purpose: This package defines various conversion functions 

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
--use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

package conversion is
-- Top component Functions
function toTopBv       (arg: signed ) return std_logic_vector;
function toTopBv       (arg: boolean ) return std_logic_vector;
function toTopBv       (arg: unsigned ) return std_logic_vector;

function toTopBool     (arg: std_logic_vector ) return boolean;
function toTopSigned   (arg: std_logic_vector ) return signed;
function toTopUnSigned (arg: std_logic_vector ) return unsigned;

-- Main and sub component Functions

function toSimpleBit ( arg: unsigned ) return std_logic;
function toSimpleBit ( arg: boolean ) return std_logic;

function toBit       (arg: boolean ) return unsigned;
function toBit       (arg: signed ) return unsigned;  
function toBool      (arg: signed ) return boolean; 
function toBool      (arg: unsigned ) return boolean; 
function toBool      (arg: boolean ) return boolean;
function toBool      (arg: std_logic ) return boolean; 

function toSigned  (arg: std_logic ) return signed;
function toSigned  (arg: boolean ) return signed;
function toSigned  (arg: signed ) return signed;
function toSigned  (arg: unsigned ) return signed;

function toSigned  (size : integer; arg: std_logic ) return signed;
function toSigned  (size : integer; arg: boolean ) return signed;
function toSigned  (size : integer; arg: signed ) return signed;
function toSigned  (size : integer; arg: unsigned ) return signed;


function toUnsigned  (arg: std_logic ) return unsigned;
function toUnsigned  (arg: boolean ) return unsigned;
function toUnsigned  (arg: signed ) return unsigned;
function toUnsigned  (arg: unsigned ) return unsigned;

function toUnsigned  (size : integer; arg: std_logic ) return unsigned;
function toUnsigned  (size : integer; arg: boolean ) return unsigned;
function toUnsigned  (size : integer; arg: signed ) return unsigned;
function toUnsigned  (size : integer; arg: unsigned ) return unsigned;

function toInt( arg: unsigned )  return integer;
function toInt( arg: signed ) return integer;
function toInt( arg: boolean ) return integer;

function getB( arg : unsigned; 
               index : unsigned ) return unsigned;

function getBit( arg : unsigned; 
                 index : unsigned ) return unsigned;

function getBit( arg : signed; 
                 index : unsigned ) return unsigned;

function getBs( size : integer;  arg : unsigned; 
                left : unsigned; right : unsigned ) return unsigned;

-- Added to allow cast to fix
function getBs( size : integer;  arg : unsigned; 
                left : unsigned; right : unsigned; typeexp : signed ) return unsigned;

function getBits( size : integer; arg : unsigned; left : unsigned;
                  right : unsigned ) return unsigned;

function getBits( size : integer; arg : signed; left : unsigned;
                  right : unsigned ) return unsigned;

-- Added to allow cast to fix
function getBits( size : integer; arg : signed; left : unsigned;
                  right : unsigned; typeexp : signed ) return signed;

function my_shl( arg : signed; pos : unsigned ) return signed;

function my_shl( arg : unsigned; pos : unsigned ) return unsigned;

function my_shr( arg : signed; pos : unsigned ) return signed;

function my_shr( arg : unsigned; pos : unsigned ) return unsigned;

function mantissa ( arg : unsigned ) return unsigned;
function exponent( arg : unsigned ) return signed;
function sign( arg : unsigned ) return unsigned;

function fct_abs ( arg : signed ) return signed;

function fct_abs ( arg : unsigned ) return unsigned;

-- fix functions
function fix8_to_fix8( arg : signed ) return signed;
function fix8_to_fix16( arg : signed ) return signed;
function fix8_to_fix32( arg : signed ) return signed;
function fix8_to_fix64( arg : signed ) return signed;

function fix16_to_fix8( arg : signed ) return signed;
function fix16_to_fix16( arg : signed ) return signed;
function fix16_to_fix32( arg : signed ) return signed;
function fix16_to_fix64( arg : signed ) return signed;

function fix32_to_fix8( arg : signed ) return signed;
function fix32_to_fix16( arg : signed ) return signed;
function fix32_to_fix32( arg : signed ) return signed;
function fix32_to_fix64( arg : signed ) return signed;

function fix64_to_fix8( arg : signed ) return signed;
function fix64_to_fix16( arg : signed ) return signed;
function fix64_to_fix32( arg : signed ) return signed;
function fix64_to_fix64( arg : signed ) return signed;

function bool_to_fix8( arg : boolean ) return signed;
function bool_to_fix16( arg : boolean ) return signed;
function bool_to_fix32( arg : boolean ) return signed;
function bool_to_fix64( arg : boolean ) return signed;

function int_to_fix8( arg : signed ) return signed;
function int_to_fix16( arg : signed ) return signed;
function int_to_fix32( arg : signed ) return signed;
function int_to_fix64( arg : signed ) return signed;

function uint_to_fix8( arg : unsigned ) return signed;
function uint_to_fix16( arg : unsigned ) return signed;
function uint_to_fix32( arg : unsigned ) return signed;
function uint_to_fix64( arg : unsigned ) return signed;

function fix8_to_int( size : integer; arg : signed ) return signed;
function fix16_to_int( size : integer; arg : signed ) return signed;
function fix32_to_int( size : integer; arg : signed ) return signed;
function fix64_to_int( size : integer; arg : signed ) return signed;

function fix8_to_uint( size : integer; arg : signed ) return unsigned;
function fix16_to_uint( size : integer; arg : signed ) return unsigned;
function fix32_to_uint( size : integer; arg : signed ) return unsigned;
function fix64_to_uint( size : integer; arg : signed ) return unsigned;

function fix8_to_bool( arg : signed ) return boolean;
function fix16_to_bool( arg : signed ) return boolean;
function fix32_to_bool( arg : signed ) return boolean;
function fix64_to_bool( arg : signed ) return boolean;


end package conversion;

package body conversion IS




-- Top component Functions
function toTopBv   (arg: signed ) return std_logic_vector is
	begin  
		return std_logic_vector( arg ); 
  
end toTopBv;



function toTopBv (arg: unsigned ) return std_logic_vector is
	begin  
		return std_logic_vector( arg );  
end toTopBv;


function toTopBv  (arg: boolean ) return std_logic_vector is
	variable result : std_logic_vector( 0 downto 0 ); 
	begin
	
		if( arg ) then
		result(0) := '1';
		else
		result(0) := '0';
		end if;
	
	return result;

end toTopBv;



function toTopSigned (arg: std_logic_vector ) return signed is
	begin
		return signed( arg );
end toTopSigned;



function toTopUnSigned (arg: std_logic_vector ) return unsigned is
	begin
		return unsigned( arg );
end toTopUnSigned;



function toTopBool   (arg: std_logic_vector ) return boolean is
begin
return arg(0) /= '0';

end toTopBool;



-- Main and sub component Functions
function toBool (arg: signed ) return boolean is
	begin
		return toUnsigned( arg ) /= 0;
end toBool; 



function toBool (arg: unsigned ) return boolean is
	begin
		return arg /= 0;
end toBool; 



function toBool (arg: boolean ) return boolean is
	begin
		return arg;
end toBool; 



function toBit (arg: boolean ) return unsigned is

variable retVal : unsigned( 0 downto 0 );

	begin
	
	 if( arg = true )
	  then 
	    retVal( 0 downto 0 ) := b"1";
	  else 
	    retVal( 0 downto 0 ) := b"0";
	 end if;

     return retVal;

end toBit;



function toUnsigned (arg: std_logic ) return unsigned is

	begin
	
	 if( arg = '1' )
	  then return b"1";
	  else return b"0";
	 end if;

end toUnsigned;



function toSigned (arg: std_logic ) return signed is

	begin
	
	 if( arg = '1' )
	  then return b"1";
	  else return b"0";
	 end if;

end toSigned;



function toBit (arg: signed ) return unsigned is
	
	begin
		return unsigned(arg);
end toBit;



function toSigned  (arg: boolean ) return signed is

variable ret : bit_vector( 0 downto 0 );

    begin
      if( arg ) then
       ret( 0 ) := '1';
      else
       ret( 0 ) := '0';
      end if;

return signed( to_stdlogicvector( ret ) );

end toSigned;



function toUnsigned  (arg: boolean ) return unsigned is

variable ret : bit_vector( 0 downto 0 );

    begin
      if( arg ) then
       ret( 0 ) := '1';
      else
       ret( 0 ) := '0';
      end if;

return unsigned( to_stdlogicvector( ret ) );

end toUnsigned;



 function toSigned (arg: signed ) return signed is

	begin
		return signed(arg);
end toSigned;



 function toSigned (arg: unsigned ) return signed is

	begin
		return signed(arg);
end toSigned;



 function toUnsigned (arg: signed ) return unsigned is

	begin
		return unsigned(arg);
end toUnsigned;



 function toUnsigned (arg: unsigned ) return unsigned is

	begin
		return unsigned(arg);

end toUnsigned;



function toInt( arg: unsigned )  return integer is
begin

	return conv_integer( std_logic_vector( arg ) );

end toInt;



function toInt( arg: signed ) return integer is
begin

	return conv_integer( std_logic_vector( arg ) );

end toInt;



function toInt( arg: boolean ) return integer is
begin

	if( arg ) then 
	  return 1;
	else 
	  return 0;
	end if;

end toint;



function getB( arg : unsigned; index : unsigned ) return unsigned is

	variable iindex : integer;
	variable bv : unsigned( 0 downto 0 );

	begin 

	iindex := toInt( index );
	bv(0) := arg(iindex);

	return bv;

end getB; 



function getBit( arg : signed; index : unsigned ) return unsigned is

	begin 

	return getB( toUnsigned(arg), index );

end getBit; 


function getBit( arg : unsigned; index : unsigned ) return unsigned is

	begin 

	return getB( arg, index );

end getBit; 


function getBs( size : integer; arg : unsigned; 
                left : unsigned; right : unsigned ) return unsigned is

	variable result : unsigned( size - 1 downto 0 );
	variable i : integer;

	begin
		    
	for i in 0 to ( size - 1 ) loop
	  if( i <= left - right ) then 
	    result(i) := arg( toInt( right + i ) ); 
       else
	    result(i) := '0';
	  end if;   
	end loop; 


return result;


end getBs; 


function getBs( size : integer; arg : unsigned; 
                left : unsigned; right : unsigned; typeexp : signed ) return unsigned is

	variable result : unsigned( size - 1 downto 0 );
	variable i : integer;

	begin
		    
	for i in 0 to ( size - 1 ) loop
	  if( i <= left - right ) then 
	    result(i) := arg( toInt( right + i ) ); 
       else
	    result(i) := '0';
	  end if;   
	end loop; 

   return result;
end getBs; 

function getBits( size : integer; arg : unsigned;
                  left : unsigned; right : unsigned ) return unsigned is

	begin

	return getBs( size, arg, left, right );

end getBits; 

function getBits( size : integer; arg : signed; left : unsigned; 
                  right : unsigned ) return unsigned is

	begin

	return getBs( size, toUnsigned(arg), left, right );

end getBits; 

function getBits( size : integer; arg : signed; left : unsigned; 
                  right : unsigned; typeexp : signed ) return signed is

	begin

	return toSigned(getBs( size, toUnsigned(arg), left, right, typeexp ));

end getBits; 


function toSigned  (size : integer; arg: std_logic ) return signed is

	variable result : signed( size - 1 downto 0 );   
	variable i : integer;

	begin 
 
     for i in 1 to size - 1 loop 
  	 result( i ) := '0';
     end loop;

     if( arg = '1' ) then 
	 result(0) := '1';
	else
	 result(0) := '0'; 
	end if;

	return result;

end toSigned;

function toSigned  (size : integer; arg: boolean ) return signed	is
	variable result : signed( size - 1 downto 0 );   
	variable i : integer;

	begin 
 
     for i in 1 to size - 1 loop 
  	 result( i ) := '0';
     end loop;

     if( arg ) then 
	 result(0) := '1';
	else
	 result(0) := '0'; 
	end if;

	return result;

end toSigned;


function toSigned  (size : integer; arg: signed ) return signed is

   variable i : integer;
   variable result : signed( size - 1 downto 0 );
   variable valueToPad : signed( 0 downto 0 );
  begin
  
  if( arg( arg'length - 1 ) = '1' ) then
   valueToPad(0) := '1';
  else
   valueToPad(0) := '0';
  end if;

  if( size > arg'length ) then
	   for i in 0 to arg'length - 1 loop 
	    result(i) := arg(i);	  
	   end loop;

	   for i in  arg'length to size - 1 loop 
	    result(i) := valueToPad(0);	  
	   end loop;

  else
	   for i in 0 to size - 1 loop 
	    result(i) := arg(i);	  
	   end loop;
  end if;

  return result;

end toSigned;

function toSigned  (size : integer; arg: unsigned ) return signed is

   variable i : integer;
   variable result : signed( size - 1 downto 0 );
  begin
  
  if( size > arg'length ) then
	   for i in 0 to arg'length - 1 loop 
	    result(i) := arg(i);	  
	   end loop;

	   for i in  arg'length to size - 1 loop 
	    result(i) := '0';	  
	   end loop;

  else
	   for i in 0 to size - 1 loop 
	    result(i) := arg(i);	  
	   end loop;
  end if;

  return result;

end toSigned;



function toUnsigned  (size : integer; arg: std_logic ) return unsigned is

	variable result : unsigned( size - 1 downto 0 );   
	variable i : integer;

	begin 
 
     for i in 1 to size - 1 loop 
  	 result( i ) := '0';
     end loop;

     if( arg = '1' ) then 
	 result(0) := '1';
	else
	 result(0) := '0'; 
	end if;

	return result;

end toUnsigned;


function toUnsigned  (size : integer; arg: boolean ) return unsigned is

	variable result : unsigned( size - 1 downto 0 );   
	variable i : integer;

	begin 
 
     for i in 1 to size - 1  loop 
  	 result( i ) := '0';
     end loop;

     if( arg ) then 
	 result(0) := '1';
	else
	 result(0) := '0'; 
	end if;

	return result;

end toUnsigned;



function toUnsigned  (size : integer; arg: signed ) return unsigned is

   variable i : integer;
   variable result : unsigned( size - 1 downto 0 );
   variable valueToPad : unsigned( 0 downto 0 );
  begin
  
  if( arg( arg'length - 1 ) = '1' ) then
   valueToPad(0) := '1';
  else
   valueToPad(0) := '0';
  end if;

  if( size > arg'length ) then
	   for i in 0 to arg'length - 1 loop 
	    result(i) := arg(i);	  
	   end loop;

	   for i in  arg'length to size - 1 loop 
	    result(i) := valueToPad(0);	  
	   end loop;

  else
	   for i in 0 to size - 1 loop 
	    result(i) := arg(i);	  
	   end loop;
  end if;

  return result;

end toUnsigned;


function toUnsigned  (size : integer; arg: unsigned ) return unsigned is

   variable i : integer;
   variable result : unsigned( size - 1 downto 0 );
  begin
  
  if( size > arg'length ) then
	   for i in 0 to arg'length - 1 loop 
	    result(i) := arg(i);	  
	   end loop;

	   for i in  arg'length to size - 1 loop 
	    result(i) := '0';	  
	   end loop;

  else
	   for i in 0 to size - 1 loop 
	    result(i) := arg(i);	  
	   end loop;
  end if;

  return result;

end toUnsigned;



function my_shl( arg : signed; pos : unsigned ) return signed is

  begin 
   return arg sll toInt( pos );

end my_shl;

function my_shl( arg : unsigned; pos : unsigned ) return unsigned is

  begin 
   return arg sll toInt( pos );

end my_shl;


function my_shr( arg : unsigned; pos : unsigned ) return unsigned is

  begin 
   return arg srl toInt( pos );

end my_shr;

function my_shr( arg : signed; pos : unsigned ) return signed is

  variable retVal : signed( arg'length -1 downto 0 );
  variable size : integer; 

  begin
 
    size := arg'length -1;

   if( arg( size ) = '1' ) then
    for i in 0 to size loop
     if( i > size - toInt( pos ) ) then
      retVal(i) := '1';
     else
	 retVal(i) := arg( toInt( pos ) + i );
     end if;
    end loop;

   else
     retVal := arg srl toInt( pos );
   end if;

   return retVal;

end my_shr;


function mantissa ( arg : unsigned ) return unsigned is

variable intexp : unsigned( 31 downto 0 );
variable longexp : unsigned( 63 downto 0 );

begin

if( arg'length = 32 ) then
 intexp( 22 downto 0 ) := arg( 22 downto 0 );
 intexp( 31 downto 23 ) := b"000000000";
 return intexp;
else
 longexp( 51 downto 0 ) := arg( 51 downto 0 );
 longexp( 63 downto 52 ) := x"000";
 return longexp;
end if;

end mantissa;


function exponent( arg : unsigned ) return signed is

variable retval : unsigned( 31 downto 0 );

begin

if( arg'length = 32 ) then
 retval ( 7 downto 0 ) := arg( 30 downto 23 );
 retval ( 31 downto 8 ) := x"000000";
else
 retval ( 10 downto 0 ) := arg( 62 downto 52 );
 retval ( 11 downto 11 ) := b"0";
 retval ( 31 downto 12 ) := x"00000";
end if;

return toSigned( 32, retval );

end exponent;


function sign( arg : unsigned ) return unsigned is

variable retval : unsigned( 0 downto 0 );

begin

if( arg'length = 32 ) then
  retval( 0 downto 0 ) := arg( 31 downto 31 );
else
  retval( 0 downto 0 ) := arg( 63 downto 63 );
end if;

return retval;

end sign;


function fct_abs ( arg : signed ) return signed is 

begin

return abs( arg );

end fct_abs;


function fct_abs ( arg : unsigned ) return unsigned is

variable retVal : unsigned( arg'length -1 downto 0 );

begin

retVal( arg'length - 2 downto 0 ) := arg( arg'length - 2 downto 0 );
retVal( arg'length -1 downto arg'length -1 ) := b"0"; 

return retVal;

end fct_abs;


function toSimpleBit ( arg: unsigned ) return std_logic is

  begin
   if( arg( 0 downto 0 ) = b"1" ) then 
    return '1';
   else
    return '0';   
   end if;

end toSimpleBit;


function toSimpleBit ( arg: boolean ) return std_logic is

  begin
   if( arg ) then 
    return '1';
   else
    return '0';   
   end if;

end toSimpleBit;

function toBool (arg: std_logic ) return boolean is 
  
  begin
   return arg /= '0';

end toBool;


function fix8_to_fix8( arg : signed ) return signed  is

begin
  return arg;

end fix8_to_fix8;

function fix8_to_fix16( arg : signed ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"04";

begin
  retVal := toSigned( 16, arg );
  return my_shl( retVal , pos );

end fix8_to_fix16;


function fix8_to_fix32( arg : signed ) return signed is

variable retVal : signed( 31 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"0c";

begin
  retVal := toSigned( 32, arg );
  return my_shl( retVal, pos );

end fix8_to_fix32;


function fix8_to_fix64( arg : signed ) return signed is

variable retVal : signed( 63 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"1c";

begin
 retVal := toSigned( 64, arg );
 return my_shl( retVal , pos );

end fix8_to_fix64;


function fix16_to_fix8( arg : signed ) return signed is

variable retVal : signed( 7 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"04";

begin
 return toSigned( 8, my_shr( arg, pos ) );

end fix16_to_fix8;


function fix16_to_fix16( arg : signed ) return signed is

begin
 return arg;

end fix16_to_fix16;



function fix16_to_fix32( arg : signed ) return signed is

variable retVal : signed( 31 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"08";

begin
 retVal := toSigned( 32, arg );
 return my_shl( retVal, pos );


end fix16_to_fix32;



function fix16_to_fix64( arg : signed ) return signed is

variable retVal : signed( 63 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"18";

begin
  retVal := toSigned( 64, arg );
  return my_shl( retVal, pos );

end fix16_to_fix64;



function fix32_to_fix8( arg : signed ) return signed is

variable retVal : signed( 7 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"0c";

begin
 return toSigned( 8, my_shr( arg, pos ) );

end fix32_to_fix8;


function fix32_to_fix16( arg : signed ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"08";

begin
  return toSigned( 16, my_shr( arg, pos ) );

end fix32_to_fix16;


function fix32_to_fix32( arg : signed ) return signed is

begin
 return arg;

end fix32_to_fix32;


function fix32_to_fix64( arg : signed ) return signed is

variable retVal : signed( 63 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"10";

begin
  retVal := toSigned( 64, arg );
  return my_shl( retVal, pos );

end fix32_to_fix64;


function fix64_to_fix8( arg : signed ) return signed is

variable retVal : signed( 7 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"1c";

begin
  return toSigned( 8, my_shr( arg, pos ) );


end fix64_to_fix8;
 
function fix64_to_fix16( arg : signed ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"18";

begin
  return toSigned( 16, my_shr( arg, pos ) );

end fix64_to_fix16;


function fix64_to_fix32( arg : signed ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"10";

begin
  return toSigned( 32, my_shr( arg, pos ) );

end fix64_to_fix32;


function fix64_to_fix64( arg : signed ) return signed is

begin
 return arg;

end fix64_to_fix64;

function int_to_fix8( arg : signed ) return signed is

variable retVal : signed( 7 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"04";

begin
 retVal := toSigned( 8, arg );
 return my_shl( retVal , pos );

end int_to_fix8;


function int_to_fix16( arg : signed ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"08";


begin
 retVal := toSigned( 16, arg );
 return my_shl( retVal, pos );

end int_to_fix16;


function int_to_fix32( arg : signed ) return signed is

variable retVal : signed( 31 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"10";

begin
 retVal := toSigned( 32, arg );
 return my_shl( retVal , pos );

end int_to_fix32;


function int_to_fix64( arg : signed ) return signed is

variable retVal : signed( 63 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"20";

begin
 retVal := toSigned( 64, arg );
 return my_shl( retVal , pos );

end int_to_fix64;


function uint_to_fix8( arg : unsigned ) return signed is

variable retVal : signed( 7 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"04";
	    
begin
 retVal := toSigned( 8, arg );
 return my_shl( retVal , pos );

end uint_to_fix8;


function uint_to_fix16( arg : unsigned ) return signed is

variable retVal : signed( 15 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"08";

begin
 retVal := toSigned( 16, arg );
 return my_shl( retVal , pos );

end uint_to_fix16;


function uint_to_fix32( arg : unsigned ) return signed is

variable retVal : signed( 31 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"10";

begin
 retVal := toSigned( 32, arg );
 return my_shl( retVal , pos );

end uint_to_fix32;


function uint_to_fix64( arg : unsigned ) return signed is

variable retVal : signed( 63 downto 0 );
constant pos : unsigned( 7 downto 0 ) := x"20";

begin
 retVal := toSigned( 64, arg );
 return my_shl( retVal , pos );

end uint_to_fix64;


function bool_to_fix8( arg : boolean ) return signed is

begin
  return uint_to_fix8( toUnsigned( arg ) );

end bool_to_fix8; 


function bool_to_fix16( arg : boolean ) return signed is

begin
  return uint_to_fix16( toUnsigned( arg ) );

end bool_to_fix16;


function bool_to_fix32( arg : boolean ) return signed is

begin
  return uint_to_fix32( toUnsigned( arg ) );

end bool_to_fix32;


function bool_to_fix64( arg : boolean ) return signed is

begin
  return uint_to_fix64( toUnsigned( arg ) );

end bool_to_fix64;

function fix8_to_int( size : integer; arg : signed ) return signed is

constant pos : unsigned( 7 downto 0 ) := x"04";
variable retVal : signed( 7 downto 0 );

begin

 if( ( arg(7) = '0' ) or ( arg(3 downto 0) = x"0"  ) ) then
  retVal :=  my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"01";
 end if;

  return toSigned( size, retVal );

end fix8_to_int;


function fix16_to_int( size : integer; arg : signed ) return signed is

constant pos : unsigned( 7 downto 0 ) := x"08";
variable retVal : signed( 15 downto 0 );

begin

 if( ( arg(15) = '0' ) or ( arg(7 downto 0) = x"00"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"0001" ;
 end if;

  return 	toSigned( size, retVal );

end fix16_to_int;

function fix32_to_int( size : integer; arg : signed ) return signed is

constant pos : unsigned( 7 downto 0 ) := x"10";
variable retVal : signed( 31 downto 0 );

begin

 if( ( arg(31) = '0' ) or ( arg(15 downto 0) = x"0000"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"00000001" ;
 end if;

  return toSigned( size, retVal );

end fix32_to_int;


function fix64_to_int( size : integer; arg : signed ) return signed is

constant pos : unsigned( 7 downto 0 ) := x"20";
variable retVal : signed( 63 downto 0 );

begin

 if( ( arg(63) = '0' ) or ( arg(31 downto 0) = x"00000000"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"0000000000000001";
 end if;

  return toSigned( size, retVal );

end fix64_to_int;


function fix8_to_uint( size : integer; arg : signed ) return unsigned is

constant pos : unsigned( 7 downto 0 ) := x"04";
variable retVal : signed( 7 downto 0 );

begin

 if( ( arg(7) = '0' ) or ( arg(3 downto 0) = x"0"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"01";
 end if;

  return toUnsigned( size, retVal );

end fix8_to_uint;

function fix16_to_uint( size : integer; arg : signed ) return unsigned is

constant pos : unsigned( 7 downto 0 ) := x"08";
variable retVal : signed( 15 downto 0 );

begin

 if( ( arg(15) = '0' ) or ( arg(7 downto 0) = x"00"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"0001";
 end if;

  return toUnsigned( size, retVal );

end fix16_to_uint;



function fix32_to_uint( size : integer; arg : signed ) return unsigned is

constant pos : unsigned( 7 downto 0 ) := x"10";
variable retVal : signed( 31 downto 0 );

begin

 if( ( arg(31) = '0' ) or ( arg(15 downto 0) = x"0000"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"00000001";
 end if;

  return toUnsigned( size, retVal );

end fix32_to_uint;


function fix64_to_uint( size : integer; arg : signed ) return unsigned is 

constant pos : unsigned( 7 downto 0 ) := x"20";
variable retVal : signed( 63 downto 0 );

begin

 if( ( arg(63) = '0' ) or ( arg(31 downto 0) = x"00000000"  ) ) then
  retVal := my_shr( arg, pos );
 else
  retVal := my_shr( arg, pos ) + x"0000000000000001";
 end if;

  return toUnsigned( size, retVal );

end fix64_to_uint;


function fix8_to_bool( arg : signed ) return boolean is

variable retVal : signed( arg'length -1 downto 0 );

begin
  retVal :=  arg;
  return toBool( retVal );

end fix8_to_bool;


function fix16_to_bool( arg : signed ) return boolean is

variable retVal : signed( arg'length -1 downto 0 );

begin
  retVal :=  arg;
  return toBool( retVal );

end fix16_to_bool;


function fix32_to_bool( arg : signed ) return boolean is

variable retVal : signed( arg'length -1 downto 0 );

begin
  retVal :=  arg;
  return toBool( retVal );

end fix32_to_bool;


function fix64_to_bool( arg : signed ) return boolean is

variable retVal : signed( arg'length -1 downto 0 );

begin
  retVal :=  arg;
  return toBool( retVal );

end fix64_to_bool;

end package body conversion;         																																																																																						                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                    



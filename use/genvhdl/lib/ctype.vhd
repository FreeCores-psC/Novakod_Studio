--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_misc.all;

package ctype is

function isalpha ( arg: unsigned ) return boolean; 
function isalnum ( arg: unsigned ) return boolean; 
function isdigit ( arg: unsigned ) return boolean; 
function isascii ( arg: unsigned ) return boolean;
function iscntrl ( arg: unsigned ) return boolean; 
function isxdigit ( arg: unsigned ) return boolean; 
function isprint ( arg: unsigned ) return boolean; 
function ispunct ( arg: unsigned ) return boolean; 
function islower ( arg: unsigned ) return boolean; 
function isupper ( arg: unsigned ) return boolean; 
function isspace ( arg: unsigned ) return boolean; 
function toascii ( arg: signed ) return unsigned; 
function tolower ( arg: unsigned ) return unsigned;
function toupper ( arg: unsigned ) return unsigned; 



end package ctype;


package body ctype is

function isalpha ( arg: unsigned ) return boolean is
        
   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( ( choice >= x"41" and choice <= x"5a" ) or 
       ( choice >= x"61" and choice <= x"7a" ) ) then
      return true;

   else
    return false;

   end if;

end isalpha;

 
function isalnum ( arg: unsigned ) return boolean is 

   begin

   if( isalpha( arg ) or isdigit( arg ) ) then
      return true;

   else
    return false;

   end if;

end isalnum;


function isdigit ( arg: unsigned ) return boolean is 

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice >= x"30" and choice <= x"39" ) then
      return true;

   else
    return false;

   end if;

end isdigit;


function isascii ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice <= x"7f" )  then
      return true;

   else
    return false;

   end if;

end isascii;


function iscntrl ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice <= x"1f" or choice = x"7f" )  then
      return true;

   else
    return false;

   end if;

end iscntrl; 


function isxdigit ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( isdigit( choice ) or ( choice >= x"61" and choice <= x"66" ) ) then
      return true;

   else
    return false;

   end if;

end isxdigit;
 
function isprint ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( iscntrl( choice ) ) then
    return false;

   else
    return true;

   end if;

end isprint;
 
function ispunct ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( ( choice >= x"21" and choice <= x"2f" ) or
       ( choice >= x"3a" and choice <= x"40" ) or
	  ( choice >= x"5b" and choice <= x"60" ) or
	  ( choice >= x"7b" and choice <= x"7e" ) ) then
      return true;

   else
    return false;

   end if;


end ispunct;

 
function islower ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice >= x"61" and choice <= x"7a" ) then
    return true;

   else
    return false;

   end if;

end islower;

 
function isupper ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice >= x"41" and choice <= x"5a" ) then
    return true;

   else
    return false;

   end if;

end isupper;
 
function isspace ( arg: unsigned ) return boolean is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( ( choice >= x"09" and choice <= x"0b" )  or
       choice = x"20" ) then
    return true;

   else
    return false;

   end if;

end isspace;
 
function toascii( arg: signed ) return unsigned is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( unsigned( arg ), 8 );

   if( choice >= x"7f" ) then
    choice := choice - x"7f";
   end if;

   return choice; 

end toascii;

 
function tolower ( arg: unsigned ) return unsigned is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice >= x"41" and choice <= x"5a" ) then
    choice := choice + x"20";
   end if;

   return choice; 

end tolower;



function toupper ( arg: unsigned ) return unsigned is

   variable choice : unsigned( 7 downto 0 );
   begin

   choice := resize( arg, 8 );

   if( choice >= x"61" and choice <= x"7a" ) then
    choice := choice - x"20";
   end if;

   return choice; 

end toupper;
 
end package body ctype;

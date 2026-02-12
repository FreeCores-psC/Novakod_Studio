--	Package File RodinStd
--
--    Purpose: This package defines components used when
--           generating main.vhd

-- *******************************************************
-- IMPORTANT
-- The current method of infering RAM uses combinational
-- read. This is not portable and not garanty to work.
-- This also imits usage to distributed memory!!!
-- A more reliable method has been developped using
-- a double frequency clock.
-- Combinational implementation have "Reg" suffix and
-- normally implements as LUT memory, varies with
-- synthesis tool and device.
-- *******************************************************

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;

package RodinStd is

-----------------------------------------------
-- Memory components for inferred memory
-----------------------------------------------
    
    -- Used for dual RW port, tool decides on implementation:
	--     int Arr[10] 
    component raminfr is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
			addrW :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR :  out std_logic_vector(typeSize - 1 downto 0) );
    end component;

    -- Used for dual RW port, implemented in logic/distributed memory:
	--     register int Arr[10] 
    component raminfrReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
			addrW :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR :  out std_logic_vector(typeSize - 1 downto 0) );
      end component;

    -- Used for true dual port using block memory 
	 --     shared int Arr[10] 
    component raminfrShrd is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR_A :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW_A :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR_A :  out std_logic_vector(typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR_B :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW_B :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR_B :  out std_logic_vector(typeSize - 1 downto 0) );
    end component;
	 
    -- Used for true dual port using LUT 
	 --     register shared int Arr[10] 
    component raminfrShrdReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR_A :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW_A :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR_A :  out std_logic_vector(typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  std_logic_vector(logsize  - 1 downto 0);
			addrR_B :  in  std_logic_vector(logsize  - 1 downto 0);
			dataW_B :  in  std_logic_vector(typeSize - 1 downto 0);
			dataR_B :  out std_logic_vector(typeSize - 1 downto 0) );
    end component;

    -- Used in DMA controller?
    component braminfr is
      generic( 
		   size :     integer := 4; 
         logsize :  integer := 2; 
	      typeSize : integer := 32 );
      port ( 
		   clk :   in std_logic;
         we :    in std_logic;
			addrW : in  std_logic_vector(logsize  - 1 downto 0);
			addrR : in  std_logic_vector(logsize  - 1 downto 0);
			dataW : in  std_logic_vector(typeSize - 1 downto 0);
			dataR : out std_logic_vector(typeSize - 1 downto 0) );
    end component;

-----------------------------------------------
-- Components for specific applications:
--            signed
--            signed register
--            signed shared

--            unsigned
--            unsigned register
--            unsigned shared 

--            boolean 
--            boolean register 
--            boolean shared 

--            Generic API interface
-----------------------------------------------

    component raminfrSigned is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  signed  (typeSize - 1 downto 0);
         dataR :  out signed  (typeSize - 1 downto 0) );
     end component;

    component raminfrSignedReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  signed  (typeSize - 1 downto 0);
         dataR :  out signed  (typeSize - 1 downto 0) );
     end component;

    component raminfrSignedShrd is 
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  unsigned(logsize  - 1 downto 0);
			addrR_A :  in  unsigned(logsize  - 1 downto 0);
			dataW_A :  in  signed  (typeSize - 1 downto 0);
			dataR_A :  out signed  (typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  unsigned(logsize  - 1 downto 0);
			addrR_B :  in  unsigned(logsize  - 1 downto 0);
			dataW_B :  in  signed  (typeSize - 1 downto 0);
			dataR_B :  out signed  (typeSize - 1 downto 0) );
    end component;


    component raminfrUnsigned is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  unsigned(typeSize - 1 downto 0);
         dataR :  out unsigned(typeSize - 1 downto 0) );
     end component;
     
     
    component raminfrUnsignedReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  unsigned(typeSize - 1 downto 0);
         dataR :  out unsigned(typeSize - 1 downto 0) );
     end component;

    component raminfrUnsignedShrd is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  unsigned(logsize  - 1 downto 0);
			addrR_A :  in  unsigned(logsize  - 1 downto 0);
			dataW_A :  in  unsigned(typeSize - 1 downto 0);
			dataR_A :  out unsigned(typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  unsigned(logsize  - 1 downto 0);
			addrR_B :  in  unsigned(logsize  - 1 downto 0);
			dataW_B :  in  unsigned(typeSize - 1 downto 0);
			dataR_B :  out unsigned(typeSize - 1 downto 0) );
    end component;

    component raminfrBool is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  boolean;
         dataR :  out boolean );
     end component;


    component raminfrBoolReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  boolean;
         dataR :  out boolean );
     end component;

    component raminfrBooldShrd is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  unsigned(logsize  - 1 downto 0);
			addrR_A :  in  unsigned(logsize  - 1 downto 0);
			dataW_A :  in  boolean;
			dataR_A :  out boolean;
			we_B :     in  std_logic;
			addrW_B :  in  unsigned(logsize  - 1 downto 0);
			addrR_B :  in  unsigned(logsize  - 1 downto 0);
			dataW_B :  in  boolean;
			dataR_B :  out boolean );
    end component;


    component braminfrInterface is
         generic( 
		      log_size : integer );
         port ( 
				clk :                 in  std_logic;
				port_command :        in  std_logic_vector(1  downto 0);
				port_command_ev :     in  std_logic;
				port_addressIn :      in  std_logic_vector(22 downto 0);
				port_dataOut :        in  std_logic_vector(31 downto 0);
				port_isInitOver :     out std_logic_vector(0  downto 0);
				port_isInitOver_ev :  out std_logic;  
				port_DQin :           out std_logic_vector(31 downto 0);
				port_dataInEvent_ev : out std_logic ;
				port_almost_full:     out std_logic_vector(0  downto 0);
				port_almost_full_ev:  out std_logic );
     end component;

-----------------------------------------------
-- Delay components
-----------------------------------------------

     component delay_unsigned is
       generic( n : integer; m : integer );
       port( clk : in std_logic ;
             start : in std_logic;
             port_in_port : in unsigned( n - 1 downto 0 );
             port_in_port_ev : in std_logic;                
             port_out_port : out unsigned( n - 1 downto 0 );
             port_out_port_ev : out std_logic     
            );
     end component;     

     component delay_signed is
       generic( n : integer; m : integer );
       port( clk : in std_logic; 
             start : in std_logic;
             port_in_port : in signed( n - 1 downto 0 );
             port_in_port_ev : in std_logic;                
             port_out_port : out signed( n - 1 downto 0 );
             port_out_port_ev : out std_logic 
           );
     end component;    

     component delay_boolean is
       generic( m : integer );
       port( clk : in std_logic;
             start : in std_logic; 
             port_in_port : in boolean; 
             port_in_port_ev : in std_logic;     
             port_out_port : out boolean;
             port_out_port_ev : out std_logic    
           );
     end component;    

     component delay_shift is
       generic(n : integer);
       port(clk : in std_logic; 
            SI :  in std_logic; 
            SO :  out std_logic);
     end component;

     component delay is     
       generic( n : integer; m : integer );
       port( clk : in std_logic; 
             SI :  in std_logic_vector( n - 1 downto 0 ); 
             SO :  out std_logic_vector( n - 1 downto 0 ) 
           );
     end component;

-----------------------------------------------
-- Timer components
-----------------------------------------------

    component Timer is 
    port
    (
       clk : in std_logic;
       reset : in std_logic;
       start : in std_logic;
       stop : in std_logic;
       input_timer_value : in signed( 63 downto 0 );
       output_timer_value : out signed( 63 downto 0 );
       output_old_value : out signed( 63 downto 0 );
       timerEnd_ev : out std_logic
    );
    end component;

    component startState is
    port
    ( 
      clk : in std_logic;
      reset : in std_logic;
      StartIn : in std_logic; 
      StartOut : out std_logic; 
      stop : in std_logic;
      timer_end : in std_logic
    );
    end component; 

    component timeInc is
    port
    ( 
      invalue : in signed( 63 downto 0 ); 
      count_old : in signed( 63 downto 0 ); 
      count_new : out signed( 63 downto 0 );
      timer_ev : out std_logic
    );
    end component; 

    component ffdstart is
    port
    (
      clk : in std_logic;
      valueIn : in signed( 63 downto 0 );
      start : in std_logic;
      valueOut : out signed( 63 downto 0 );
      evIn : in std_logic;
      evOut : out std_logic;
      ActValueIn : in signed( 63 downto 0 );
      ActValueOut : out signed( 63 downto 0 )
    );

    end component;

     component getTimer is 
    port
    (
      ActValue : in signed( 63 downto 0 );
      TimerValue : in signed( 63 downto 0 );
      OutValue : out signed( 63 downto 0 )
    );
    end component;

end RodinStd;  -- Package

--======================================================
--== Entities and architecturs for infered memory 
--======================================================

-----------------------------------------------
-- Component used in array : 
--     int Arr[10];
-- The combinational operation is simulated
-- by using a double frequancy "memclk"
-----------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

-----
entity raminfr is
  generic ( 
	size :     integer; 
	logsize :  integer; 
	typeSize : integer );
  port ( 
	clk :    in  std_logic;
	memclk : in  std_logic;
	we :     in  std_logic;
	addrW :  in  std_logic_vector(logsize  - 1 downto 0);
	addrR :  in  std_logic_vector(logsize  - 1 downto 0);
	dataW :  in  std_logic_vector(typeSize - 1 downto 0);
	dataR :  out std_logic_vector(typeSize - 1 downto 0) );
end raminfr;

-----
architecture syn of raminfr is
  type ram_type is array (size -1 downto 0) of 
       std_logic_vector (typeSize -1 downto 0);
  signal RAM : ram_type;

begin -- syn
  ----- Read process    
  process (memclk) 
    begin
      if rising_edge(memclk) then
        dataR <= RAM(conv_integer(addrR));
      end if;
   end process; 
  ----- Write process    
  process (clk) 
    begin
      if rising_edge(clk) then
        if we = '1' then
          RAM(conv_integer(addrW)) <= dataW; 
        end if;
      end if;
   end process; 
end syn;

-----------------------------------------------------------
-- Version for distributed memory, declared as:
--     register byte Arr[10];
-----------------------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

-----
entity raminfrReg is
generic(
  size :     integer; 
     logsize :  integer; 
     typeSize : integer );
port ( 
  clk :    in  std_logic;
  memclk : in  std_logic;
  we :     in  std_logic;
  addrW :  in  std_logic_vector(logsize  - 1 downto 0);
  addrR :  in  std_logic_vector(logsize  - 1 downto 0);
  dataW :  in  std_logic_vector(typeSize - 1 downto 0);
  dataR :  out std_logic_vector(typeSize - 1 downto 0));
end raminfrReg;

-----
architecture syn of raminfrReg is
  type ram_type is array (size -1 downto 0) of 
      std_logic_vector (typeSize -1 downto 0);
  signal RAM : ram_type;
  --  Quartus
--  attribute ramstyle : string;
--  attribute ramstyle of RAM : signal is "logic";  
  --  Vivado
--  attribute ram_style : string;
--  attribute ram_style of RAM : signal is "distributed";  
begin  -- syn
  ----- Read/Write process    
  process (clk, addrR)
  begin
    if rising_edge(clk) then
      -- WRITE
      if (we = '1') then
        RAM(conv_integer(addrW)) <= dataW;
      end if;
    end if;

    -- READ all the time, generates combinational circuit
    dataR <= RAM(conv_integer(addrR));
  end process;
end syn;

-----------------------------------------------------------
-- Version for dual port memory, declared as:
--     shared byte Arr[10];
-----------------------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

-----
entity raminfrShrd is
  generic ( 
	size :     integer; 
	logsize :  integer; 
	typeSize : integer );
  port ( 
	clk :      in  std_logic;
	memclk :   in  std_logic;
	we_A :     in  std_logic;
	addrW_A :  in  std_logic_vector(logsize  - 1 downto 0);
	addrR_A :  in  std_logic_vector(logsize  - 1 downto 0);
	dataW_A :  in  std_logic_vector(typeSize - 1 downto 0);
	dataR_A :  out std_logic_vector(typeSize - 1 downto 0);
	we_B :     in  std_logic;
	addrW_B :  in  std_logic_vector(logsize  - 1 downto 0);
	addrR_B :  in  std_logic_vector(logsize  - 1 downto 0);
	dataW_B :  in  std_logic_vector(typeSize - 1 downto 0);
	dataR_B :  out std_logic_vector(typeSize - 1 downto 0) );
end raminfrShrd;

-----
architecture syn of raminfrShrd is
  type ram_type is array (size -1 downto 0) of 
       std_logic_vector (typeSize -1 downto 0);
  signal RAM : ram_type;

begin -- syn
	-- Read process: Port A
	process(memclk)
	begin
		if(rising_edge(memclk)) then 
		    dataR_A <= RAM(conv_integer(addrR_A));
		end if;
	end process;
	-- Write process: Port A
	process(clk)
	begin
	    -- WRITE
		if(rising_edge(clk)) then 
	        if we_A = '1' then
                RAM(conv_integer(addrW_A)) <= dataW_A; 
			end if;
		end if;
	end process;
	
	-- Read process: Port B
	process(memclk)
		begin
		if(rising_edge(memclk)) then 
		    dataR_B <= RAM(conv_integer(addrR_B));
		end if;
	end process;
	-- Write process: Port B
	process(clk)
	begin
	    -- WRITE
		if(rising_edge(clk)) then 
	        if we_B = '1' then
                RAM(conv_integer(addrW_B)) <= dataW_B; 
			end if;
		end if;
	end process;
end syn;


-----------------------------------------------------------
-- Version for register dual port memory, declared as:
--     register shared byte Arr[10];
-----------------------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

-----
entity raminfrShrdReg is
  generic ( 
	size :     integer; 
	logsize :  integer; 
	typeSize : integer );
  port ( 
	clk :      in  std_logic;
	memclk :   in  std_logic;
	we_A :     in  std_logic;
	addrW_A :  in  std_logic_vector(logsize  - 1 downto 0);
	addrR_A :  in  std_logic_vector(logsize  - 1 downto 0);
	dataW_A :  in  std_logic_vector(typeSize - 1 downto 0);
	dataR_A :  out std_logic_vector(typeSize - 1 downto 0);
	we_B :     in  std_logic;
	addrW_B :  in  std_logic_vector(logsize  - 1 downto 0);
	addrR_B :  in  std_logic_vector(logsize  - 1 downto 0);
	dataW_B :  in  std_logic_vector(typeSize - 1 downto 0);
	dataR_B :  out std_logic_vector(typeSize - 1 downto 0) );
end raminfrShrdReg;

-----
architecture syn of raminfrShrdReg is
  type ram_type is array (size -1 downto 0) of 
       std_logic_vector (typeSize -1 downto 0);
  signal RAM : ram_type;

begin -- syn
  ----- Read/Write process A   
  process (clk, addrR_A)
  begin
    if rising_edge(clk) then
      -- WRITE
      if (we_A = '1') then
        RAM(conv_integer(addrW_A)) <= dataW_B;
      end if;
    end if;

    -- READ all the time, generates combinational circuit
    dataR_A <= RAM(conv_integer(addrR_A));
  end process;

 ----- Read/Write process B   
  process (clk, addrR_B)
  begin
    if rising_edge(clk) then
      -- WRITE
      if (we_B = '1') then
        RAM(conv_integer(addrW_B)) <= dataW_B;
      end if;
    end if;

    -- READ all the time, generates combinational circuit
    dataR_B <= RAM(conv_integer(addrR_B));
  end process;
end syn;

-----------------------------------------------
-- Component used in the DMA controller
-- Address is latched and it uses "clk"
-----------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity braminfr is
generic( 
  size :     integer := 4; 
  logsize :  integer := 2; 
  typeSize : integer := 32 );

port ( 
   clk :  in std_logic;
   we :   in std_logic;
   addrW : in std_logic_vector (logsize  - 1 downto 0);
   addrR : in std_logic_vector (logsize  - 1 downto 0);
   dataW : in std_logic_vector (typeSize - 1 downto 0);
   dataR : out std_logic_vector(typeSize - 1 downto 0));
end braminfr;

architecture syn of braminfr is
  type ram_type is array (size -1 downto 0) of 
          std_logic_vector (typeSize -1 downto 0);
  signal RAM : ram_type;
  
  signal s_addrR : std_logic_vector(logsize-1 downto 0);
  
  begin
   process (clk)
     begin
     if (rising_edge(clk)) then
       if (we = '1') then
        RAM(conv_integer(addrW)) <= dataW;
       end if;
        s_addrR <= addrR;
     end if;
     dataR <= RAM(conv_integer(s_addrR));
   end process;       
end syn;

--======================================================
--== Entities and architectures for specific applications:
--            signed 
--            signed register 
--            signed shared
--
--            unsigned 
--            unsigned register 
--            unsigned shared 
--
--            boolean 
--            boolean register 
--            boolean shared 
--
--            Generic API interface
--======================================================

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrSigned is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  signed  (typeSize - 1 downto 0);
         dataR :  out signed  (typeSize - 1 downto 0) );
end raminfrSigned;


architecture syn of raminfrSigned is

    signal s_dataR : std_logic_vector( typeSize - 1 downto 0 );

begin 

    A1 : raminfr 
    generic map( size, logsize, typeSize )
    port map
    (
      clk    => clk,
      memclk => memclk,
      we     => we,
      addrW  => toTopBv( addrW ),
      addrR  => toTopBv( addrR ),
      dataW  => toTopBv( dataW ),
      dataR  => s_dataR
    );

    dataR <= toTopSigned( s_dataR);

end syn;

-----------------------------------------------------------
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrSignedReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  signed  (typeSize - 1 downto 0);
         dataR :  out signed  (typeSize - 1 downto 0) );
end raminfrSignedReg;


architecture syn of raminfrSignedReg is

	signal s_dataR : std_logic_vector( typeSize - 1 downto 0 );

begin 

	A1 : raminfrReg 
	generic map( size, logsize, typeSize )
	port map
	(
	clk    => clk,
	memclk => memclk,
	we     => we,
	addrW      => toTopBv( addrW ),
	addrR   => toTopBv( addrR ),
	dataW     => toTopBv( dataW ),
	dataR    => s_dataR
	);

	dataR <= toTopSigned( s_dataR );
	
end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrSignedShrd is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  unsigned(logsize  - 1 downto 0);
			addrR_A :  in  unsigned(logsize  - 1 downto 0);
			dataW_A :  in  signed  (typeSize - 1 downto 0);
			dataR_A :  out signed  (typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  unsigned(logsize  - 1 downto 0);
			addrR_B :  in  unsigned(logsize  - 1 downto 0);
			dataW_B :  in  signed  (typeSize - 1 downto 0);
			dataR_B :  out signed  (typeSize - 1 downto 0) );
end raminfrSignedShrd;


architecture syn of raminfrSignedShrd is

    signal s_dataR_A : std_logic_vector( typeSize - 1 downto 0 );
    signal s_dataR_B : std_logic_vector( typeSize - 1 downto 0 );

begin 

    A1 : raminfrShrd 
    generic map( size, logsize, typeSize )
    port map
    (
      clk    => clk,
      memclk => memclk,
	we_A     => we_A,
	addrW_A      => toTopBv( addrW_A ),
	addrR_A   => toTopBv( addrR_A ),
	dataW_A     => toTopBv( dataW_A ),
	dataR_A    => s_dataR_A,
	we_B     => we_B,
	addrW_B      => toTopBv( addrW_B ),
	addrR_B   => toTopBv( addrR_B ),
	dataW_B    => toTopBv( dataW_B ),
	dataR_B   => s_dataR_B
    );

    dataR_A <= toTopSigned( s_dataR_A);
    dataR_B <= toTopSigned( s_dataR_B);

end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrUnsigned is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  unsigned(typeSize - 1 downto 0);
         dataR :  out unsigned(typeSize - 1 downto 0) );
end raminfrUnsigned;


architecture syn of raminfrUnsigned is

	signal s_dataR : std_logic_vector( typeSize - 1 downto 0 );

begin 

  A1 : raminfr 
  generic map( size, logsize, typeSize )
  port map
  (
    clk => clk,
    memclk => memclk,
    we => we,
    addrW => toTopBv( addrW ),
    addrR => toTopBv( addrR ),
    dataW => toTopBv( dataW ),
    dataR => s_dataR
  );

  dataR <= toTopUnsigned( s_dataR);

end syn;
-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrUnsignedReg is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW :  in  unsigned(typeSize - 1 downto 0);
         dataR :  out unsigned(typeSize - 1 downto 0) );
end raminfrUnsignedReg;


architecture syn of raminfrUnsignedReg is

	signal s_dataR : std_logic_vector( typeSize - 1 downto 0 );

begin 

	A1 : raminfrReg 
	generic map( size, logsize, typeSize )
	port map
	(
	  clk => clk,
	  memclk => memclk,
	  we => we,
	  addrW => toTopBv( addrW ),
	  addrR => toTopBv( addrR ),
	  dataW => toTopBv( dataW ),
	  dataR => s_dataR
	);

	dataR <= toTopUnsigned( s_dataR );

end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrUnsignedShrd is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :      in  std_logic;
			memclk :   in  std_logic;
			we_A :     in  std_logic;
			addrW_A :  in  unsigned(logsize  - 1 downto 0);
			addrR_A :  in  unsigned(logsize  - 1 downto 0);
			dataW_A :  in  unsigned(typeSize - 1 downto 0);
			dataR_A :  out unsigned(typeSize - 1 downto 0);
			we_B :     in  std_logic;
			addrW_B :  in  unsigned(logsize  - 1 downto 0);
			addrR_B :  in  unsigned(logsize  - 1 downto 0);
			dataW_B :  in  unsigned(typeSize - 1 downto 0);
			dataR_B :  out unsigned(typeSize - 1 downto 0) );
end raminfrUnsignedShrd;


architecture syn of raminfrUnsignedShrd is

    signal s_dataR_A : std_logic_vector( typeSize - 1 downto 0 );
    signal s_dataR_B : std_logic_vector( typeSize - 1 downto 0 );

begin 

    A1 : raminfrShrd 
    generic map( size, logsize, typeSize )
    port map
    (
      clk    => clk,
      memclk => memclk,
	we_A     => we_A,
	addrW_A      => toTopBv( addrW_A ),
	addrR_A   => toTopBv( addrR_A ),
	dataW_A     => toTopBv( dataW_A ),
	dataR_A    => s_dataR_A,
	we_B     => we_B,
	addrW_B      => toTopBv( addrW_B ),
	addrR_B   => toTopBv( addrR_B ),
	dataW_B    => toTopBv( dataW_B ),
	dataR_B   => s_dataR_B
    );

    dataR_A <= toTopUnsigned( s_dataR_A);
    dataR_B <= toTopUnsigned( s_dataR_B);

end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrBool is
      generic ( 
			size :     integer; 
			logsize :  integer; 
			typeSize : integer );
      port ( 
			clk :    in  std_logic;
			memclk : in  std_logic;
			we :     in  std_logic;
         addrW :  in  unsigned(logsize  - 1 downto 0);
         addrR :  in  unsigned(logsize  - 1 downto 0);
         dataW : in boolean;
         dataR : out boolean );
end raminfrBool;

architecture syn of raminfrBool is

  signal s_dataR : std_logic_vector( 0 downto 0 );

begin 
  A1 : raminfr
  generic map( size, logsize, 1 )
  port map
  (
    clk => clk,
    memclk => memclk,
    we => we,
    addrW => toTopBv( addrW ),
    addrR => toTopBv( addrR ),
    dataW => toTopBv( dataW ),
    dataR => s_dataR
  );

  dataR <= toTopBool( s_dataR );
end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity raminfrBoolReg is
      generic ( 
		size :     integer; 
		logsize :  integer; 
		typeSize : integer );
      port ( 
		clk :    in  std_logic;
		memclk : in  std_logic;
		we :     in  std_logic;
        addrW :  in  unsigned(logsize  - 1 downto 0);
        addrR :  in  unsigned(logsize  - 1 downto 0);
        dataW :  in  boolean;
        dataR :  out boolean );
end raminfrBoolReg;

architecture syn of raminfrBoolReg is

	signal s_dataR : std_logic_vector( 0 downto 0 );

begin 
	A1 : raminfrReg
	generic map( size, logsize, 1 )
	port map
	(
	  clk    => clk,
	  memclk => memclk,
	  we     => we,
	  addrW  => toTopBv( addrW ),
	  addrR  => toTopBv( addrR ),
	  dataW  => toTopBv( dataW ),
	  dataR  => s_dataR
	);

	dataR <= toTopBool( s_dataR);
end syn;

-----------------------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity braminfrInterface is
  generic( log_size : integer := 9 );
    port ( 
      clk :                in std_logic;
      memclk : in std_logic;
      port_commande :       in std_logic_vector( 1 downto 0 );
      port_commande_ev :    in std_logic;
      port_addressIn :      in std_logic_vector(22 downto 0);
      port_dataOut :        in std_logic_vector(31 downto 0);
      port_DQin :           out std_logic_vector(31 downto 0);
      port_dataInEvent_ev : out std_logic;
      port_isInitOver :     out std_logic_vector(0 downto 0);
      port_isInitOver_ev :  out std_logic;  
      port_almost_full :    out std_logic_vector(0 downto 0);
      port_almost_full_ev : out std_logic
  );
  end braminfrInterface;

architecture syn of braminfrInterface is

  signal isRead :    std_logic;
  signal s_isRead :  std_logic;
  signal isInit :    std_logic;
  signal s_isInit :  std_logic;
  signal rise_init : std_logic_vector(0 downto 0);
  signal we :        std_logic;
  
  signal Dout : std_logic_vector(31 downto 0);
  
begin

   isRead <= '1' when ( port_commande = "01" and port_commande_ev = '1') else '0';
   isInit <= '1' when ( port_commande = "00" and port_commande_ev = '1') else '0'; 
   we     <= '1' when ( port_commande = "10" and port_commande_ev = '1') else '0'; 

   port_isInitOver_ev  <= s_isInit;
   port_isInitOver     <= rise_init;
   rise_init(0)        <= ( ( not s_isInit ) and ( isInit ) );

   port_dataInEvent_ev <= s_isRead;

   process (clk)
     begin
       if rising_edge(clk ) then
         s_isRead <= isRead;
         s_isInit <= isInit;
         if(isRead = '1') then
           port_DQin <= Dout;
         end if;
       end if;
     end process;

   C1 : raminfr
   generic map ( 2**log_size , log_size, 32 )
   port map
   (
     clk    => clk,
     memclk => memclk,
     we     => we,
     addrW  => port_addressIn( log_size -1 downto 0 ),
     addrR  => port_addressIn( log_size -1 downto 0 ),
     dataW  => port_dataOut,
     dataR  => Dout
   );             

   port_almost_full    <= "0"; 
   port_almost_full_ev <= '0';

end syn;


-----------------------------------------------
-- Delay entities and architecture
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;


entity delay_shift is
  generic(n : integer);
     port( clk: in std_logic; 
          SI : in std_logic;
           SO : out std_logic
        );
end delay_shift;

architecture archi of delay_shift is
  signal tmp: std_logic_vector(n-1 downto 0);
begin
   process (clk)
   begin
    if (clk'event and clk='1') then
     for i in 0 to n-2 loop
      tmp(i+1) <= tmp(i);
     end loop;
     tmp(0) <= SI;
    end if;
   end process;
   SO <= tmp(n-1);
end archi;

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity delay is     
  generic( n : integer; m : integer );
    port
    ( 
      clk : in std_logic; 
      SI : in std_logic_vector( n - 1 downto 0 ); 
      SO : out std_logic_vector( n - 1 downto 0 ) 
    );
end delay;

architecture archi of delay is
  begin
  U1 : for i in 0 to n - 1 generate

   Q1 : delay_shift
     generic map( m ) 
      port map
      (
        clk => clk,
        SI => SI(i),
        SO => SO(i)
      );


  end generate;

end archi;

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity delay_unsigned is
  generic( n : integer; m : integer );
    port(   clk : in std_logic;
            start : in std_logic;  
            port_in_port : in unsigned( n - 1 downto 0 );
           port_in_port_ev : in std_logic;            
           port_out_port : out unsigned( n - 1 downto 0 );
           port_out_port_ev : out std_logic 
         );
end delay_unsigned;     

architecture structural of delay_unsigned is

	signal input : std_logic_vector( n-1 downto 0 );
	signal output : std_logic_vector( n-1 downto 0 );

begin

  C3 : delay
   generic map(n,m)
   port map
   (
       clk => clk,
    SI => input,
       SO => output
   );

   C4 : delay
   generic map(1,m)
   port map
   (
     clk => clk,
       SI(0) => port_in_port_ev,
    SO(0) => port_out_port_ev
   );

   input <= toTopBv( port_in_port );
   port_out_port <= toTopUnsigned( output );

end structural;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity delay_signed is
  generic( n : integer; m : integer );
    port( clk : in std_logic;
          start : in std_logic;  
          port_in_port : in signed( n - 1 downto 0 );
         port_in_port_ev : in std_logic;              
         port_out_port : out signed( n - 1 downto 0 );
         port_out_port_ev : out std_logic
         );
end delay_signed;    

architecture structural of delay_signed is

	signal input : std_logic_vector( n-1 downto 0 );
	signal output : std_logic_vector( n-1 downto 0 );

begin

  C3 : delay
   generic map(n,m)
   port map
   (
       clk => clk,
    SI => input,
       SO => output
   );

   C4 : delay
   generic map(1,m)
   port map
   (
     clk => clk,
       SI(0) => port_in_port_ev,
    SO(0) => port_out_port_ev
   );

   input <= toTopBv( port_in_port );
   port_out_port <= toTopSigned( output );

end structural;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity delay_boolean is
  generic( m : integer );
   port( clk : in std_logic;
         start : in std_logic;  
         port_in_port : in boolean;
        port_in_port_ev : in std_logic;          
        port_out_port : out boolean;
        port_out_port_ev : out std_logic
        );
end delay_boolean;    

architecture structural of delay_boolean is

	signal input : std_logic_vector( 0 downto 0 );
	signal output : std_logic_vector( 0 downto 0 );

begin

  C3 : delay
   generic map(1,m)
   port map
   (
       clk => clk,
    SI => input,
       SO => output
   );

   C4 : delay
   generic map(1,m)
   port map
   (
     clk => clk,
       SI(0) => port_in_port_ev,
    SO(0) => port_out_port_ev
   );

   input <= toTopBv( port_in_port );
   port_out_port <= toBool( output(0) );

end structural;


-----------------------------------------------
-- Timer entities and architectures
-----------------------------------------------

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity startState is
	port
	( 
	  clk : in std_logic;
	  reset : in std_logic;
	  StartIn : in std_logic; 
	  StartOut : out std_logic; 
	  stop : in std_logic;
	  timer_end : in std_logic
	);
end startState; 

architecture behave of startState is

	signal currState : bit;
	signal nextState : bit;
	signal resetEvent : boolean;

begin

	nextStateProc : process( currState )
	begin
		case currState is
		  when '1' =>
			  StartOut <= '1';

			if( ( stop = '1' or timer_end = '1' ) and StartIn = '0' ) then
			  nextState <= '0';
			 else
			  nextState <= '1';
			 end if;

		  when '0' =>
			  StartOut <= '0';

			 if( StartIn = '1' and stop = '0' ) then 
			  nextState <= '1';
			 else
			  nextState <= '0';
			 end if;

		end case;
	end process nextStateProc;


	currStateProc : process( clk )
	  begin
		if( clk'event and clk ='1') 
		 then
			if( reset = '1' and StartIn  = '0' ) then
			 currState <= '0';
			else
			  currState <= nextState;
			end if;
		else
		 currState <= currState;
		end if;
		  
	end process currStateProc;

end behave;



Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity timeInc is
port
( 
  invalue : in signed( 63 downto 0 ); 
  count_old : in signed( 63 downto 0 ); 
  count_new : out signed( 63 downto 0 );
  timer_ev : out std_logic
);
end timeInc; 

architecture structural of timeInc is

constant one : signed( 63 downto 0 ) := x"0000000000000001";
constant zero : signed( 63 downto 0 ) := x"0000000000000000";
begin

count_new <= count_old + one when invalue /= count_old else zero;

timer_ev <= '1' when invalue = count_old else '0';

end structural;

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity ffdstart is
port
(
  clk : in std_logic;
  valueIn : in signed( 63 downto 0 );
  start : in std_logic;
  valueOut : out signed( 63 downto 0 );
  evIn : in std_logic;
  evOut : out std_logic;
  ActValueIn : in signed( 63 downto 0 );
  ActValueOut : out signed( 63 downto 0 )
);

end ffdstart;

architecture structural of ffdstart 
is
  signal s_ValueOut : signed( 63 downto 0 );
  signal s_ActValue : signed( 63 downto 0 );
  signal s_Ev : std_logic;
begin


A1 : process( clk ) 
   variable q : signed( 63 downto 0 ); 
begin
   if (clk'event and clk = '1' ) then
    if( start = '1' ) then 
      q := valueIn;
    else
      q := q;
    end if;
   end if;

   s_ValueOut <= q;
end process A1;

A2 : process( clk ) 
   variable q : std_logic; 
begin
   if (clk'event and clk = '1' ) then
    if( start = '1' ) then 
      q := evIn;
    else
      q := q;
    end if;
   end if;

   s_Ev <= q;
end process A2;

s_ActValue <= ActValueIn when ( clk'event and clk = '1' ) else s_ActValue;

valueOut    <= s_ValueOut;
evOut       <= s_Ev;
ActValueOut <= s_ActValue;

end structural;

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity getTimer is 
port
(
  ActValue : in signed( 63 downto 0 );
  TimerValue : in signed( 63 downto 0 );
  OutValue : out signed( 63 downto 0 )
);
end getTimer;

architecture structural of getTimer is

begin

OutValue <= ActValue - TimerValue;

end structural; 


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.conversion.all;
use work.RodinStd.all;

entity Timer is 
port
(
   clk : in std_logic;
   reset : in std_logic;
   start : in std_logic;
   stop : in std_logic;
   input_timer_value : in signed( 63 downto 0 );
   output_timer_value : out signed( 63 downto 0 );
   output_old_value : out signed( 63 downto 0 );
   timerEnd_ev : out std_logic
);

end Timer;


architecture structural of Timer is
signal s_Inval : signed( 63 downto 0 );
signal s_OutVal : signed( 63 downto 0 );
signal s_OutVal2 : signed( 63 downto 0 );
signal s_Oldval : signed( 63 downto 0 );
signal s_Newval : signed( 63 downto 0 );


signal s_StartOut : std_logic;
signal OldEv : std_logic;
signal NewEv : std_logic;

for CO : startState use entity work.startState( behave );
for C1 : timeInc use entity work.timeInc( structural );
for C2 : ffdstart use entity work.ffdstart( structural );
for C3 : getTimer use entity work.getTimer( structural );

begin

CO : startState
port map(  clk => clk, reset => reset, StartIn => start, StartOut => s_StartOut,
           stop => stop, timer_end => OldEv );  

C1 : timeInc
port map( invalue => s_Inval, count_old => s_Oldval,
          count_new => s_Newval, timer_ev => NewEv );

C2 : ffdstart
port map( clk => clk, valueIn => s_Newval,
          start => s_StartOut, valueOut => s_Oldval,
          evIn => NewEv, evOut => OldEv,
        ActValueIn => s_Inval,
          ActValueOut => s_OutVal );

C3 : getTimer
port map( ActValue => s_OutVal,
          TimerValue => s_Oldval,
          OutValue => s_OutVal2
        );



s_Inval <= input_timer_value;
timerEnd_ev <= OldEv;
output_timer_value <= s_OutVal2;
output_old_value <= s_OutVal;

end structural;

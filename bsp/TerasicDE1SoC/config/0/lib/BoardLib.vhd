library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package TerasicDE1SoC is

    component DetectInEvent is
    port
    ( 
      in_ev  : in std_logic;
      enable : in std_logic;
      clk    : in std_logic;
      out_ev : out std_logic
    );
    end component;
    
    component InDiff is 
    generic( n : integer );
    port
    (
       clk : in std_logic;
       input : in std_logic_vector( n - 1 downto 0 );
       output : out std_logic_vector( n - 1 downto 0 );
       output_ev : out std_logic
    );
    end component; 
    
    component InRise is
    generic( n : integer );
    port
    (
       clk : in std_logic;
       input : in std_logic_vector( n - 1 downto 0 );
       output : out std_logic_vector( n - 1 downto 0 );
       output_ev : out std_logic
    );

    end component; 

    component InFall is
    generic( n : integer );
    port
    (
       clk : in std_logic;
       input : in std_logic_vector( n - 1 downto 0 );
       output : out std_logic_vector( n - 1 downto 0 );
       output_ev : out std_logic
    );

    end component;

    component SRlatch is
    port
    ( 
      s : in std_logic;
      r : in std_logic;
      q : out std_logic
    );
    end component;
     
    component BiDir is
    generic( size : integer );
    port
    (
      d_out   : in std_logic_vector( size - 1 downto 0 );
      d_sel   : in std_logic_vector( 0 downto 0 );
      d_in    : out std_logic_vector( size - 1  downto 0 );
      d_inout : inout std_logic_vector( size - 1 downto 0 )
    ); 
    end component;

    component Zbuffer is
    generic( size : integer );
    port
    (
      d_out : out std_logic_vector( size - 1 downto 0 );
      d_sel : in std_logic
    ); 
    end component;

    component Dreg is
    generic (size : integer);
    port
    (
      clk : in std_logic;
      d   : in  std_logic_vector( size - 1 downto 0 );
      q   : out std_logic_vector( size - 1 downto 0 )
    );
    end component;

    component pll IS
    PORT
    (
      inclk0    : IN STD_LOGIC  := '0';
      pllena    : IN STD_LOGIC  := '1';
      areset    : IN STD_LOGIC  := '0';
      c0        : OUT STD_LOGIC ;
      locked    : OUT STD_LOGIC 
    );
    end component;

    component CsramWe is
    port
    (
      clk_50 : in std_logic;
      we_in  : in std_logic;
      we_out : out std_logic
    );
    end component;
    
    component I2C_AV_Config is
    port
    ( 
      --	Host Side
      iCLK     : in std_logic;
      iRST_N   : in std_logic;
      --	I2C Side
      I2C_SCLK : out std_logic;
      I2C_SDAT : inout std_logic
    );   
    end component;

end TerasicDE1SoC;


library IEEE;

use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DetectInEvent is
port
( 
  in_ev : in std_logic;
  enable  : in std_logic;
  clk   : in std_logic;
  out_ev : out std_logic
);

end DetectInEvent;

architecture behavioral of DetectInEvent is

signal firstStage : std_logic;
signal secondStage : std_logic;

begin

process( clk ) 
   variable q : std_logic; 
begin
   if (clk'event and clk = '1' ) then
    if( enable = '1' ) then 
      q := in_ev;
    else
      q := q;
    end if;
   end if;

   firstStage <= q;
end process;

secondStage <= firstStage when clk'event and clk = '1'
                else secondStage;

out_ev <=  ( secondStage xor firstStage  ) and firstStage;

end behavioral;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity InDiff is
generic( n : integer );
port
(
   clk : in std_logic;
   input : in std_logic_vector( n -1 downto 0 );
   output : out std_logic_vector( n -1 downto 0 );
   output_ev : out std_logic
);

end InDiff;



architecture structural of InDiff is
 signal s_output_ev : boolean;
 signal s_output_first : std_logic_vector( n - 1 downto 0 );
 signal s_output_second : std_logic_vector( n - 1 downto 0 );

begin
 s_output_first <= input when ( clk'event and clk = '1' ) else s_output_first;

 s_output_second <= 
      s_output_first when ( clk'event and clk = '1' ) else s_output_second;

 s_output_ev <= s_output_first /= s_output_second;
  
 output <= s_output_first;

 output_ev <= '1' when s_output_ev else '0';

end structural;
Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity InFall is
generic( n : integer );
port
(
   clk : in std_logic;
   input : in std_logic_vector( n - 1 downto 0 );
   output : out std_logic_vector( n - 1 downto 0 );
   output_ev : out std_logic
);

end InFall;

architecture structural of InFall is
signal firstStage : std_logic_vector( n - 1 downto 0 );
signal secondStage : std_logic_vector( n - 1 downto 0 );
signal s_output_ev : boolean;
constant zero : std_logic_vector( n - 1 downto 0 ) := ( others => '0' );

begin

 firstStage <= input when ( clk'event and clk = '1' ) else firstStage;
 secondStage <= firstStage when clk'event and clk = '1' else secondStage;

 s_output_ev <= ( secondStage /= firstStage ) and ( firstStage = zero );

 output <= secondStage;
 output_ev <= '1' when s_output_ev else '0'; 

end structural;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity InRise is
generic( n : integer );
port
(
   clk : in std_logic;
   input : in std_logic_vector( n - 1 downto 0 );
   output : out std_logic_vector( n - 1 downto 0 );
   output_ev : out std_logic
);

end InRise;

architecture structural of InRise is
signal firstStage : std_logic_vector( n - 1 downto 0 );
signal secondStage : std_logic_vector( n - 1 downto 0 );
signal s_output_ev : boolean;
constant zero : std_logic_vector( n - 1 downto 0 ) := ( others => '0' );

begin

 firstStage <= input when ( clk'event and clk = '1' ) else firstStage;
 secondStage <= firstStage when clk'event and clk = '1' else secondStage;

 s_output_ev <= ( secondStage /= firstStage ) and ( firstStage /= zero );

 output_ev <= '1' when s_output_ev else '0'; 

 output <= secondStage;

end structural;


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity SRlatch is
port
( 
  s : in std_logic;
  r : in std_logic;
  q : out std_logic
);

end SRlatch;

architecture behavioral of SRlatch is

 signal s_q : std_logic;
 signal s_nq : std_logic;

begin

 s_nq <= s nor s_q;
 s_q  <= r nor s_nq;

 q <= s_q; 

end behavioral;Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity BiDir is
generic( size : integer := 1 );
port
(
    d_out   : in std_logic_vector( size - 1 downto 0 );
    d_sel   : in std_logic_vector( 0 downto 0 );
    d_in    : out std_logic_vector( size - 1  downto 0 );
    d_inout : inout std_logic_vector( size - 1 downto 0 )
); 

end BiDir;

architecture structural of BiDir is

begin

  U1 : for i in 0 to size - 1 generate

   d_inout(i) <= d_out(i) when d_sel = "0" else 'Z';

  end generate;

 d_in <= d_inout;


end structural;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity Zbuffer is
generic( size : integer := 1 );
port
(
  d_out   : out std_logic_vector( size - 1 downto 0 );
  d_sel   : in std_logic
); 
end Zbuffer;

architecture structural of Zbuffer is
begin

  U1 : for i in 0 to size - 1 generate

   d_out(i) <= '0' when d_sel = '0' else 'Z';

  end generate;

end structural;


Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

entity Dreg is
generic( size : integer := 1 );
port
  (
    clk : in  std_logic;
    d   : in  std_logic_vector( size - 1 downto 0 );
    q   : out std_logic_vector( size - 1 downto 0 )
  );
end entity Dreg;

architecture Behavioral of Dreg is  
begin  
 process(clk)
 begin 
    if(rising_edge(clk)) then
       q <= d; 
    end if;       
 end process;  
end Behavioral; 


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY pll IS
  PORT
  (
    inclk0    : IN STD_LOGIC  := '0';
    pllena    : IN STD_LOGIC  := '1';
    areset    : IN STD_LOGIC  := '0';
    c0    : OUT STD_LOGIC ;
    locked    : OUT STD_LOGIC 
  );
END pll;


ARCHITECTURE SYN OF pll IS

  SIGNAL sub_wire0  : STD_LOGIC_VECTOR (5 DOWNTO 0);
  SIGNAL sub_wire1  : STD_LOGIC ;
  SIGNAL sub_wire2  : STD_LOGIC ;
  SIGNAL sub_wire3  : STD_LOGIC ;
  SIGNAL sub_wire4  : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL sub_wire5_bv  : BIT_VECTOR (0 DOWNTO 0);
  SIGNAL sub_wire5  : STD_LOGIC_VECTOR (0 DOWNTO 0);

  COMPONENT altpll
  GENERIC (
    clk0_duty_cycle    : NATURAL;
    lpm_type    : STRING;
    clk0_multiply_by    : NATURAL;
    invalid_lock_multiplier    : NATURAL;
    inclk0_input_frequency    : NATURAL;
    gate_lock_signal    : STRING;
    clk0_divide_by    : NATURAL;
    pll_type    : STRING;
    valid_lock_multiplier    : NATURAL;
    intended_device_family    : STRING;
    operation_mode    : STRING;
    compensate_clock    : STRING;
    clk0_phase_shift    : STRING
  );
  PORT (
      inclk  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      pllena  : IN STD_LOGIC ;
      locked  : OUT STD_LOGIC ;
      areset  : IN STD_LOGIC ;
      clk  : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
  );
  END COMPONENT;

BEGIN
  sub_wire5_bv(0 DOWNTO 0) <= "0";
  sub_wire5    <= To_stdlogicvector(sub_wire5_bv);
  sub_wire1    <= sub_wire0(0);
  c0    <= sub_wire1;
  locked    <= sub_wire2;
  sub_wire3    <= inclk0;
  sub_wire4    <= sub_wire5(0 DOWNTO 0) & sub_wire3;

  altpll_component : altpll
  GENERIC MAP (
    clk0_duty_cycle => 50,
    lpm_type => "altpll",
    clk0_multiply_by => 2,
    invalid_lock_multiplier => 5,
    inclk0_input_frequency => 20000,
    gate_lock_signal => "NO",
    clk0_divide_by => 1,
    pll_type => "FAST",
    valid_lock_multiplier => 1,
    intended_device_family => "Cyclone II",
    operation_mode => "NORMAL",
    compensate_clock => "CLK0",
    clk0_phase_shift => "0"
  )
  PORT MAP (
    inclk => sub_wire4,
    pllena => pllena,
    areset => areset,
    clk => sub_wire0,
    locked => sub_wire2
  );



END SYN;

Library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use work.TerasicDE1SoC.all; 

entity CsramWe is
port
(
  clk_50 : in std_logic;
  we_in : in std_logic;
  we_out : out std_logic
);
end CsramWe;


architecture structural of CsramWe is

signal we_old : std_logic;
signal we_new : std_logic;
signal clk_100 : std_logic;

begin

  Q1 : pll PORT map
  (
      inclk0 => clk_50,
      pllena => '1',
      areset => '0',
      c0  => clk_100, 
      locked => open
   );

  we_new <= we_old when rising_edge( clk_100 ) else we_new;

  we_old <= not we_new when ( we_in = '0' ) else '1';

  we_out <= we_new;

end structural;
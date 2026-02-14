 library   ieee;
 use       ieee.std_logic_1164.all;
 use       ieee.std_logic_unsigned.all;
 use       ieee.std_logic_arith.all;
 use       work.TerasicDE1SoC.all;       
 use       work.TerasicDE1SoCMem.all;       
 use       work.TerasicDE1SoCPll.all;       
 use       work.package_%circuit_name%.all;       
            
entity  %top_circuit_name%   IS
port
(
    clk       : in std_logic;  
    
    Keys      : in  std_logic_vector(3 downto 0);
    Leds      : out std_logic_vector(9 downto 0);
    Switches  : in  std_logic_vector(9 downto 0);
    
    Hex0      : out std_logic_vector(6 downto 0);
    Hex1      : out std_logic_vector(6 downto 0);
    Hex2      : out std_logic_vector(6 downto 0);
    Hex3      : out std_logic_vector(6 downto 0);
    Hex4      : out std_logic_vector(6 downto 0);
    Hex5      : out std_logic_vector(6 downto 0);
    
    VgaR      : out std_logic_vector(7 downto 0);
    VgaG      : out std_logic_vector(7 downto 0);
    VgaB      : out std_logic_vector(7 downto 0);
    VgaClk    : out std_logic;
    VgaBlankN : out std_logic;
    VgaSyncN  : out std_logic;
    VgaHS     : out std_logic;
    VgaVS     : out std_logic;
    
    P0Abus    : inout  std_logic_vector(15 downto 0);
    P0Bbus    : inout  std_logic_vector(15 downto 0);
    P0Cbus    : inout  std_logic_vector(3  downto 0);
    P1Abus    : inout  std_logic_vector(15 downto 0);
    P1Bbus    : inout  std_logic_vector(15 downto 0);
    P1Cbus    : inout  std_logic_vector(3  downto 0);
    
    I2C_Clock  : buffer std_logic;          
    I2C_Data   : inout  std_logic;             
           
    IRDA_RXD   : in  std_logic;          
    IRDA_TXD   : out std_logic;             
           
    AudioMainClock     : buffer std_logic;   -- Declared "buffer" for monitoring
    AudioBitClock      : inout  std_logic;
    AudioDacLRselect   : inout  std_logic;
    AudioDacData       : out    std_logic;
    AudioAdcLRselect   : inout  std_logic;
    AudioAdcData       : in     std_logic

);
end   %top_circuit_name%;
      
      
architecture  %top_circuit_name%_arch  OF  %top_circuit_name%  IS

    signal s_start_ev  : std_logic;     
    signal s_start_evN : std_logic;  
    
    signal s_Keys_in  : std_logic_vector( 3 downto 0 );
    signal s_Keys_out : std_logic_vector( 3 downto 0 );
    
    signal s_Keys : std_logic_vector( 3 downto 0 );             
    signal s_Key0 : std_logic_vector( 0 downto 0 );             
    signal s_Key1 : std_logic_vector( 0 downto 0 );  
    signal s_Key2 : std_logic_vector( 0 downto 0 );             
    signal s_Key3 : std_logic_vector( 0 downto 0 );      
    
    signal s_Key0_ev : std_logic;
    signal s_Key1_ev : std_logic;
    signal s_Key2_ev : std_logic;
    signal s_Key3_ev : std_logic;
    
    signal s_tKey0_ev : std_logic;
    signal s_tKey1_ev : std_logic;
    signal s_tKey2_ev : std_logic;
    signal s_tKey3_ev : std_logic;
    
    -- Latched Key 1 rise event to allow start event generation           
    signal s_LatchedKey1_ev : std_logic;
    signal s_RisingKey1_ev  : std_logic;
    
    -- Small state machine for start event generation:
    --      SEG_Idle:     Wait for Key1 rising
    --      SEG_Key1High: Wait for Key0 falling to generate start event
    --      SEV_Done:     Wait for Key1 falling to reset the state machine
    type   StartEventGen_t is (SEG_Idle, SEG_Key1High, SEV_Done);
    signal StartEventGenState : StartEventGen_t;
    
    signal s_Leds : std_logic_vector( 9 downto 0 );   
    signal s_Led0 : std_logic_vector( 0 downto 0 );   
    signal s_Led1 : std_logic_vector( 0 downto 0 );     
    signal s_Led2 : std_logic_vector( 0 downto 0 );   
    signal s_Led3 : std_logic_vector( 0 downto 0 );   
    signal s_Led4 : std_logic_vector( 0 downto 0 );             
    signal s_Led5 : std_logic_vector( 0 downto 0 );     
    signal s_Led6 : std_logic_vector( 0 downto 0 );     
    signal s_Led7 : std_logic_vector( 0 downto 0 );     
    signal s_Led8 : std_logic_vector( 0 downto 0 );     
    signal s_Led9 : std_logic_vector( 0 downto 0 );     
    
    signal s_Switches: std_logic_vector( 9 downto 0 );   
    signal s_Switch0 : std_logic_vector( 0 downto 0 );   
    signal s_Switch1 : std_logic_vector( 0 downto 0 );     
    signal s_Switch2 : std_logic_vector( 0 downto 0 );   
    signal s_Switch3 : std_logic_vector( 0 downto 0 );   
    signal s_Switch4 : std_logic_vector( 0 downto 0 );             
    signal s_Switch5 : std_logic_vector( 0 downto 0 );     
    signal s_Switch6 : std_logic_vector( 0 downto 0 );     
    signal s_Switch7 : std_logic_vector( 0 downto 0 );     
    signal s_Switch8 : std_logic_vector( 0 downto 0 );     
    signal s_Switch9 : std_logic_vector( 0 downto 0 );     
    
    signal s_Hex0   : std_logic_vector( 6 downto 0 );   
    signal s_Hex0_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex0_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex0_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex0_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex0_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex0_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex0_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex0_7 : std_logic_vector( 0 downto 0 ) := "1";     
    
    signal s_Hex1   : std_logic_vector( 6 downto 0 );   
    signal s_Hex1_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex1_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex1_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex1_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex1_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex1_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex1_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex1_7 : std_logic_vector( 0 downto 0 ) := "1";     
    
    signal s_Hex2   : std_logic_vector( 6 downto 0 );   
    signal s_Hex2_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex2_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex2_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex2_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex2_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex2_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex2_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex2_7 : std_logic_vector( 0 downto 0 ) := "1";     
    
    signal s_Hex3   : std_logic_vector( 6 downto 0 );   
    signal s_Hex3_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex3_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex3_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex3_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex3_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex3_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex3_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex3_7 : std_logic_vector( 0 downto 0 ) := "1";     
    
    signal s_Hex4   : std_logic_vector( 6 downto 0 );   
    signal s_Hex4_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex4_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex4_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex4_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex4_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex4_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex4_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex4_7 : std_logic_vector( 0 downto 0 ) := "1";     
    
    signal s_Hex5   : std_logic_vector( 6 downto 0 );   
    signal s_Hex5_0 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex5_1 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex5_2 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex5_3 : std_logic_vector( 0 downto 0 ) := "1";   
    signal s_Hex5_4 : std_logic_vector( 0 downto 0 ) := "1";             
    signal s_Hex5_5 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex5_6 : std_logic_vector( 0 downto 0 ) := "1";     
    signal s_Hex5_7 : std_logic_vector( 0 downto 0 ) := "1";     

    signal s_VgaR  : std_logic_vector( 7 downto 0 );
    signal s_VgaR0 : std_logic_vector( 0 downto 0 );   
    signal s_VgaR1 : std_logic_vector( 0 downto 0 );     
    signal s_VgaR2 : std_logic_vector( 0 downto 0 );   
    signal s_VgaR3 : std_logic_vector( 0 downto 0 );   
    signal s_VgaR4 : std_logic_vector( 0 downto 0 );             
    signal s_VgaR5 : std_logic_vector( 0 downto 0 );     
    signal s_VgaR6 : std_logic_vector( 0 downto 0 );  
    signal s_VgaR7 : std_logic_vector( 0 downto 0 );  
       
    signal s_VgaG  : std_logic_vector( 7 downto 0 );
    signal s_VgaG0 : std_logic_vector( 0 downto 0 );   
    signal s_VgaG1 : std_logic_vector( 0 downto 0 );     
    signal s_VgaG2 : std_logic_vector( 0 downto 0 );   
    signal s_VgaG3 : std_logic_vector( 0 downto 0 );   
    signal s_VgaG4 : std_logic_vector( 0 downto 0 );             
    signal s_VgaG5 : std_logic_vector( 0 downto 0 );     
    signal s_VgaG6 : std_logic_vector( 0 downto 0 );  
    signal s_VgaG7 : std_logic_vector( 0 downto 0 );  
       
    signal s_VgaB  : std_logic_vector( 7 downto 0 );
    signal s_VgaB0 : std_logic_vector( 0 downto 0 );   
    signal s_VgaB1 : std_logic_vector( 0 downto 0 );     
    signal s_VgaB2 : std_logic_vector( 0 downto 0 );   
    signal s_VgaB3 : std_logic_vector( 0 downto 0 );   
    signal s_VgaB4 : std_logic_vector( 0 downto 0 );             
    signal s_VgaB5 : std_logic_vector( 0 downto 0 );     
    signal s_VgaB6 : std_logic_vector( 0 downto 0 );  
    signal s_VgaB7 : std_logic_vector( 0 downto 0 );         
    
    signal s_VgaClk    : std_logic_vector( 0 downto 0 );
    signal s_VgaClk0   : std_logic_vector( 0 downto 0 );
    signal s_VgaBlankN : std_logic_vector( 0 downto 0 );
    signal s_VgaBlankN0: std_logic_vector( 0 downto 0 );
    signal s_VgaSyncN  : std_logic_vector( 0 downto 0 );
    signal s_VgaSyncN0 : std_logic_vector( 0 downto 0 );
    signal s_VgaHS     : std_logic_vector( 0 downto 0 );
    signal s_VgaHS0    : std_logic_vector( 0 downto 0 );
    signal s_VgaVS     : std_logic_vector( 0 downto 0 );
    signal s_VgaVS0    : std_logic_vector( 0 downto 0 );
    
-- iP0Abus            
     signal s_iP0Abus : std_logic_vector( 15 downto 0 );  
-- oP0Abus            
     signal s_oP0Abus : std_logic_vector( 15 downto 0 ) := (others => 'Z');   

-- iP0Abus individual pins     
     signal s_iP0A0  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A1  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A2  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A3  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A4  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A5  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A6  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A7  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A8  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A9  : std_logic_vector( 0 downto 0 );      
     signal s_iP0A10 : std_logic_vector( 0 downto 0 );      
     signal s_iP0A11 : std_logic_vector( 0 downto 0 );      
     signal s_iP0A12 : std_logic_vector( 0 downto 0 );      
     signal s_iP0A13 : std_logic_vector( 0 downto 0 );      
     signal s_iP0A14 : std_logic_vector( 0 downto 0 );      
     signal s_iP0A15 : std_logic_vector( 0 downto 0 );     
     
-- oP0Abus individual pins, high Z if not used0       
     signal s_oP0A0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A4  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A5  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A6  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A7  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A8  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A9  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A10 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A11 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A12 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A13 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A14 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0A15 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- iP0Bbus            
     signal s_iP0Bbus : std_logic_vector( 15 downto 0 );  
-- oP0Bbus            
     signal s_oP0Bbus : std_logic_vector( 15 downto 0 ) := (others => 'Z');   

-- iP0Bbus individual pins     
     signal s_iP0B0  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B1  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B2  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B3  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B4  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B5  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B6  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B7  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B8  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B9  : std_logic_vector( 0 downto 0 );      
     signal s_iP0B10 : std_logic_vector( 0 downto 0 );      
     signal s_iP0B11 : std_logic_vector( 0 downto 0 );      
     signal s_iP0B12 : std_logic_vector( 0 downto 0 );      
     signal s_iP0B13 : std_logic_vector( 0 downto 0 );      
     signal s_iP0B14 : std_logic_vector( 0 downto 0 );      
     signal s_iP0B15 : std_logic_vector( 0 downto 0 );     
     
-- oP0Bbus individual pins, high Z if not used0       
     signal s_oP0B0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B4  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B5  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B6  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B7  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B8  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B9  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B10 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B11 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B12 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B13 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B14 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0B15 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- iP0Cbus            
     signal s_iP0Cbus : std_logic_vector( 3 downto 0 );  
-- oP0Cbus            
     signal s_oP0Cbus : std_logic_vector( 3 downto 0 ) := (others => 'Z');   

-- iP0Cbus individual pins     
     signal s_iP0C0  : std_logic_vector( 0 downto 0 );      
     signal s_iP0C1  : std_logic_vector( 0 downto 0 );      
     signal s_iP0C2  : std_logic_vector( 0 downto 0 );      
     signal s_iP0C3  : std_logic_vector( 0 downto 0 );      
     
-- oP0Cbus individual pins, high Z if not used0       
     signal s_oP0C0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0C1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0C2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP0C3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- iP1Abus            
     signal s_iP1Abus : std_logic_vector( 15 downto 0 );  
-- oP1Abus            
     signal s_oP1Abus : std_logic_vector( 15 downto 0 ) := (others => 'Z');   

-- iP1Abus individual pins     
     signal s_iP1A0  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A1  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A2  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A3  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A4  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A5  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A6  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A7  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A8  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A9  : std_logic_vector( 0 downto 0 );      
     signal s_iP1A10 : std_logic_vector( 0 downto 0 );      
     signal s_iP1A11 : std_logic_vector( 0 downto 0 );      
     signal s_iP1A12 : std_logic_vector( 0 downto 0 );      
     signal s_iP1A13 : std_logic_vector( 0 downto 0 );      
     signal s_iP1A14 : std_logic_vector( 0 downto 0 );      
     signal s_iP1A15 : std_logic_vector( 0 downto 0 );     
     
-- oP1Abus individual pins, high Z if not used       
     signal s_oP1A0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A4  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A5  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A6  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A7  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A8  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A9  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A10 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A11 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A12 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A13 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A14 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1A15 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- iP1Bbus            
     signal s_iP1Bbus : std_logic_vector( 15 downto 0 );  
-- oP1Bbus            
     signal s_oP1Bbus : std_logic_vector( 15 downto 0 ) := (others => 'Z');   

-- iP1Bbus individual pins     
     signal s_iP1B0  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B1  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B2  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B3  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B4  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B5  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B6  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B7  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B8  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B9  : std_logic_vector( 0 downto 0 );      
     signal s_iP1B10 : std_logic_vector( 0 downto 0 );      
     signal s_iP1B11 : std_logic_vector( 0 downto 0 );      
     signal s_iP1B12 : std_logic_vector( 0 downto 0 );      
     signal s_iP1B13 : std_logic_vector( 0 downto 0 );      
     signal s_iP1B14 : std_logic_vector( 0 downto 0 );      
     signal s_iP1B15 : std_logic_vector( 0 downto 0 );     
     
-- oP1Bbus individual pins, high Z if not used0       
     signal s_oP1B0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B4  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B5  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B6  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B7  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B8  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B9  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B10 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B11 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B12 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B13 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B14 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1B15 : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- iP1Cbus            
     signal s_iP1Cbus : std_logic_vector( 3 downto 0 );  
-- oP1Cbus            
     signal s_oP1Cbus : std_logic_vector( 3 downto 0 ) := (others => 'Z');   

-- iP1Cbus individual pins     
     signal s_iP1C0  : std_logic_vector( 0 downto 0 );      
     signal s_iP1C1  : std_logic_vector( 0 downto 0 );      
     signal s_iP1C2  : std_logic_vector( 0 downto 0 );      
     signal s_iP1C3  : std_logic_vector( 0 downto 0 );      
     
-- oP1Cbus individual pins, high Z if not used0       
     signal s_oP1C0  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1C1  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1C2  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      
     signal s_oP1C3  : std_logic_vector( 0 downto 0 ) := (others => 'Z');      

-- Memory bank signals
     signal s_DPmemClock    : std_logic;
     
-- Bank A 32Kx32
     signal s_Command_AL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_AL_ev : std_logic;      
     signal s_Address_ALx   : std_logic_vector( 14 downto 0 ); 
     signal s_Address_AL    : std_logic_vector( 13 downto 0 ); 
     signal s_DataW_AL      : std_logic_vector( 31 downto 0 );     
     signal s_DataR_AL      : std_logic_vector( 31 downto 0 );    
     signal s_DataR_AL_ev   : std_logic;  
     signal s_DataW_Ene_AL  : std_logic;
     signal s_DataR_Ene_AL  : std_logic;
     signal s_SelectH_AL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_AH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_AH_ev : std_logic;      
     signal s_Address_AHx   : std_logic_vector( 14 downto 0 ); 
     signal s_Address_AH    : std_logic_vector( 13 downto 0 ); 
     signal s_DataW_AH      : std_logic_vector( 31 downto 0 );     
     signal s_DataR_AH      : std_logic_vector( 31 downto 0 );    
     signal s_DataR_AH_ev   : std_logic;  
     signal s_DataW_Ene_AH  : std_logic;
     signal s_DataR_Ene_AH  : std_logic;
     signal s_SelectH_AH    : std_logic_vector( 0 downto 0 ) := "1";
   
-- Bank B 64Kx16
     signal s_Command_BL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_BL_ev : std_logic;      
     signal s_Address_BLx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_BL    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_BL      : std_logic_vector( 15 downto 0 );     
     signal s_DataR_BL      : std_logic_vector( 15 downto 0 );    
     signal s_DataR_BL_ev   : std_logic;  
     signal s_DataW_Ene_BL  : std_logic;
     signal s_DataR_Ene_BL  : std_logic;
     signal s_SelectH_BL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_BH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_BH_ev : std_logic;      
     signal s_Address_BHx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_BH    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_BH      : std_logic_vector( 15 downto 0 );     
     signal s_DataR_BH      : std_logic_vector( 15 downto 0 );    
     signal s_DataR_BH_ev   : std_logic;  
     signal s_DataW_Ene_BH  : std_logic;
     signal s_DataR_Ene_BH  : std_logic;
     signal s_SelectH_BH    : std_logic_vector( 0 downto 0 ) := "1";
   
-- Bank C 64Kx8
     signal s_Command_CL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_CL_ev : std_logic;      
     signal s_Address_CLx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_CL    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_CL      : std_logic_vector( 7 downto 0 );     
     signal s_DataR_CL      : std_logic_vector( 7 downto 0 );    
     signal s_DataR_CL_ev   : std_logic;  
     signal s_DataW_Ene_CL  : std_logic;
     signal s_DataR_Ene_CL  : std_logic;
     signal s_SelectH_CL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_CH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_CH_ev : std_logic;      
     signal s_Address_CHx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_CH    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_CH      : std_logic_vector( 7 downto 0 );     
     signal s_DataR_CH      : std_logic_vector( 7 downto 0 );    
     signal s_DataR_CH_ev   : std_logic;  
     signal s_DataW_Ene_CH  : std_logic;
     signal s_DataR_Ene_CH  : std_logic;
     signal s_SelectH_CH    : std_logic_vector( 0 downto 0 ) := "1";
   
-- Bank D 64Kx8
     signal s_Command_DL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_DL_ev : std_logic;      
     signal s_Address_DLx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_DL    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_DL      : std_logic_vector( 7 downto 0 );     
     signal s_DataR_DL      : std_logic_vector( 7 downto 0 );    
     signal s_DataR_DL_ev   : std_logic;  
     signal s_DataW_Ene_DL  : std_logic;
     signal s_DataR_Ene_DL  : std_logic;
     signal s_SelectH_DL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_DH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_DH_ev : std_logic;      
     signal s_Address_DHx   : std_logic_vector( 15 downto 0 ); 
     signal s_Address_DH    : std_logic_vector( 14 downto 0 ); 
     signal s_DataW_DH      : std_logic_vector( 7 downto 0 );     
     signal s_DataR_DH      : std_logic_vector( 7 downto 0 );    
     signal s_DataR_DH_ev   : std_logic;  
     signal s_DataW_Ene_DH  : std_logic;
     signal s_DataR_Ene_DH  : std_logic;
     signal s_SelectH_DH    : std_logic_vector( 0 downto 0 ) := "1";
   
-- Bank E 16Kx4
     signal s_Command_EL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_EL_ev : std_logic;      
     signal s_Address_ELx   : std_logic_vector( 13 downto 0 ); 
     signal s_Address_EL    : std_logic_vector( 12 downto 0 ); 
     signal s_DataW_EL      : std_logic_vector( 3 downto 0 );     
     signal s_DataR_EL      : std_logic_vector( 3 downto 0 );    
     signal s_DataR_EL_ev   : std_logic;  
     signal s_DataW_Ene_EL  : std_logic;
     signal s_DataR_Ene_EL  : std_logic;
     signal s_SelectH_EL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_EH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_EH_ev : std_logic;      
     signal s_Address_EHx   : std_logic_vector( 13 downto 0 ); 
     signal s_Address_EH    : std_logic_vector( 12 downto 0 ); 
     signal s_DataW_EH      : std_logic_vector( 3 downto 0 );     
     signal s_DataR_EH      : std_logic_vector( 3 downto 0 );    
     signal s_DataR_EH_ev   : std_logic;  
     signal s_DataW_Ene_EH  : std_logic;
     signal s_DataR_Ene_EH  : std_logic;
     signal s_SelectH_EH    : std_logic_vector( 0 downto 0 ) := "1";
   
-- Bank F 32Kx1
     signal s_Command_FL    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_FL_ev : std_logic;      
     signal s_Address_FLx   : std_logic_vector( 14 downto 0 ); 
     signal s_Address_FL    : std_logic_vector( 13 downto 0 ); 
     signal s_DataW_FL      : std_logic_vector( 0 downto 0 );     
     signal s_DataR_FL      : std_logic_vector( 0 downto 0 );    
     signal s_DataR_FL_ev   : std_logic;  
     signal s_DataW_Ene_FL  : std_logic;
     signal s_DataR_Ene_FL  : std_logic;
     signal s_SelectH_FL    : std_logic_vector( 0 downto 0 ) := "0";
   
     signal s_Command_FH    : std_logic_vector( 1 downto 0 ); 
     signal s_Command_FH_ev : std_logic;      
     signal s_Address_FHx   : std_logic_vector( 14 downto 0 ); 
     signal s_Address_FH    : std_logic_vector( 13 downto 0 ); 
     signal s_DataW_FH      : std_logic_vector( 0 downto 0 );     
     signal s_DataR_FH      : std_logic_vector( 0 downto 0 );    
     signal s_DataR_FH_ev   : std_logic;  
     signal s_DataW_Ene_FH  : std_logic;
     signal s_DataR_Ene_FH  : std_logic;
     signal s_SelectH_FH    : std_logic_vector( 0 downto 0 ) := "1";
   

-- Audio/Video config signals
    signal s_I2C_Clock  : std_logic_vector( 0 downto 0 ) := (others => 'Z');          
    signal s_I2C_Clock0 : std_logic_vector( 0 downto 0 );          
    signal s_I2C_Data   : std_logic_vector( 0 downto 0 ) := (others => 'Z');             
    signal s_I2C_Data0  : std_logic_vector( 0 downto 0 );             
    signal s_I2C_Reset  : std_logic_vector( 0 downto 0 );             
    signal s_I2C_Reset0 : std_logic_vector( 0 downto 0 );             
           
-- Audio signals
    signal s_AudioMainClock     : std_logic_vector( 0 downto 0 ) := (others => 'Z');
    signal s_AudioMainClock0    : std_logic_vector( 0 downto 0 );
    signal s_AudioBitClock      : std_logic_vector( 0 downto 0 ) := (others => 'Z');
    signal s_AudioBitClock0     : std_logic_vector( 0 downto 0 );
    signal s_AudioDacLRselect   : std_logic_vector( 0 downto 0 ) := (others => 'Z');
    signal s_AudioDacLRselect0  : std_logic_vector( 0 downto 0 );
    signal s_AudioDacData       : std_logic_vector( 0 downto 0 ) := (others => 'Z');
    signal s_AudioDacData0      : std_logic_vector( 0 downto 0 );
    signal s_AudioAdcLRselect   : std_logic_vector( 0 downto 0 ) := (others => 'Z');
    signal s_AudioAdcLRselect0  : std_logic_vector( 0 downto 0 );
    signal s_AudioAdcData       : std_logic_vector( 0 downto 0 );
    signal s_AudioAdcData0      : std_logic_vector( 0 downto 0 );

-- IR signals
    signal s_IRDA_RXD  : std_logic_vector( 0 downto 0 );             
    signal s_IRDA_RXD0 : std_logic_vector( 0 downto 0 );             
    signal s_IRDA_TXD  : std_logic_vector( 0 downto 0 );             
    signal s_IRDA_TXD0 : std_logic_vector( 0 downto 0 );             

    SIGNAL rst :    std_logic := '0';
 	SIGNAL memclk : std_logic;
	SIGNAL locked : std_logic;

    COMPONENT MemClkPLL
	 PORT 
    (
	    outclk_0 : OUT STD_LOGIC;
	    refclk :   IN  STD_LOGIC;
	    rst :      IN  STD_LOGIC
	 );
    END COMPONENT;


-- main signals 
    
%user_signals%
    
%unit_signals%      

begin  

%join_code%   
    
%assign_sr_out_ev%
    PLL : MemClkPLL
    PORT MAP
    (
        outclk_0 => memclk,
        refclk   => clk,
        rst      => rst
    );

    s_port_Keys_ev_buffer_0 : InFall
    generic map(1)
    port map
    (
        clk       => clk,
        input     => s_Keys_in(0 downto 0),
        output    => s_Keys_out(0 downto 0),
        output_ev => s_tKey0_ev
    );              
    
    s_port_Keys_ev_buffer_1 : InFall
    generic map(1)
    port map
    (
        clk       => clk,
        input     => s_Keys_in(1 downto 1),
        output    => s_Keys_out(1 downto 1),
        output_ev => s_tKey1_ev
    );  
    
    s_port_Keys_ev_buffer_2 : InFall
    generic map(1)
    port map
    (
        clk       => clk,
        input     => s_Keys_in(2 downto 2),
        output    => s_Keys_out(2 downto 2),
        output_ev => s_tKey2_ev
    );  
    
    s_port_Keys_ev_buffer_3 : InFall
    generic map(1)
    port map
    (
        clk       => clk,
        input     => s_Keys_in(3 downto 3),
        output    => s_Keys_out(3 downto 3),
        output_ev => s_tKey3_ev
    );  
     
    -- Detect rising of Key 1 to enable start event
    s_port_Keys_ev_buffer_1R : InRise
    generic map(1)
    port map
    (
        clk       => clk,
        input     => s_Keys_in(1 downto 1),
        output    => open,
        output_ev => s_RisingKey1_ev
    );  
    
     s_Keys_in <= not Keys;
     s_Keys    <= s_Keys_out;
            
    -- StartEventGen_t is (SEG_Idle, SEG_Key1High, SEV_Done);
     process(clk)
     begin
        if rising_edge(clk) then
            case StartEventGenState is
               when SEG_Idle =>
                  if s_RisingKey1_ev = '1' then 
                      StartEventGenState <= SEG_Key1High;  
                  end if;   
               when SEG_Key1High =>
                  if s_tKey0_ev = '1' then 
                      StartEventGenState <= SEV_Done;  
                  end if;
                  if s_tKey1_ev = '1' then 
                      StartEventGenState <= SEG_Idle;  
                  end if;
               when SEV_Done =>
                  if s_tKey1_ev = '1' then 
                      StartEventGenState <= SEG_Idle;  
                  end if;   
               when others => 
                  StartEventGenState <= SEG_Idle;    
            end case;
         end if;
     end process;
                                                                   
     -- Generate the start event
     s_start_ev  <= '1' when (StartEventGenState = SEG_Key1High) AND s_tKey0_ev = '1' else '0';  
     s_start_evN <= not s_start_ev;
     
     s_Key0_ev  <= '0' when (s_start_ev = '1') else s_tKey0_ev;  
     s_Key1_ev  <= '0' when (s_start_ev = '1') OR (StartEventGenState = SEV_Done) else s_tKey1_ev; 
     s_Key2_ev  <= '0' when (s_start_ev = '1') else s_tKey2_ev;   
     s_Key3_ev  <= '0' when (s_start_ev = '1') else s_tKey3_ev;               

     s_Key0(0)  <= s_Keys(0);  
     s_Key1(0)  <= s_Keys(1); 
     s_Key2(0)  <= s_Keys(2);   
     s_Key3(0)  <= s_Keys(3);               

     s_Switch0(0) <= s_Switches(0);  
     s_Switch1(0) <= s_Switches(1); 
     s_Switch2(0) <= s_Switches(2);   
     s_Switch3(0) <= s_Switches(3); 
     s_Switch4(0) <= s_Switches(4); 
     s_Switch5(0) <= s_Switches(5); 
     s_Switch6(0) <= s_Switches(6); 
     s_Switch7(0) <= s_Switches(7); 
     s_Switch8(0) <= s_Switches(8); 
     s_Switch9(0) <= s_Switches(9); 
       
     s_Switches <= Switches;
  
     s_Leds(0) <= s_Led0(0);
     s_Leds(1) <= s_Led1(0);
     s_Leds(2) <= s_Led2(0);
     s_Leds(3) <= s_Led3(0);
     s_Leds(4) <= s_Led4(0);
     s_Leds(5) <= s_Led5(0);
     s_Leds(6) <= s_Led6(0);
     s_Leds(7) <= s_Led7(0);
     s_Leds(8) <= s_Led8(0);
     s_Leds(9) <= s_Led9(0);
      
     Leds <= s_Leds;
     
     s_Hex0(0) <= s_Hex0_0(0);
     s_Hex0(1) <= s_Hex0_1(0);
     s_Hex0(2) <= s_Hex0_2(0);
     s_Hex0(3) <= s_Hex0_3(0);
     s_Hex0(4) <= s_Hex0_4(0);
     s_Hex0(5) <= s_Hex0_5(0);
     s_Hex0(6) <= s_Hex0_6(0);
      
     Hex0 <= s_Hex0;

     
     s_Hex1(0) <= s_Hex1_0(0);
     s_Hex1(1) <= s_Hex1_1(0);
     s_Hex1(2) <= s_Hex1_2(0);
     s_Hex1(3) <= s_Hex1_3(0);
     s_Hex1(4) <= s_Hex1_4(0);
     s_Hex1(5) <= s_Hex1_5(0);
     s_Hex1(6) <= s_Hex1_6(0);
      
     Hex1 <= s_Hex1;
     
     s_Hex2(0) <= s_Hex2_0(0);
     s_Hex2(1) <= s_Hex2_1(0);
     s_Hex2(2) <= s_Hex2_2(0);
     s_Hex2(3) <= s_Hex2_3(0);
     s_Hex2(4) <= s_Hex2_4(0);
     s_Hex2(5) <= s_Hex2_5(0);
     s_Hex2(6) <= s_Hex2_6(0);
      
     Hex2 <= s_Hex2;
     
     s_Hex3(0) <= s_Hex3_0(0);
     s_Hex3(1) <= s_Hex3_1(0);
     s_Hex3(2) <= s_Hex3_2(0);
     s_Hex3(3) <= s_Hex3_3(0);
     s_Hex3(4) <= s_Hex3_4(0);
     s_Hex3(5) <= s_Hex3_5(0);
     s_Hex3(6) <= s_Hex3_6(0);
      
     Hex3 <= s_Hex3;
     
     s_Hex4(0) <= s_Hex4_0(0);
     s_Hex4(1) <= s_Hex4_1(0);
     s_Hex4(2) <= s_Hex4_2(0);
     s_Hex4(3) <= s_Hex4_3(0);
     s_Hex4(4) <= s_Hex4_4(0);
     s_Hex4(5) <= s_Hex4_5(0);
     s_Hex4(6) <= s_Hex4_6(0);
      
     Hex4 <= s_Hex4;
     
     s_Hex5(0) <= s_Hex5_0(0);
     s_Hex5(1) <= s_Hex5_1(0);
     s_Hex5(2) <= s_Hex5_2(0);
     s_Hex5(3) <= s_Hex5_3(0);
     s_Hex5(4) <= s_Hex5_4(0);
     s_Hex5(5) <= s_Hex5_5(0);
     s_Hex5(6) <= s_Hex5_6(0);
      
     Hex5 <= s_Hex5;
        
     s_VgaR(0) <= s_VgaR0(0);
     s_VgaR(1) <= s_VgaR1(0);
     s_VgaR(2) <= s_VgaR2(0);
     s_VgaR(3) <= s_VgaR3(0);
     s_VgaR(4) <= s_VgaR4(0);
     s_VgaR(5) <= s_VgaR5(0);
     s_VgaR(6) <= s_VgaR6(0);
     s_VgaR(7) <= s_VgaR7(0);
     
     VgaR <= s_VgaR;

     s_VgaG(0) <= s_VgaG0(0);
     s_VgaG(1) <= s_VgaG1(0);
     s_VgaG(2) <= s_VgaG2(0);
     s_VgaG(3) <= s_VgaG3(0);
     s_VgaG(4) <= s_VgaG4(0);
     s_VgaG(5) <= s_VgaG5(0);
     s_VgaG(6) <= s_VgaG6(0);
     s_VgaG(7) <= s_VgaG7(0);
     
     VgaG <= s_VgaG;

     s_VgaB(0) <= s_VgaB0(0);
     s_VgaB(1) <= s_VgaB1(0);
     s_VgaB(2) <= s_VgaB2(0);
     s_VgaB(3) <= s_VgaB3(0);
     s_VgaB(4) <= s_VgaB4(0);
     s_VgaB(5) <= s_VgaB5(0);
     s_VgaB(6) <= s_VgaB6(0);
     s_VgaB(7) <= s_VgaB7(0);
     
     VgaB <= s_VgaB;

     VgaClk    <= s_VgaClk(0);
     VgaBlankN <= s_VgaBlankN(0);
     VgaSyncN  <= s_VgaSyncN(0);
     VgaHS     <= s_VgaHS(0);
     VgaVS     <= s_VgaVS(0);
     
     s_VgaClk(0)    <= s_VgaClk0(0);
     s_VgaBlankN(0) <= s_VgaBlankN0(0);
     s_VgaSyncN(0)  <= s_VgaSyncN0(0);
     s_VgaHS(0)     <= s_VgaHS0(0);
     s_VgaVS(0)     <= s_VgaVS0(0);
            
     -- P0Abus as output port 
     P0Abus <= s_oP0Abus;

     s_oP0Abus(0)  <= s_oP0A0(0);     
     s_oP0Abus(1)  <= s_oP0A1(0);
     s_oP0Abus(2)  <= s_oP0A2(0);
     s_oP0Abus(3)  <= s_oP0A3(0);
     s_oP0Abus(4)  <= s_oP0A4(0);
     s_oP0Abus(5)  <= s_oP0A5(0);
     s_oP0Abus(6)  <= s_oP0A6(0);
     s_oP0Abus(7)  <= s_oP0A7(0);
     s_oP0Abus(8)  <= s_oP0A8(0);
     s_oP0Abus(9)  <= s_oP0A9(0);
     s_oP0Abus(10) <= s_oP0A10(0);
     s_oP0Abus(11) <= s_oP0A11(0);
     s_oP0Abus(12) <= s_oP0A12(0);
     s_oP0Abus(13) <= s_oP0A13(0);
     s_oP0Abus(14) <= s_oP0A14(0);
     s_oP0Abus(15) <= s_oP0A15(0);
     
     -- P0Abus as input port 
     s_iP0Abus <= P0Abus;
     
     s_iP0A0(0)  <= s_iP0Abus(0);
     s_iP0A1(0)  <= s_iP0Abus(1);
     s_iP0A2(0)  <= s_iP0Abus(2);
     s_iP0A3(0)  <= s_iP0Abus(3);
     s_iP0A4(0)  <= s_iP0Abus(4);
     s_iP0A5(0)  <= s_iP0Abus(5);
     s_iP0A6(0)  <= s_iP0Abus(6);
     s_iP0A7(0)  <= s_iP0Abus(7);
     s_iP0A8(0)  <= s_iP0Abus(8);
     s_iP0A9(0)  <= s_iP0Abus(9);
     s_iP0A10(0) <= s_iP0Abus(10);
     s_iP0A11(0) <= s_iP0Abus(11);
     s_iP0A12(0) <= s_iP0Abus(12);
     s_iP0A13(0) <= s_iP0Abus(13);
     s_iP0A14(0) <= s_iP0Abus(14);
     s_iP0A15(0) <= s_iP0Abus(15);
          
     -- P0Bbus as output port 
     P0Bbus <= s_oP0Bbus;

     s_oP0Bbus(0)  <= s_oP0B0(0);     
     s_oP0Bbus(1)  <= s_oP0B1(0);
     s_oP0Bbus(2)  <= s_oP0B2(0);
     s_oP0Bbus(3)  <= s_oP0B3(0);
     s_oP0Bbus(4)  <= s_oP0B4(0);
     s_oP0Bbus(5)  <= s_oP0B5(0);
     s_oP0Bbus(6)  <= s_oP0B6(0);
     s_oP0Bbus(7)  <= s_oP0B7(0);
     s_oP0Bbus(8)  <= s_oP0B8(0);
     s_oP0Bbus(9)  <= s_oP0B9(0);
     s_oP0Bbus(10) <= s_oP0B10(0);
     s_oP0Bbus(11) <= s_oP0B11(0);
     s_oP0Bbus(12) <= s_oP0B12(0);
     s_oP0Bbus(13) <= s_oP0B13(0);
     s_oP0Bbus(14) <= s_oP0B14(0);
     s_oP0Bbus(15) <= s_oP0B15(0);
     
     -- P0Bbus as input port 
     s_iP0Bbus <= P0Bbus;
     
     s_iP0B0(0)  <= s_iP0Bbus(0);
     s_iP0B1(0)  <= s_iP0Bbus(1);
     s_iP0B2(0)  <= s_iP0Bbus(2);
     s_iP0B3(0)  <= s_iP0Bbus(3);
     s_iP0B4(0)  <= s_iP0Bbus(4);
     s_iP0B5(0)  <= s_iP0Bbus(5);
     s_iP0B6(0)  <= s_iP0Bbus(6);
     s_iP0B7(0)  <= s_iP0Bbus(7);
     s_iP0B8(0)  <= s_iP0Bbus(8);
     s_iP0B9(0)  <= s_iP0Bbus(9);
     s_iP0B10(0) <= s_iP0Bbus(10);
     s_iP0B11(0) <= s_iP0Bbus(11);
     s_iP0B12(0) <= s_iP0Bbus(12);
     s_iP0B13(0) <= s_iP0Bbus(13);
     s_iP0B14(0) <= s_iP0Bbus(14);
     s_iP0B15(0) <= s_iP0Bbus(15);
          
     -- P0Cbus as output port 
     P0Cbus <= s_oP0Cbus;

     s_oP0Cbus(0)  <= s_oP0C0(0);     
     s_oP0Cbus(1)  <= s_oP0C1(0);
     s_oP0Cbus(2)  <= s_oP0C2(0);
     s_oP0Cbus(3)  <= s_oP0C3(0);
     
     -- P0Cbus as input port 
     s_iP0Cbus <= P0Cbus;
     
     s_iP0C0(0)  <= s_iP0Cbus(0);
     s_iP0C1(0)  <= s_iP0Cbus(1);
     s_iP0C2(0)  <= s_iP0Cbus(2);
     s_iP0C3(0)  <= s_iP0Cbus(3);         

     -- P1Abus as output port 
     P1Abus <= s_oP1Abus;

     s_oP1Abus(0)  <= s_oP1A0(0);     
     s_oP1Abus(1)  <= s_oP1A1(0);
     s_oP1Abus(2)  <= s_oP1A2(0);
     s_oP1Abus(3)  <= s_oP1A3(0);
     s_oP1Abus(4)  <= s_oP1A4(0);
     s_oP1Abus(5)  <= s_oP1A5(0);
     s_oP1Abus(6)  <= s_oP1A6(0);
     s_oP1Abus(7)  <= s_oP1A7(0);
     s_oP1Abus(8)  <= s_oP1A8(0);
     s_oP1Abus(9)  <= s_oP1A9(0);
     s_oP1Abus(10) <= s_oP1A10(0);
     s_oP1Abus(11) <= s_oP1A11(0);
     s_oP1Abus(12) <= s_oP1A12(0);
     s_oP1Abus(13) <= s_oP1A13(0);
     s_oP1Abus(14) <= s_oP1A14(0);
     s_oP1Abus(15) <= s_oP1A15(0);
     
     -- P1Abus as input port 
     s_iP1Abus <= P1Abus;
     
     s_iP1A0(0)  <= s_iP1Abus(0);
     s_iP1A1(0)  <= s_iP1Abus(1);
     s_iP1A2(0)  <= s_iP1Abus(2);
     s_iP1A3(0)  <= s_iP1Abus(3);
     s_iP1A4(0)  <= s_iP1Abus(4);
     s_iP1A5(0)  <= s_iP1Abus(5);
     s_iP1A6(0)  <= s_iP1Abus(6);
     s_iP1A7(0)  <= s_iP1Abus(7);
     s_iP1A8(0)  <= s_iP1Abus(8);
     s_iP1A9(0)  <= s_iP1Abus(9);
     s_iP1A10(0) <= s_iP1Abus(10);
     s_iP1A11(0) <= s_iP1Abus(11);
     s_iP1A12(0) <= s_iP1Abus(12);
     s_iP1A13(0) <= s_iP1Abus(13);
     s_iP1A14(0) <= s_iP1Abus(14);
     s_iP1A15(0) <= s_iP1Abus(15);
          
     -- P1Bbus as output port 
     P1Bbus <= s_oP1Bbus;

     s_oP1Bbus(0)  <= s_oP1B0(0);                      
     s_oP1Bbus(1)  <= s_oP1B1(0);
     s_oP1Bbus(2)  <= s_oP1B2(0);
     s_oP1Bbus(3)  <= s_oP1B3(0);
     s_oP1Bbus(4)  <= s_oP1B4(0);
     s_oP1Bbus(5)  <= s_oP1B5(0);
     s_oP1Bbus(6)  <= s_oP1B6(0);
     s_oP1Bbus(7)  <= s_oP1B7(0);
     s_oP1Bbus(8)  <= s_oP1B8(0);
     s_oP1Bbus(9)  <= s_oP1B9(0);
     s_oP1Bbus(10) <= s_oP1B10(0);
     s_oP1Bbus(11) <= s_oP1B11(0);
     s_oP1Bbus(12) <= s_oP1B12(0);
     s_oP1Bbus(13) <= s_oP1B13(0);
     s_oP1Bbus(14) <= s_oP1B14(0);
     s_oP1Bbus(15) <= s_oP1B15(0);
     
     -- P1Bbus as input port 
     s_iP1Bbus <= P1Bbus;
     
     s_iP1B0(0)  <= s_iP1Bbus(0);
     s_iP1B1(0)  <= s_iP1Bbus(1);
     s_iP1B2(0)  <= s_iP1Bbus(2);
     s_iP1B3(0)  <= s_iP1Bbus(3);
     s_iP1B4(0)  <= s_iP1Bbus(4);
     s_iP1B5(0)  <= s_iP1Bbus(5);
     s_iP1B6(0)  <= s_iP1Bbus(6);
     s_iP1B7(0)  <= s_iP1Bbus(7);
     s_iP1B8(0)  <= s_iP1Bbus(8);
     s_iP1B9(0)  <= s_iP1Bbus(9);
     s_iP1B10(0) <= s_iP1Bbus(10);
     s_iP1B11(0) <= s_iP1Bbus(11);
     s_iP1B12(0) <= s_iP1Bbus(12);
     s_iP1B13(0) <= s_iP1Bbus(13);
     s_iP1B14(0) <= s_iP1Bbus(14);
     s_iP1B15(0) <= s_iP1Bbus(15);
          
     -- P1Cbus as output port 
     P1Cbus <= s_oP1Cbus;

     s_oP1Cbus(0)  <= s_oP1C0(0);     
     s_oP1Cbus(1)  <= s_oP1C1(0);
     s_oP1Cbus(2)  <= s_oP1C2(0);
     s_oP1Cbus(3)  <= s_oP1C3(0);
     
     -- P1Cbus as input port 
     s_iP1Cbus  <= P1Cbus;
     
     s_iP1C0(0)  <= s_iP1Cbus(0);
     s_iP1C1(0)  <= s_iP1Cbus(1);
     s_iP1C2(0)  <= s_iP1Cbus(2);
     s_iP1C3(0)  <= s_iP1Cbus(3);      
     
    -----------------------------------------
    -- Memory bank clock
    ----------------------------------------- 
    s_DPmemClock <= clk;
    
    -----------------------------------------
    -- Memory bank A 32Kx32 : AL and AH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_AL <= s_Command_AL_ev when s_Command_AL = "10" else '0';
    s_DataW_Ene_AH <= s_Command_AH_ev when s_Command_AH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_AL <= s_Command_AL_ev when s_Command_AL = "01" else '0';
    s_DataR_Ene_AH <= s_Command_AH_ev when s_Command_AH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_ALx(13 downto 0)  <= s_Address_AL;
    s_Address_ALx(14 downto 14) <= s_SelectH_AL;
    s_Address_AHx(13 downto 0)  <= s_Address_AH;
    s_Address_AHx(14 downto 14) <= s_SelectH_AH;
    
    -- Generate the read event
    -- s_DataR_AL_ev <= s_DataR_Ene_AL;
     MemBank32Kx32_r_ff_AL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_AL,
     		q(0) => s_DataR_AL_ev
     );
    
    -- s_DataR_AH_ev <= s_DataR_Ene_AH;
     MemBank32Kx32_r_ff_AH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_AH,
     		q(0) => s_DataR_AH_ev
     );

    -- Instance of memory bank A: AL and AH
    MemBank32Kx32_A : MemBank32Kx32 
    PORT MAP 
    (
  		address_a => s_address_ALx,
  		address_b => s_address_AHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_AL,
  		data_b	  => s_DataW_AH,
  		rden_a	  => s_DataR_Ene_AL,
  		rden_b	  => s_DataR_Ene_AH,
  		wren_a	  => s_DataW_Ene_AL,
  		wren_b	  => s_DataW_Ene_AH,
  		q_a	      => s_DataR_AL,
  		q_b	      => s_DataR_AH
	  );
    
    -----------------------------------------
    -- Memory bank B 64Kx16 : BL and BH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_BL <= s_Command_BL_ev when s_Command_BL = "10" else '0';
    s_DataW_Ene_BH <= s_Command_BH_ev when s_Command_BH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_BL <= s_Command_BL_ev when s_Command_BL = "01" else '0';
    s_DataR_Ene_BH <= s_Command_BH_ev when s_Command_BH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_BLx(14 downto 0)  <= s_Address_BL;
    s_Address_BLx(15 downto 15) <= s_SelectH_BL;
    s_Address_BHx(14 downto 0)  <= s_Address_BH;
    s_Address_BHx(15 downto 15) <= s_SelectH_BH;
    
    -- Generate the read event
    -- s_DataR_BL_ev <= s_DataR_Ene_BL;
     MemBank32Kx32_r_ff_BL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_BL,
     		q(0) => s_DataR_BL_ev
     );
    
    -- s_DataR_BH_ev <= s_DataR_Ene_BH;
     MemBank32Kx32_r_ff_BH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_BH,
     		q(0) => s_DataR_BH_ev
     );

    -- Instance of memory bank B: BL and BH
    MemBank64Kx16_B : MemBank64Kx16 
    PORT MAP 
    (
  		address_a => s_address_BLx,
  		address_b => s_address_BHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_BL,
  		data_b	  => s_DataW_BH,
  		rden_a	  => s_DataR_Ene_BL,
  		rden_b	  => s_DataR_Ene_BH,
  		wren_a	  => s_DataW_Ene_BL,
  		wren_b	  => s_DataW_Ene_BH,
  		q_a	      => s_DataR_BL,
  		q_b	      => s_DataR_BH
	  );
    
    -----------------------------------------
    -- Memory bank C 64Kx8 : CL and CH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_CL <= s_Command_CL_ev when s_Command_CL = "10" else '0';
    s_DataW_Ene_CH <= s_Command_CH_ev when s_Command_CH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_CL <= s_Command_CL_ev when s_Command_CL = "01" else '0';
    s_DataR_Ene_CH <= s_Command_CH_ev when s_Command_CH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_CLx(14 downto 0)  <= s_Address_CL;
    s_Address_CLx(15 downto 15) <= s_SelectH_CL;
    s_Address_CHx(14 downto 0)  <= s_Address_CH;
    s_Address_CHx(15 downto 15) <= s_SelectH_CH;
    
    -- Generate the read event
    -- s_DataR_CL_ev <= s_DataR_Ene_CL;
     MemBank32Kx32_r_ff_CL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_CL,
     		q(0) => s_DataR_CL_ev
     );
    
    -- s_DataR_CH_ev <= s_DataR_Ene_CH;
     MemBank32Kx32_r_ff_CH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_CH,
     		q(0) => s_DataR_CH_ev
     );
     
    -- Instance of memory bank C: CL and CH
    MemBank64Kx8_C : MemBank64Kx8 
    PORT MAP 
    (
  		address_a => s_address_CLx,
  		address_b => s_address_CHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_CL,
  		data_b	  => s_DataW_CH,
  		rden_a	  => s_DataR_Ene_CL,
  		rden_b	  => s_DataR_Ene_CH,
  		wren_a	  => s_DataW_Ene_CL,
  		wren_b	  => s_DataW_Ene_CH,
  		q_a	      => s_DataR_CL,
  		q_b	      => s_DataR_CH
	  );
    
    -----------------------------------------
    -- Memory bank D 64Kx8 : DL and DH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_DL <= s_Command_DL_ev when s_Command_DL = "10" else '0';
    s_DataW_Ene_DH <= s_Command_DH_ev when s_Command_DH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_DL <= s_Command_DL_ev when s_Command_DL = "01" else '0';
    s_DataR_Ene_DH <= s_Command_DH_ev when s_Command_DH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_DLx(14 downto 0)  <= s_Address_DL;
    s_Address_DLx(15 downto 15) <= s_SelectH_DL;
    s_Address_DHx(14 downto 0)  <= s_Address_DH;
    s_Address_DHx(15 downto 15) <= s_SelectH_DH;
    
    -- Generate the read event
    -- s_DataR_DL_ev <= s_DataR_Ene_DL;
     MemBank32Kx32_r_ff_DL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_DL,
     		q(0) => s_DataR_DL_ev
     );
    
    -- s_DataR_DH_ev <= s_DataR_Ene_DH;
     MemBank32Kx32_r_ff_DH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_DH,
     		q(0) => s_DataR_DH_ev
     );

    -- Instance of memory bank D: DL and DH
    MemBank64Kx8_D : MemBank64Kx8 
    PORT MAP 
    (
  		address_a => s_address_DLx,
  		address_b => s_address_DHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_DL,
  		data_b	  => s_DataW_DH,
  		rden_a	  => s_DataR_Ene_DL,
  		rden_b	  => s_DataR_Ene_DH,
  		wren_a	  => s_DataW_Ene_DL,
  		wren_b	  => s_DataW_Ene_DH,
  		q_a	      => s_DataR_DL,
  		q_b	      => s_DataR_DH
	  );
    
    -----------------------------------------
    -- Memory bank E 16Kx4 : EL and EH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_EL <= s_Command_EL_ev when s_Command_EL = "10" else '0';
    s_DataW_Ene_EH <= s_Command_EH_ev when s_Command_EH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_EL <= s_Command_EL_ev when s_Command_EL = "01" else '0';
    s_DataR_Ene_EH <= s_Command_EH_ev when s_Command_EH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_ELx(12 downto 0)  <= s_Address_EL;
    s_Address_ELx(13 downto 13) <= s_SelectH_EL;
    s_Address_EHx(12 downto 0)  <= s_Address_EH;
    s_Address_EHx(13 downto 13) <= s_SelectH_EH;
    
    -- Generate the read event
    -- s_DataR_EL_ev <= s_DataR_Ene_EL;
     MemBank32Kx32_r_ff_EL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_EL,
     		q(0) => s_DataR_EL_ev
     );
    
    -- s_DataR_EH_ev <= s_DataR_Ene_EH;
     MemBank32Kx32_r_ff_EH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_EH,
     		q(0) => s_DataR_EH_ev
     );
     
    -- Instance of memory bank E: EL and EH
    MemBank16Kx4_E : MemBank16Kx4 
    PORT MAP 
    (
  		address_a => s_address_ELx,
  		address_b => s_address_EHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_EL,
  		data_b	  => s_DataW_EH,
  		rden_a	  => s_DataR_Ene_EL,
  		rden_b	  => s_DataR_Ene_EH,
  		wren_a	  => s_DataW_Ene_EL,
  		wren_b	  => s_DataW_Ene_EH,
  		q_a	      => s_DataR_EL,
  		q_b	      => s_DataR_EH
	  );
    
    -----------------------------------------
    -- Memory bank F 32Kx1 : FL and FH
    ----------------------------------------- 
    -- Generate the write enables
    s_DataW_Ene_FL <= s_Command_FL_ev when s_Command_FL = "10" else '0';
    s_DataW_Ene_FH <= s_Command_FH_ev when s_Command_FH = "10" else '0';
        
    -- Generate the read enables
    s_DataR_Ene_FL <= s_Command_FL_ev when s_Command_FL = "01" else '0';
    s_DataR_Ene_FH <= s_Command_FH_ev when s_Command_FH = "01" else '0';
        
    -- Manage the Select signals
    s_Address_FLx(13 downto 0)  <= s_Address_FL;
    s_Address_FLx(14 downto 14) <= s_SelectH_FL;
    s_Address_FHx(13 downto 0)  <= s_Address_FH;
    s_Address_FHx(14 downto 14) <= s_SelectH_FH;
    
    -- Generate the read event
    -- s_DataR_FL_ev <= s_DataR_Ene_FL;
     MemBank32Kx32_r_ff_FL : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_FL,
     		q(0) => s_DataR_FL_ev
     );
    
    -- s_DataR_FH_ev <= s_DataR_Ene_FH;
     MemBank32Kx32_r_ff_FH : Dreg
     generic map (size  => 1)
     PORT MAP
     (
     		clk	 => clk,
     		d(0) => s_DataR_Ene_FH,
     		q(0) => s_DataR_FH_ev
     );

    -- Instance of memory bank F: FL and FH
    MemBank32Kx1_F : MemBank32Kx1 
    PORT MAP 
    (
  		address_a => s_address_FLx,
  		address_b => s_address_FHx,
        clock	  => s_DPmemClock,
  		data_a	  => s_DataW_FL,
  		data_b	  => s_DataW_FH,
  		rden_a	  => s_DataR_Ene_FL,
  		rden_b	  => s_DataR_Ene_FH,
  		wren_a	  => s_DataW_Ene_FL,
  		wren_b	  => s_DataW_Ene_FH,
  		q_a	      => s_DataR_FL,
  		q_b	      => s_DataR_FH
	  );
    
    -----------------------------------------
    -- Audio configuration and setup
    ----------------------------------------- 
    -- I2C connection, only used for monitoring
    s_I2C_Clock(0)  <= I2C_Clock;          
    s_I2C_Clock0(0) <= s_I2C_Clock(0);          
    s_I2C_Data(0)   <= I2C_Data;             
    s_I2C_Data0(0)  <= s_I2C_Data(0);             
           
    s_AudioMainClock(0)     <= AudioMainClock;
    s_AudioMainClock0(0)    <= s_AudioMainClock(0);
    s_AudioBitClock(0)      <= AudioBitClock;
    s_AudioBitClock0(0)     <= s_AudioBitClock(0);
    s_AudioAdcData(0)       <= AudioAdcData;
    s_AudioAdcData0(0)      <= s_AudioAdcData(0);    
    s_AudioAdcLRselect(0)   <= AudioAdcLRselect;
    s_AudioAdcLRselect0(0)  <= s_AudioAdcLRselect(0);    
    s_AudioDacLRselect(0)   <= AudioDacLRselect;
    s_AudioDacLRselect0(0)  <= s_AudioDacLRselect(0);
    
    s_AudioDacData(0)   <= s_AudioDacData0(0);
    AudioDacData        <= s_AudioDacData(0);
    
    -- Instance of Audio/Video PLL

    AudioPLLinst : AudioPLL 
    PORT MAP
    (
  		refclk   => clk,
     	rst      => s_start_ev,     --  Reset on start event
    	outclk_0 => AudioMainClock  --  Clock output
    );
    
    -- For test only
	  -- s_oP0C0(0) <= AudioMainClock;
    
    AudioVideoCongfig : I2C_AV_Config 		
    PORT MAP
    (	--	Host Side
		iCLK     => clk,          -- 50 MHz clock
		iRST_N   => s_start_evN,  -- Reset on start event (active low)
        --	I2C Side
		I2C_SCLK => I2C_Clock,
		I2C_SDAT => I2C_Data
    );


%main_comp_map%

end %top_circuit_name%_arch;


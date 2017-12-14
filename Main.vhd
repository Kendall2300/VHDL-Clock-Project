------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY Main IS
    PORT ( SET_SELECT : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
			  
           MCLK : IN  STD_LOGIC;	  
			  STOP : IN STD_LOGIC;
			  SET_MODE : IN STD_LOGIC;
			  RESET : IN STD_LOGIC;
			  PLUS_ONE : IN STD_LOGIC;
			  UP : IN STD_LOGIC;
			 
					 
           SEVSEG_DATA : OUT  STD_LOGIC_VECTOR (6 DOWNTO 0);
           SEVSEG_CONTROL : OUT  STD_LOGIC_VECTOR (7 DOWNTO 0));
			  
			   
END Main;

ARCHITECTURE BEHAVIORAL OF Main IS

--INTERMEDIATE SIGNALS
SIGNAL WIRE_HUNDREDHZ_CLOCK : STD_LOGIC;
SIGNAL WIRE_SEVSEG_DATA : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL WIRE_Time : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL WIRE_SECONDCLOCK : STD_LOGIC;



SIGNAL hour1 : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL hour : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL minute : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL minute1 : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL second : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL second1 : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL digit1 : STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL digit0 : STD_LOGIC_VECTOR( 3 DOWNTO 0);
BEGIN


--ADD CLOCK GENERATOR
CLOCK_GENERATOR : ENTITY WORK.HUDREDHZ_CLOCK_GENERATOR PORT MAP(
	MCLK => MCLK,
	

	HUNDREDHZCLOCK => WIRE_HUNDREDHZ_CLOCK,
	SECONDCLK => WIRE_SECONDCLOCK
);

--ADD DRIVER
DRIVER : ENTITY WORK.SEVSEG_DRIVER PORT MAP(
 D8 => hour1 ,
 D7 => hour, 
 D6 => minute1,
 D5 => minute,
 D4 => second1,
 D3 => second,
 D2 =>digit1 ,
 D1 =>digit0 ,
 
 CLK => WIRE_HUNDREDHZ_CLOCK,
 SEV_SEG_DATA => WIRE_SEVSEG_DATA,
 SEV_SEG_DRIVER => SEVSEG_CONTROL
);

--ADD DECODER
DECODER : ENTITY WORK.SEVSEG_DECODER PORT MAP(
	INPUT => WIRE_SEVSEG_DATA,
	SEVSEG_BUS => SEVSEG_DATA
);

--ADD Time
Timerclock : ENTITY WORK.digi_Timer PORT MAP(
	RST => RESET,
	up => UP,
	mode => SET_MODE,
	PLUSONE=> PLUS_ONE,
	SET_SELECT => SET_SELECT,
	stop => STOP,

	
	digitthree  =>second ,
	digitfour  =>second1,
	digitfive=>minute ,
	digitsix =>minute1,
	digitseven =>hour ,
	digiteight  =>hour1,
	digitone =>digit0 ,
	digittwo =>digit1 ,

	SCLK => WIRE_SECONDCLOCK
	
);


END BEHAVIORAL;

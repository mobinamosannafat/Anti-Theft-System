library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity BlockConnection is
	port (clock			 : IN std_logic;
	      BrakeSwitch   		 : IN std_logic;
	      HiddenSwitch 		 : IN std_logic;
	      Ignition      		 : IN std_logic;
	      DriverDoor , PassengerDoor : IN std_logic;
	      resett			 : IN std_logic;
	      reprogram                  : IN STD_LOGIC; 
	      TimeSelector               : IN Bit_vector (1 Downto 0);
	      TimeValue			 : IN std_logic_vector(3 downto 0);
	      FuelPumpPower 		 : OUT std_logic;	
	      LED			 : OUT bit;
	      Siren_out 		 : OUT STD_LOGIC);
end entity;


architecture bhv of BlockConnection  is

component Divider is
	port (clk,reset: in std_logic;
	      clock_out: out std_logic);
end component;

component FuelPumpLogic is
    Port (clock , BrakeSwitch, HiddenSwitch, ignition: IN  STD_LOGIC;
	  FuelPumpPower : out  STD_LOGIC );
end component;

component AntiTheftFSM is
    Port ( clock, DriverDoor, PassengerDoor, ignition, 
		reprogram, expired: IN  STD_LOGIC;
		interval : out BIT_vector (1 Downto 0 );
		StatusIndicator: out STD_LOGIC_vector (1 Downto 0 ); 
		StartTime, siren         : out STD_LOGIC := '0'
	    );
		--CurrentState             : out State);
end component;

component TimeParameters is
Port (  clock , reprogram: IN  STD_LOGIC;
	TimeSelector ,interval : IN Bit_vector (1 Downto 0);
	TimeValue : IN STD_LOGIC_vector (3 Downto 0);
	valu, SelectedValue : out STD_LOGIC_vector (3 Downto 0));  --, SelectedValue
end component;

component Timer is
Port (  clock , clk_1h, StartTimer: IN  STD_LOGIC;
	CountValue                : IN STD_LOGIC_vector (3 Downto 0);
	expired                   : out  STD_LOGIC);
	--CurrentCount            : out STD_LOGIC_vector (3 Downto 0)); 
end component;

component LED_state is
port(   clk_50khz , enable : in STD_LOGIC;
	status : in std_logic_vector(1 downto 0);
	LED_out : out bit);
end component;

component SirenGenerator is
port(   clk_50khz , siren_in : IN STD_LOGIC;
	siren_out : out STD_LOGIC);
end component;

component debounce is
    Port ( 
		reset, clock, noisy : IN  STD_LOGIC;
		clean               : out  STD_LOGIC); 
end component; 

component synchronize is 
--generic( NSYNC : integer := 2);
port ( clock , inn: in std_logic;
	   outt: out std_logic);
end component;

Signal BS , HS , IG , DD , PD , RP : STD_LOGIC;
Signal BS2 , HS2 , IG2 , DD2 , PD2 , RP2 : STD_LOGIC;
Signal enable             : std_logic;
Signal FPP             : STD_LOGIC;
Signal siren   	       : STD_LOGIC;
Signal StrTimer	       : STD_LOGIC;
Signal exp 	       : STD_LOGIC;
Signal interval        : BIT_VECTOR (1 downto 0);
Signal StatusIndicator : std_logic_vector(1 downto 0) := "00";
Signal SelectedValue   : STD_LOGIC_vector (3 Downto 0);
Signal valu 	       : STD_LOGIC_VECTOR(3 downto 0);
Signal LED1	       : BIT;
Signal SoutTmp	       : STD_LOGIC;
--

Begin 
	
	d1: debounce port map ( '1' , clock , BrakeSwitch , BS2);
	d2: debounce port map ( '1' , clock , HiddenSwitch , HS2);
	d3: debounce port map ( '1' , clock , Ignition , IG2);
	d4: debounce port map ( '1' , clock , DriverDoor , DD2);
	d5: debounce port map ( '1' , clock , PassengerDoor , PD2);
	d6: debounce port map ( '1' , clock , Reprogram , RP2);
--	
	sy1: synchronize port map (clock , BS2 , BS);
	sy2: synchronize port map (clock , HS2 , HS);
	sy3: synchronize port map (clock , IG2 , IG);
	sy4: synchronize port map (clock , DD2 , DD);
	sy5: synchronize port map (clock , PD2 , PD);
	sy6: synchronize port map (clock , RP2 , RP);	

--	sy1: synchronize port map (clock , BrakeSwitch , BS);
--	sy2: synchronize port map (clock , HiddenSwitch , HS);
--	sy3: synchronize port map (clock , Ignition , IG);
--	sy4: synchronize port map (clock , DriverDoor , DD);
--	sy5: synchronize port map (clock , PassengerDoor , PD);
--	sy6: synchronize port map (clock , Reprogram , RP);

	f1: FuelPumpLogic port map ( clock , BS , HS , IG , FPP);
												--change exp	  		     -- change StrTimer
	a1: AntiTheftFSM port map ( clock , DD , PD , IG , RP , exp , interval , StatusIndicator , StrTimer , siren);

	D: Divider PORT MAP (clock , '0' , enable);

	tp1: TimeParameters port map (clock , RP , TimeSelector , interval , TimeValue , valu, SelectedValue);

	t1: Timer port map ( clock , enable , StrTimer , valu , exp);

	l1: LED_state port map ( clock , enable , StatusIndicator , LED1);

	s1: SirenGenerator port map ( clock , siren , SoutTmp);

	FuelPumpPower <= FPP;
	LED <= LED1;
	siren_out <= SoutTmp;

End bhv;
	


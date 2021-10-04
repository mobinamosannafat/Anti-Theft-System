library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is 
end entity;

architecture test1 of testbench is

component BlockConnection is
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
end component;

signal  clock : std_logic := '1';
signal BrakeSwitch , HiddenSwitch , Ignition , DriverDoor , PassengerDoor : std_logic := '0';
signal reprogram  , resett , FulePumpPower , siren_out : std_logic := '0' ;
signal LED : BIT;
signal TimeSelector : Bit_vector (1 Downto 0);
signal TimeValue : std_logic_vector(3 downto 0);


begin
	p1: BlockConnection port map( clock ,BrakeSwitch , HiddenSwitch , Ignition , DriverDoor , PassengerDoor , resett , reprogram,
				TimeSelector , TimeValue  , FulePumpPower , LED , siren_out );

	clock <= not clock after 10 ns ; --when not (finished = '1') else '0';
	DriverDoor <= 'U' , '1' after 300 ns , '0' after 400 ns;
	PassengerDoor <= 'U' , '1' after 700 ns , '1' after 1000 ns ;
	BrakeSwitch <= 'U' , '1' after 200 ns;
	HiddenSwitch <= 'U' , '1' after 200 ns;
	Ignition <= 'U' , '1' after 100 ns , '0' after 300 ns ;
	--finished <= '1' after 1000 ns;
	

end test1;


	


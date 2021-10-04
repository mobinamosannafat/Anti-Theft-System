library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimeParameters is
    Port ( 
		clock , reprogram: IN  STD_LOGIC;
		TimeSelector ,interval : IN Bit_vector (1 Downto 0);
		TimeValue : IN STD_LOGIC_vector (3 Downto 0);
		valu , SelectedValue: out STD_LOGIC_vector (3 Downto 0)); 


end TimeParameters;

architecture ARCH of TimeParameters is

	SIGNAL t_arm_delay       : STD_LOGIC_vector (3 Downto 0) := "0110";
	SIGNAL t_driver_delay    : STD_LOGIC_vector (3 Downto 0) := "1000";
	SIGNAL t_passenger_delay : STD_LOGIC_vector (3 Downto 0) := "1111";
	SIGNAL t_alarm_on       : STD_LOGIC_vector (3 Downto 0) := "1010";
	SIGNAL valuTMP ,SelectedValueTMP : STD_LOGIC_vector (3 Downto 0 ); 

	BEGIN
		Process(clock)
		BEGIN
			if(clock'Event and clock = '1') then 
				if (reprogram = '1') then
				
					Case TimeSelector is
						When "00" => t_arm_delay <= TimeValue;

						When "01" => t_driver_delay <= TimeValue;

						When "10" => t_passenger_delay <= TimeValue;

						When "11" => t_alarm_on <= TimeValue;
					End Case;

					Case TimeSelector is					
						When "00" => SelectedValueTMP <= t_arm_delay;

						When "01" => SelectedValueTMP <= t_driver_delay;

						When "10" => SelectedValueTMP <= t_passenger_delay;

						When "11" => SelectedValueTMP <= t_alarm_on;
					End Case;
				End if;
					
				Case interval is
					When "00" => valuTMP <= t_arm_delay; 

					When "01" => valuTMP <= t_driver_delay; 

					When "10" => valuTMP <= t_passenger_delay;

					When "11" => valuTMP <= t_alarm_on; 
				End Case;			
			End if;
		End Process;

		valu <= valuTMP ;
		SelectedValue <= SelectedValueTMP;		
End ARCh;


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity FuelPumpLogic is
    Port ( 
		clock , BrakeSwitch, HiddenSwitch, ignition: IN  STD_LOGIC;
		FuelPumpPower : out  STD_LOGIC ); --when 0 Fuel Pump Power is OFF
				       	 		--when 1 Fuel Pump Power is ON


end FuelPumpLogic;

architecture Moor of FuelPumpLogic is
	type State is(State0, State1, State2);
	SIGNAL CurrentState , NextState : State := State0;
	SIGNAL tmp , TST : STD_LOGIC := '0' ;

	begin 
		

		process (CurrentState,clock)
		begin
			if(clock'Event and clock = '1') then

				CurrentState <= NextState ;
				TST <= not(TST);

				Case CurrentState is
			
					when State0 => 
						if(ignition = '1') then
							NextState <= State1; 
						else
							NextState <= State0;
						end if;

					when State1 => 
						if(BrakeSwitch = '1'  and HiddenSwitch = '1') then
							NextState <= State2; 
						else
							NextState <= State0;
						end if;
	
					when State2 => 
						tmp <= '1' ;
				End Case;
			End if;
		End process;

		FuelPumpPower <= tmp ;

End Moor;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity AntiTheftFSM is
    Port ( 
		clock, DriverDoor, PassengerDoor, ignition, 
		reprogram, expired: IN  STD_LOGIC;
		interval : out BIT_vector (1 Downto 0 );
		StatusIndicator: out STD_LOGIC_vector (1 Downto 0 ) := "00"; 
		StartTime, siren         : out STD_LOGIC := '0');		--CurrentState             : out State);
end AntiTheftFSM;

architecture Moor of AntiTheftFSM is

type State is(State0, State1, State2, State3, State4, State5, State6, State7);

	SIGNAL NextState: State;
	SIGNAL CurrentStateTmp : State := State3;
	SIGNAL StatusIndicatorTMP      :STD_LOGIC_vector (1 Downto 0 ); 
	SIGNAL intervalTMP             :BIT_vector (1 Downto 0 ) ;--:="00"
	SIGNAL StartTimeTMP, sirenTMP  :STD_LOGIC;


	begin 

		process (CurrentStateTmp,clock)
		begin
			if(clock'Event and clock = '1') then 
			
				CurrentStateTMP <= NextState;

				if (reprogram = '1') then 
					NextState <= State3;
				else 
					NextState <= CurrentStateTMP;
				
					Case CurrentStateTMP is
			
						when State0 => 
							--OutPuts
							StartTimeTMP <= '0';
							StatusIndicatorTMP <= "00";
							sirenTMP <= '0' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							end if;

							if(DriverDoor = '1' and ignition = '0') then
								NextState <= State1;
							end if;


						when State1 => 
							--OutPuts
							StartTimeTMP <= '0';
							StatusIndicatorTMP <= "00";
							sirenTMP <= '0' ;
		
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							end if;
	
							if(DriverDoor = '0') then
								NextState <= State2;
							end if;
	
	
						when State2 => 
							--OutPuts
							intervalTMP <= "00";
							StartTimeTMP <= '1';
							StatusIndicatorTMP <= "00";
							sirenTMP <= '0' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							end if;
	
							if(DriverDoor = '1') then
								NextState <= State1;
							end if;

							if(expired = '1') then
								NextState <= State3;
							end if;
	
	
						when State3 => 
							--OutPuts
							StartTimeTMP <= '0';
							StatusIndicatorTMP <= "01";
							sirenTMP <= '0' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							end if;
	
							if(PassengerDoor = '1') then
								NextState <= State4;
							end if;
	
							if(DriverDoor = '1') then
								NextState <= State5;
							end if;
	
	
						when State4 => 
							--OutPuts
							intervalTMP <= "10";
							StartTimeTMP <= '1';
							StatusIndicatorTMP <= "10";
							sirenTMP <= '0' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							elsif(expired = '1') then
								NextState <= State6;
							end if;
	
	
						when State5 => 
							--OutPuts
							intervalTMP <= "01";
							StartTimeTMP <= '1';
							StatusIndicatorTMP <= "10";
							sirenTMP <= '0' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							elsif(expired = '1') then
								NextState <= State6;
							end if;
	
	
						when State6 => 
							--OutPuts
							StartTimeTMP <= '0';
							StatusIndicatorTMP <= "10";
							sirenTMP <= '1' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							elsif(expired = '1') then
								NextState <= State6;
							elsif(PassengerDoor = '0') then
								NextState <= State7;
							end if;
	
	
						when State7 => 
							--OutPuts
							intervalTMP <= "11";
							StartTimeTMP <= '1';
							StatusIndicatorTMP <= "10";
							sirenTMP <= '1' ;
	
							--NextState
							if(ignition = '1') then
								NextState <= State0; 
							elsif(expired = '1') then
								NextState <= State3;
							end if;
	
					End Case;
				End if;
			End if;
		End process;



		StatusIndicator <= StatusIndicatorTMP;      
	        interval <= intervalTMP;             
		StartTime <= StartTimeTMP;
                siren <= sirenTMP;

End Moor;


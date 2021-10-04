library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    Port ( 
		clock , clk_1h, StartTimer: IN  STD_LOGIC;
		CountValue                : IN STD_LOGIC_vector (3 Downto 0);
		expired                   : out  STD_LOGIC);
end Timer;

architecture ARCH of Timer is

	SIGNAL TimerMode : Bit := '0';
	SIGNAL expiredTMP  : STD_LOGIC := '0' ;
	SIGNAL count  : STD_LOGIC_vector (3 Downto 0); --CurrentCountTMP,

	BEGIN		
		process(clock , clk_1h)
		BEGIN
			if(clock'Event and clock = '1') then 
				if(StartTimer = '1') then
					Case TimerMode is 
						When '0' => 
							TimerMode <= '1';
							expiredTMP <= '0';
							count <= CountValue;

						When '1' =>
							if(count = "0000") then 
								expiredTMP <= '1';
							elsif(clk_1h = '1') then
								 count <= STD_LOGIC_VECTOR (UNSIGNED(count) - 1);
							end if;
					End Case;
				Else 
					expiredTMP <= '0';
					TimerMode <= '0';
				End if;
			End if;
		End process;
		expired <= expiredTMP ;							
End ARCH;




library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    Port ( 
		reset, clock, noisy : IN  STD_LOGIC;
		clean               : out  STD_LOGIC); 
end debounce;

architecture ARCH of debounce is

	SIGNAL cleanTMP, NewT : STD_LOGIC;
	SIGNAL DELAY    : STD_LOGIC_VECTOR (18 Downto 0) := "1111010000100100000"; -- 270000 => .01 sec with a 27Mhz clock
	SIGNAL count    : STD_LOGIC_VECTOR (18 Downto 0);
	SIGNAL add      : STD_LOGIC_VECTOR (18 Downto 0) := "0000000000000000001";

	BEGIN
		process(clock)
		BEGIN
			if(clock'Event and clock = '1') then 
				if(reset = '1') then 
					count <= "0000000000000000000";
	  				NewT <= noisy;
	  				cleanTMP <= noisy;
				elsif (not (noisy = NewT)) then
	  				NewT <= noisy;
	  				count <= "0000000000000000000";
     				elsif (count = DELAY) then
       					cleanTMP <= NewT;
     				else
       					count <= STD_LOGIC_VECTOR (UNSIGNED(count) + UNSIGNED(add));
				End if;
			End if;
		End process;

		clean <= cleanTMP;
End ARCH;



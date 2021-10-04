library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity synchronize is
port ( clock , inn: in std_logic;
	   outt: out std_logic);
end entity;

architecture bhv of synchronize is

signal sync : std_logic;
signal outTmp : std_logic;

Begin
	Process(clock)
		BEGIN
			if(clock'Event and clock = '1') then
				outTmp <=  sync;
				sync <= inn;
			End if;
		End process;

		outt <= outTmp;
End bhv;


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity SirenGenerator is
port(   clk_50khz , siren_in : IN STD_LOGIC;
	siren_out : out STD_LOGIC);
end entity;


architecture generator of SirenGenerator is
signal toggle : STD_LOGIC_vector(3 downto 0) := "1010"; --10
signal t400 : STD_LOGIC_vector(3 downto 0) := "0100"; --4
signal t700 : STD_LOGIC_vector(3 downto 0) := "0111"; --7

signal StCount : STD_LOGIC_vector(3 downto 0) := "0000"; 
signal SiCount : STD_LOGIC_vector(3 downto 0) := "0000";

signal state : bit := '0';
signal siren : STD_LOGIC := '1';

begin 
	process(clk_50khz)
	begin
		if (clk_50khz = '1' and clk_50khz'Event) then 	
			if(siren_in = '1') then 
				StCount <= std_logic_vector(Unsigned(StCount) + 1);
				if (Unsigned(StCount) > Unsigned(toggle)) then 
					case state is 
						when '0' => state <= '1';
						when '1' => state <= '0';
					end case;
					StCount <= "0000";
				else
					case state is
						when '0' => 
							if (Unsigned(SiCount) > Unsigned(t400)) then 
								siren <= not siren;
								SiCount <= "0000";
							else
								SiCount <= std_logic_vector(Unsigned(SiCount) + 1);
							end if;
						when '1' => 
							if (Unsigned(SiCount) > Unsigned(t700)) then 
								siren <= not siren;
								SiCount <= "0000";
							else
								SiCount <= std_logic_vector(Unsigned(SiCount) + 1);
							end if;
					end case;
				end if;
			end if;
		end if;
	end process;
	siren_out <= siren;
end generator;
	



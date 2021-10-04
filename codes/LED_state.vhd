library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LED_state is
port(   clk_50khz , enable : in STD_LOGIC;
	status : in std_logic_vector(1 downto 0);
	LED_out : out bit);
end entity;

architecture driver of LED_state is
signal LED : bit;
signal b_state : bit;

begin 
	process(clk_50khz)
	begin
		if (clk_50khz = '1' and clk_50khz'Event) then 
			case status is 
				when "00" => LED <= '0';  --L_off
				when "01" => LED <= '1';  --L_on
				when "10" =>              --L_blink
					if ( enable = '1') then 
						b_state <= not b_state;
						LED <= b_state;
					end if;
				when others => LED <= '0';
			end case;
		end if;
	end process;
	LED_out <= LED;
end Driver;



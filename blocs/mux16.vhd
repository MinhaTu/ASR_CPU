library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity mux16 is
	port(a,b: IN std_logic_vector(15 downto 0);
			sel: IN std_logic;
			y : OUT std_logic_vector(15 downto 0));
end mux16;


architecture mux16_functionality of mux16 is
	begin
		main:process(a,b,sel)
			begin
				if sel = '0' then
					y <= a;
				elsif sel = '1' then
					y <= b;
				end if;
		end process main;
end mux16_functionality;
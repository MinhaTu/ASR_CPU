library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity mux4 is
	port(a,b: IN std_logic_vector(3 downto 0);
			sel: IN std_logic;
			y : OUT std_logic_vector(3 downto 0));
end mux4;


architecture mux4_functionality of mux4 is
	begin
		main:process(a,b,sel)
			begin
				if sel = '0' then
					y <= a;
				elsif sel = '1' then
					y <= b;
				end if;
		end process main;
end mux4_functionality;
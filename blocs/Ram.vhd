library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity ram is
	port(
			we		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(15 downto 0);
			Data_out:	out std_logic_vector(15 downto 0)
			);
end ram;

architecture ram_a of ram is

type ram is array(0 to 255) of std_logic_vector(15 downto 0);

signal Data_Ram : ram ;



--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_ram:process(rst, clk)
		begin
		
		if rst='1' then
			Data_Ram <= (others =>(others=>'0'));
		
		else
			if rising_edge(clk) then
				if we='1' then -- Write	
						Data_Ram(to_integer(unsigned(Adress))) <= Data_in;
				end if;
			end if;
		end if;
		
	end process acces_ram;
	
	Data_out <= Data_Ram(to_integer(unsigned(Adress)));
end ram_a;

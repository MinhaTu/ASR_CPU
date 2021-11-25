LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all ;
-- Register file composed by 16 general purposes registers, R0 is the program counter, R1 Status register
entity register_file is
	generic(DEPTH: natural := 16;
				WIDTH: natural := 16);
	port(
			I_clk : IN std_logic;
			I_rst : IN std_logic;
			I_WE  : IN std_logic; -- Write enable
			I_A1  : IN std_logic_vector(3 downto 0);
			I_A2  : IN std_logic_vector(3 downto 0);
			I_A3  : IN std_logic_vector(3 downto 0);
			I_WD  : IN std_logic_vector(WIDTH - 1 downto 0);
			O_RD1 : OUT std_logic_vector(WIDTH - 1 downto 0);
			O_RD2 : OUT std_logic_vector(WIDTH - 1 downto 0);
			O_RDisplay : OUT STD_logic_vector(WIDTH - 1 downto 0)
	);
end register_file;


architecture rtl of register_file is
	type mem is array(0 to DEPTH - 1 ) of std_logic_vector(WIDTH - 1 downto 0);
	signal Data_rf: mem;
	
	begin
		write_rf:process(I_clk, I_rst)
		begin
			if I_rst = '1' then
					Data_rf <= (others => (others => '0'));
			else 
			
				if rising_edge(I_clk) then
				-- Write data
					if I_WE='1'then
						Data_rf(to_integer(unsigned(I_A3))) <= I_WD;
					end if;
				end if;
			end if;
		
		end process write_rf;
	
		read_rf:process(I_A1,I_A2)
			-- read data
			begin
				O_RD1 <= Data_rf(to_integer(unsigned(I_A1)));
				O_RD2 <= Data_rf(to_integer(unsigned(I_A2)));
		end process read_rf;
		O_RDisplay <= Data_rf(7);
end rtl;
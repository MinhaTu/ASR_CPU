library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;


entity ALU_tb is
end ALU_tb;

architecture tb of ALU_tb is 
	constant c_CLK_PERIOD : time := 20 ns;
	constant PERIOD : time := 20 ns;
	
	constant WIDTH: natural := 16;
	constant DEPTH: natural := 5;

	
		
	signal clk: std_logic := '0';
	signal op_format : std_logic;
	signal Register_A :  STD_LOGIC_VECTOR (15 downto 0);
   signal Register_B :  STD_LOGIC_VECTOR (15 downto 0);
   signal op :  STD_LOGIC_VECTOR (2 downto 0);
   signal output :  STD_LOGIC_VECTOR (15 downto 0);
   signal FLAGS :  STD_LOGIC_VECTOR (3 downto 0);
	

	component ALU is 
			port (op_format : in std_logic;
					Register_A : in  STD_LOGIC_VECTOR (15 downto 0);
					Register_B : in  STD_LOGIC_VECTOR (15 downto 0);
					op : in  STD_LOGIC_VECTOR (2 downto 0);
					output : out  STD_LOGIC_VECTOR (15 downto 0);
					FLAGS : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	begin 
		ALU_inst: ALU
		port map(op_format => op_format,
					Register_A => Register_A,
					Register_B 	=> Register_B,
					op => op,
					output => output,
					FLAGS => FLAGS
					
		);
		
		
		clk <= not clk after c_CLK_PERIOD/2 ;
		
		tb: process
			begin 
				wait for period;
				
				-- Push tests
				
				op_format <= '0';
				Register_A <= "0000000000001110";
				Register_B <="0000000000000110";
				op <="000";
				wait for period;
								
				op_format <= '0';
				Register_A <= "0100000000001110";
				Register_B <="0100000000000110";
				op <="000";
				wait for period;
				
				op_format <= '0';
				Register_A <= "0000000000001110";
				Register_B <="0000000000001110";
				op <="001";
				wait for period;
				
				op_format <= '0';
				Register_A <= "0000000000001110";
				Register_B <="0100000000000110";
				op <="001";
				wait for period;
				
				op_format <= '0';
				Register_A <= "1000000111000000";
				Register_B <="0000000000000110";
				op <="010";
				wait for period;
				
				-- Push tests
				op_format <= '0';
				Register_A <= "0000000111000001";
				Register_B <="0000000000000110";
				op <="011";
				wait for period;

					op_format <= '0';
				Register_A <= "0000000111110000";
				Register_B <="0000000000111110";
				op <="100";
				wait for period;
	
				op_format <= '0';
				Register_A <= "0000000111110000";
				Register_B <="0000000000111110";
				op <="101";
				wait for period;
			
				op_format <= '0';
				Register_A <= "0000000111110000";
				Register_B <="0000000000111110";
				op <="110";
				wait for period;
			
				op_format <= '0';
				Register_A <= "0000000000000000";
				Register_B <="0000000000000110";
				op <="111";
				wait for period;
			
				op_format <= '1';
				Register_A <= "0000000000000000";
				Register_B <="0000000000000110";
				op <="000";
				wait for period;	
				
				op_format <= '1';
				Register_A <= "0000000000000000";
				Register_B <="0000000000000110";
				op <="001";
				wait for period;	
				

		end process tb;
		
end tb;
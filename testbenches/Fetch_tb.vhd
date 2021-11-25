LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity fetch_tb is
end fetch_tb;


architecture fetch_test of fetch_tb is
	constant c_CLK_PERIOD : time := 20 ns;
	constant PERIOD : time := 20 ns;
	
	signal I_en		:	 std_logic;
	signal I_clk		:	 std_logic:= '0';
	signal I_rst		:	std_logic;
	signal I_Branch :   std_logic;
	signal I_Jump   :   std_logic;
	signal I_JumpAdress:  std_logic_vector(7 downto 0);
	signal I_Immed  :   std_logic_vector(7 downto 0);
	signal PC_out	:	 std_logic_vector(7 downto 0);
	
	component Fetch is
			port(
			I_en			:	in std_logic;
			I_clk		:	in std_logic;
			I_rst		:	in std_logic;
			I_Branch :  in std_logic;
			I_Jump   :  in std_logic;
			I_JumpAdress: in std_logic_vector(7 downto 0);
			I_Immed  :  in std_logic_vector(7 downto 0);
			PC_out	:	out std_logic_vector(7 downto 0)
			);
	end component;
	
	begin
		Fetch_inst: Fetch
		port map(I_en => I_en,
					I_clk => I_clk,
					I_rst => I_rst,
					I_Branch => I_Branch,
					I_Jump => I_Jump,
					I_JumpAdress => I_JumpAdress,
					I_Immed => I_Immed,
					PC_out => PC_out );
		I_clk <= not I_clk after c_CLK_PERIOD/2;
		
		main:process
			begin
				I_rst <= '1';
				I_en <= '0';
				I_Branch <= '0';
				I_Jump <= '0';
				
				wait for PERIOD*3;
				
				I_rst <= '0';
				I_en <= '1';
				
				wait for PERIOD;
				
								
				I_rst <= '0';
				I_en <= '1';
				
				wait for PERIOD;
				
								
				I_rst <= '0';
				I_en <= '1';
				
				wait for PERIOD;
				
								
				I_rst <= '0';
				I_en <= '1';
				
		end process main;

		
end fetch_test;
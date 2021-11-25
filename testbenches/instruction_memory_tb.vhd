LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity instruction_memory_tb is
end instruction_memory_tb;


architecture inst_tb of instruction_memory_tb is
	constant WIDTH: natural := 17;
	constant DEPTH: natural := 5;
	constant PERIOD : time := 20 ns;
	
	signal I_rst: std_logic := '0';
	signal I_A : std_logic_vector(7 downto 0):= (others=>'0');
	signal O_Inst: std_logic_vector(WIDTH - 1 downto 0);
	
	component instruction_memory is
		generic (WIDTH: natural := 17;
					DEPTH: natural := 256
		);
		port( I_rst: IN std_logic;
				I_A : IN std_logic_vector(7 downto 0);
				O_Inst: OUT std_logic_vector(WIDTH - 1 downto 0)
				);
	end component;
	
	begin
		------------ BEGIN -----------
		instruction_memory_inst: instruction_memory
		generic map(WIDTH => WIDTH,
						 DEPTH => DEPTH)
		port map(I_rst  => I_rst,
					I_A    => I_A,
					O_Inst => O_Inst);
		
		test:process
			variable a: std_logic_vector(7 downto 0); 
			begin
				I_rst <= '1';
				wait for period;
				
				I_rst <= '0';
				a := "00000001";
			   I_A <= a;
				wait for period;
				
				I_rst <= '0';
				a := "00000010";
				I_A <= a;
				wait for period;
				I_rst <= '0';
				a := "00000011";
				I_A <= a;
				wait for period;
		end process test;
			
			

end inst_tb;
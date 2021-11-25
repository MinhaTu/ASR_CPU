LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
entity stack_tb is
end stack_tb;

architecture tb of stack_tb is 
	constant c_CLK_PERIOD : time := 20 ns;
	constant PERIOD : time := 20 ns;
	
	constant WIDTH: natural := 16;
	constant DEPTH: natural := 5;

	
	signal Data_in : std_logic_vector(WIDTH - 1 downto 0);
	signal mode, en, rst   : std_logic;
	signal clk: std_logic := '0';
	signal Data_out :  std_logic_vector(WIDTH -1  downto 0);
	signal Full_Control, Empty_Control :  std_logic;
	
	component stack is 
				GENERIC (
					WIDTH: natural := 16;
					DEPTH: natural := 5
				);
			port (Data_in : IN std_logic_vector(WIDTH - 1 downto 0);
					mode, en, rst, clk    : IN std_logic;
					Data_out : OUT std_logic_vector(WIDTH -1  downto 0);
					Full_Control, Empty_Control : OUT std_logic);
	end component;
	
	begin 
		stack_inst: stack
		generic map(WIDTH => WIDTH, DEPTH => DEPTH)
		port map(Data_in => Data_in,
					mode 	=> mode,
					en => en,
					rst => rst,
					clk => clk,
					Data_out => Data_out,
					Full_Control => Full_Control,
					Empty_Control => Empty_Control
					
		);
		
		
		clk <= not clk after c_CLK_PERIOD/2 ;
		
		tb: process
			variable a : std_logic_vector(3 downto 0);
			begin 
				rst <= '1';
				Data_in <= (others=>'0');
				wait for period;
				
				-- Push tests
				rst <= '0';
				en <= '1';
				mode <= '0';
				a := "1010";
				Data_in <= std_logic_vector(resize(signed(a), Data_in'length)); -- 10
				wait for period;
				
				-- Push tests
				rst <= '0';
				en <= '1';
				mode <= '0';
				a := "1011";
				Data_in <= std_logic_vector(resize(signed(a), Data_in'length)); -- 11
				wait for period;
				
				-- Push tests
				rst <= '0';
				en <= '1';
				mode <= '0';
				a := "1100";
				Data_in <= std_logic_vector(resize(signed(a), Data_in'length)); -- 8
				wait for period;
				
				-- Pop tests
				rst <= '0';
				en <= '1';
				mode <= '1';
				wait for period;
				
						-- Pop tests
				rst <= '0';
				en <= '1';
				mode <= '1';
				wait for period;
				
						-- Pop tests
				rst <= '0';
				en <= '1';
				mode <= '1';
				wait for period;
				
						-- Pop tests
				rst <= '0';
				en <= '1';
				mode <= '1';
				wait for period;
			
		end process tb;

end tb;
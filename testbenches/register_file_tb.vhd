LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity register_file_tb is
end register_file_tb;

architecture rg_tb of register_file_tb is
	constant c_CLK_PERIOD : time := 20 ns;
	constant PERIOD : time := 20 ns;
	
	constant WIDTH: natural := 16;
	constant DEPTH: natural := 5;
	
	signal I_clk : std_logic := '0';
	signal I_rst : std_logic;
	signal I_WE  : std_logic; -- Write enable
	signal I_A1  : std_logic_vector(3 downto 0);
	signal I_A2  : std_logic_vector(3 downto 0);
	signal I_A3  : std_logic_vector(3 downto 0);
	signal I_WD  : std_logic_vector(WIDTH - 1 downto 0);
	signal O_RD1 : std_logic_vector(WIDTH - 1 downto 0);
	signal O_RD2 : std_logic_vector(WIDTH - 1 downto 0);
	
	component register_file is 
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
				O_RD2 : OUT std_logic_vector(WIDTH - 1 downto 0)
		);
	end component;
	
	begin 
	-------- BEGIN ----------
	rf_inst:register_file
	generic map(WIDTH => WIDTH, DEPTH => DEPTH)
	port map(I_clk => I_clk,
				I_rst => I_rst,
				I_WE  => I_WE,
				I_A1	=> I_A1,
				I_A2	=> I_A2,
				I_A3	=> I_A3,
				I_WD	=> I_WD,
				O_RD1	=> O_RD1,
				O_RD2	=> O_RD2);
	
	I_clk <= not I_clk after c_CLK_PERIOD/2;
	
	rf_test:process 
		variable a: std_logic_vector(3 downto 0);
		
		begin
			
			I_rst <= '1';
			wait for period*3;
			
			I_rst <= '0';
			I_WE <= '1';
			a := "0000";
			I_A3 <= a;
			I_WD <= std_logic_vector(resize(signed(a), I_WD'length));
			wait for period;
			
			I_rst <= '0';
			I_WE <= '1';
			a := "0001";
			I_A3 <= a;
			I_WD <= std_logic_vector(resize(signed(a), I_WD'length));
			wait for period;
			
			I_rst <= '0';
			I_WE <= '1';
			a := "0010";
			I_A3 <= a;
			I_WD <= std_logic_vector(resize(signed(a), I_WD'length));
			wait for period;
			
			I_rst <= '0';
			I_WE <= '1';
			a := "0011";
			I_A3 <= a;
			I_WD <= std_logic_vector(resize(signed(a), I_WD'length));
			wait for period;
			
			I_rst <= '0';
			I_WE <= '0';
			a := "0000";
			I_A1 <= a;
			a := "0001";
			I_A2 <= a;
			wait for period;
			
			I_rst <= '0';
			I_WE <= '0';
			a := "0010";
			I_A1 <= a;
			a := "0011";
			I_A2 <= a;
			wait for period;
	end process rf_test;
	
		
end rg_tb;
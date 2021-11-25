library ieee;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity CPU_tb is
end CPU_tb;


architecture CPU_testbench of CPU_tb is
	constant c_CLK_PERIOD : time := 20 ns;
	constant PERIOD : time := 20 ns;
	
	signal m_clk: std_logic := '0';
	signal m_en: std_logic;
	signal m_rst: std_logic;
	signal O_Inst: std_logic_vector(16 downto 0);
	signal output: std_logic_vector(15 downto 0);
	
	component CPU is
		port(m_clk: IN std_logic;
			  m_en: IN std_logic;
			  m_rst: IN std_logic;
			  O_Inst: OUT std_logic_vector(16 downto 0);
			  output: OUT std_logic_vector(15 downto 0));
	end component;
	
	begin 
		CPU_inst: CPU
		port map(m_clk => m_clk,
					m_en => m_en,
					m_rst =>m_rst,
					O_Inst => O_Inst,
					output => output);
		
		m_clk <= not m_clk after c_CLK_PERIOD;
		
		main: process
			begin
				m_rst <= '1';
				m_en <= '0';
				wait for PERIOD*3;
				
				m_rst <= '0';
				m_en <= '1';
				wait for PERIOD*3;
				
		end process main;

end CPU_testbench;
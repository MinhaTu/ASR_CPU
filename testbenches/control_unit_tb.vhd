library ieee;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity control_unit_tb is
end control_unit_tb;


architecture control_unit_test of control_unit_tb is
	constant period: time := 20 ns;
	
	signal I_rst : std_logic;
	signal I_op_format: std_logic_vector(1 downto 0);
	signal I_op		 : std_logic_vector(2 downto 0);
	signal O_RegWrite :  std_logic;
	signal O_RegDst   : std_logic;
	signal O_ALUsrc   : std_logic;
	signal O_Branch   : std_logic;
	signal O_MemWrite : std_logic;
	signal O_MemToReg : std_logic;
	signal O_ALUFormat  : std_logic;
	signal O_ALUop      : std_logic_vector(2 downto 0);
	signal O_Jump		 : std_logic;
	
	component control_unit is
		port(I_rst : IN std_logic;
		  I_op_format: IN std_logic_vector(1 downto 0);
		  I_op		 : IN std_logic_vector(2 downto 0);
		  O_RegWrite : OUT std_logic;
		  O_RegDst   : OUT std_logic;
		  O_ALUsrc   : OUT std_logic;
		  O_Branch   : OUT std_logic;
		  O_MemWrite : OUT std_logic;
		  O_MemToReg : OUT std_logic;
		  O_ALUFormat  : OUT std_logic;
		  O_ALUop      : OUT std_logic_vector(2 downto 0);
		  O_Jump			: OUT std_logic
		  );
	end component;
	
	begin
		control_unit_inst: control_unit
		port map(I_rst => I_rst,
					I_op_format => I_op_format,
					I_op => I_op,
					O_RegWrite => O_RegWrite,
					O_RegDst => O_RegDst,
					O_ALUsrc => O_ALUsrc,
					O_Branch => O_Branch,
					O_MemWrite => O_MemWrite,
					O_MemToReg => O_MemToReg,
					O_ALUFormat => O_ALUFormat,
					O_ALUop => O_ALUop,
					O_Jump => O_Jump);
		
		main:process
			variable opcode: std_logic_vector(4 downto 0);
				
				begin 
					I_rst <= '1';
					opcode := "00000";
					wait for period*3;
					I_rst <= '0';
					-- R-type op
					opcode := "00000"; --ADD
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					
					opcode := "00001"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					opcode := "00010"; -- right shift
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					-- I-type op
					opcode := "01000"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					opcode := "01001"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					opcode := "01010"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					-- LOad store instructions
					opcode := "10000"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
					opcode := "10010"; -- SUB
					I_op_format <= opcode(4 downto 3);
					I_op <= opcode(2 downto 0);
					wait for period;
					
		end process main;
		
end control_unit_test;
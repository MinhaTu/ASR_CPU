-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Wed Jan 20 14:24:53 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		m_rst :  IN  STD_LOGIC;
		m_en :  IN  STD_LOGIC;
		m_clk :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		O_Inst :  OUT  STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 



COMPONENT mux4
	PORT(sel : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 b: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 y: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;


COMPONENT mux16
	PORT(sel : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 b: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 y: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;



COMPONENT ram
	PORT(we : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 Adress : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fetch
	PORT(I_en : IN STD_LOGIC;
		 I_clk : IN STD_LOGIC;
		 I_rst : IN STD_LOGIC;
		 I_Branch : IN STD_LOGIC;
		 I_Jump : IN STD_LOGIC;
		 I_Immed : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 I_JumpAdress : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 PC_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(op_format : IN STD_LOGIC;
		 op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Register_A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Register_B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 zero : OUT STD_LOGIC;
		 FLAGS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Clock_Divider
	port ( clk,reset: in std_logic;
				 clock_out: out std_logic);
END COMPONENT; 

COMPONENT instruction_memory
GENERIC (DEPTH : INTEGER;
			WIDTH : INTEGER
			);
	PORT(I_rst : IN STD_LOGIC;
		 I_A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 O_Inst : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_file
GENERIC (DEPTH : INTEGER;
			WIDTH : INTEGER
			);
	PORT(I_clk : IN STD_LOGIC;
		 I_rst : IN STD_LOGIC;
		 I_WE : IN STD_LOGIC;
		 I_A1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 I_A2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 I_A3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 I_WD : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 O_RD1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 O_RD2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 O_RDisplay : OUT STD_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT signal_extender_4bits
	PORT(Immed : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Extended_Immed : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT signal_extender_8bits
	PORT(Immed : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Extended_Immed : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT control_unit
	PORT(I_rst : IN STD_LOGIC;
		 I_op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 I_op_format : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 O_RegWrite : OUT STD_LOGIC;
		 O_RegDst : OUT STD_LOGIC;
		 O_ALUsrc : OUT STD_LOGIC;
		 O_Branch : OUT STD_LOGIC;
		 O_MemWrite : OUT STD_LOGIC;
		 O_MemToReg : OUT STD_LOGIC;
		 O_ALUFormat : OUT STD_LOGIC;
		 O_Jump : OUT STD_LOGIC;
		 O_ALUop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 O_StkEn		: OUT std_logic;
		 O_StkToReg	: OUT std_logic;
		 O_StkMode	: OUT std_logic;
		 O_MovToReg	: OUT std_logic
	);
END COMPONENT;


component stack
	GENERIC (DEPTH : INTEGER;
			WIDTH : INTEGER
			);
	PORT(	Data_in : IN std_logic_vector(WIDTH - 1 downto 0);
			mode, en, rst, clk    : IN std_logic;
			Data_out : OUT std_logic_vector(WIDTH - 1  downto 0);
			Full_Control, Empty_Control : OUT std_logic
			);
end component; 

--SIGNAL   m_clk: STD_LOGIC;
--SIGNAL   m_rst: STD_LOGIC;
--SIGNAL   m_en : STD_LOGIC;
SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HE :  STD_LOGIC;
SIGNAL	HEX_ALTERA_SYNTHESIZED0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_ALTERA_SYNTHESIZED4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	I_Branch :  STD_LOGIC;
SIGNAL	I_WD :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	O_ALUFormat :  STD_LOGIC;
SIGNAL	O_ALUop :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	O_ALUsrc :  STD_LOGIC;
SIGNAL	O_Branch :  STD_LOGIC;
SIGNAL	O_Inst_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	O_Jump :  STD_LOGIC;
SIGNAL	O_MemToReg :  STD_LOGIC;
SIGNAL	O_MemWrite :  STD_LOGIC;
SIGNAL	O_RegDst :  STD_LOGIC;
SIGNAL   O_StkEn		: std_logic;
SIGNAL	O_StkToReg	: std_logic;
SIGNAL   O_StkMode	: std_logic;
SIGNAL   O_MovToReg	: std_logic;
SIGNAL	output :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	PC_out :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	Sign_extended :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL   mem_to_stck_WIRE   : STD_LOGIC_vector(15 downto 0);
SIGNAL   Data_stk_out       : std_logic_vector(15 downto 0);
SIGNAL   Full_control 		 : std_logic;
SIGNAL   Empty_control      : std_logic;
SIGNAL 	Sign_extended_8bits : std_logic_vector(15 downto 0);
SIGNAL   stck_to_mov_WIRE   : std_logic_vector(15 downto 0);
SIGNAL   Display_wire 		 : std_logic_vector(15 downto 0);
BEGIN 



b2v_Data_Memory : ram
PORT MAP(we => O_MemWrite,
		 clk => m_clk,
		 rst => m_rst,
		 Adress => output(7 DOWNTO 0),
		 Data_in => SYNTHESIZED_WIRE_13,
		 Data_out => SYNTHESIZED_WIRE_9);

--b2v_Clock_Divider: Clock_Divider
--PORT MAP(reset => m_rst,
--			clk => MAX10_CLK1_50,
--			clock_out => m_clk);
--



b2v_Fetch : fetch
PORT MAP(I_en => m_en,
		 I_clk => m_clk,
		 I_rst => m_rst,
		 I_Branch => I_Branch,
		 I_Jump => O_Jump,
		 I_Immed => Sign_extended(7 DOWNTO 0),
		 I_JumpAdress => O_Inst_ALTERA_SYNTHESIZED(7 DOWNTO 0),
		 PC_out => PC_out);


b2v_inst : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_1,
		 oSEG => HEX_ALTERA_SYNTHESIZED4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_2,
		 oSEG => HEX_ALTERA_SYNTHESIZED3(6 DOWNTO 0));


b2v_inst10 : alu
PORT MAP(op_format => O_ALUFormat,
		 op => O_ALUop,
		 Register_A => SYNTHESIZED_WIRE_3,
		 Register_B => SYNTHESIZED_WIRE_4,
		 zero => SYNTHESIZED_WIRE_12,
		 output => output);


b2v_inst11 : instruction_memory
GENERIC MAP(DEPTH => 256,
			WIDTH => 17
			)
PORT MAP(I_rst => m_rst,
		 I_A => PC_out,
		 O_Inst => O_Inst_ALTERA_SYNTHESIZED);









b2v_inst19 : register_file
GENERIC MAP(DEPTH => 16,
			WIDTH => 16
			)
PORT MAP(I_clk => m_clk,
		 I_rst => m_rst,
		 I_WE => SYNTHESIZED_WIRE_5,
		 I_A1 => O_Inst_ALTERA_SYNTHESIZED(11 DOWNTO 8),
		 I_A2 => O_Inst_ALTERA_SYNTHESIZED(7 DOWNTO 4),
		 I_A3 => SYNTHESIZED_WIRE_6,
		 I_WD => I_WD,
		 O_RD1 => SYNTHESIZED_WIRE_3,
		 O_RD2 => SYNTHESIZED_WIRE_13,
		 O_RDisplay => Display_wire);


b2v_inst2 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_7,
		 oSEG => HEX_ALTERA_SYNTHESIZED2(6 DOWNTO 0));


b2v_muxRegA3 : mux4
PORT MAP(sel => O_RegDst,
		 a => O_Inst_ALTERA_SYNTHESIZED(7 DOWNTO 4),
		 b => O_Inst_ALTERA_SYNTHESIZED(3 DOWNTO 0),
		 y => SYNTHESIZED_WIRE_6);


b2v_muxAluSrc : mux16
PORT MAP(sel => O_ALUsrc,
		 a => SYNTHESIZED_WIRE_13,
		 b => Sign_extended,
		 y => SYNTHESIZED_WIRE_4);


b2v_inst22 : signal_extender_4bits
PORT MAP(Immed => O_Inst_ALTERA_SYNTHESIZED(3 DOWNTO 0),
		 Extended_Immed => Sign_extended);

b2v_signal8bits : signal_extender_8bits
PORT MAP(Immed => O_Inst_ALTERA_SYNTHESIZED(11 downto 4),
			Extended_Immed => Sign_extended_8bits);

b2v_muxMov : mux16
PORT MAP(sel => O_MovToReg,
			 a => stck_to_mov_WIRE,
			 b => Sign_extended_8bits,
			 y => I_WD);
b2v_muxMem : mux16
PORT MAP(sel => O_MemToReg,
		 a => output,
		 b => SYNTHESIZED_WIRE_9,
		 y=> mem_to_stck_WIRE);
		 
b2v_StkReg : mux16
PORT MAP(sel => O_StkToReg,
			a => mem_to_stck_WIRE,
			b => Data_stk_out,
			y => stck_to_mov_WIRE);

b2v_inst3 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_10,
		 oSEG => HEX_ALTERA_SYNTHESIZED1(6 DOWNTO 0));


b2v_inst4 : seg7_lut
PORT MAP(iDIG => SYNTHESIZED_WIRE_11,
		 oSEG => HEX_ALTERA_SYNTHESIZED0(6 DOWNTO 0));


b2v_inst5 : dig2dec
PORT MAP(vol => Display_wire,		 
			seg0 => SYNTHESIZED_WIRE_11,
		 seg1 => SYNTHESIZED_WIRE_10,
		 seg2 => SYNTHESIZED_WIRE_7,
		 seg3 => SYNTHESIZED_WIRE_2,
		 seg4 => SYNTHESIZED_WIRE_1);


b2v_inst6 : control_unit
PORT MAP(I_rst => m_rst,
		 I_op => O_Inst_ALTERA_SYNTHESIZED(14 DOWNTO 12),
		 I_op_format => O_Inst_ALTERA_SYNTHESIZED(16 DOWNTO 15),
		 O_RegWrite => SYNTHESIZED_WIRE_5,
		 O_RegDst => O_RegDst,
		 O_ALUsrc => O_ALUsrc,
		 O_Branch => O_Branch,
		 O_MemWrite => O_MemWrite,
		 O_MemToReg => O_MemToReg,
		 O_ALUFormat => O_ALUFormat,
		 O_Jump => O_Jump,
		 O_ALUop => O_ALUop,
		 O_StkEn => O_StkEn,
		 O_StkToReg => O_StkToReg,
		 O_StkMode => O_StkMode,
		 O_MovToReg => O_MovToReg
);

b2v_stack : stack
GENERIC MAP(DEPTH => 256,
			WIDTH => 16
			)
PORT MAP(Data_in => SYNTHESIZED_WIRE_13,
			mode => O_StkMode,
			en => O_StkEn,
			rst => m_rst,
			clk => m_clk,
			Data_out => Data_stk_out,
			Full_control => Full_control,
			Empty_control => Empty_control);
		
			

I_Branch <= O_Branch AND SYNTHESIZED_WIRE_12;


HEX0 <= HEX_ALTERA_SYNTHESIZED0;
HEX1 <= HEX_ALTERA_SYNTHESIZED1;
HEX2 <= HEX_ALTERA_SYNTHESIZED2;
HEX3 <= HEX_ALTERA_SYNTHESIZED3;
HEX4 <= HEX_ALTERA_SYNTHESIZED4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;
O_Inst <= O_Inst_ALTERA_SYNTHESIZED;
LEDR(1) <= SW(1);
LEDR(2) <= SW(2);
LEDR(9) <= SW(9);
LEDR(8) <= SW(8); 
--m_rst <= SW(9);
--m_en  <= SW(8);
--m_clk <= MAX10_CLK1_50;
zero <= '0';
one <= '1';
HE <= '1';
HEX_ALTERA_SYNTHESIZED0(7) <= '1';
HEX_ALTERA_SYNTHESIZED1(7) <= '1';
HEX_ALTERA_SYNTHESIZED2(7) <= '1';
HEX_ALTERA_SYNTHESIZED3(7) <= '1';
HEX_ALTERA_SYNTHESIZED4(7) <= '1';
END bdf_type;
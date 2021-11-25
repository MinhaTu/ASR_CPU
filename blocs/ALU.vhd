library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity ALU is
    Port ( 
	 		  op_format : in std_logic;
			  Register_A : in  STD_LOGIC_VECTOR (15 downto 0);
           Register_B : in  STD_LOGIC_VECTOR (15 downto 0);
           op : in  STD_LOGIC_VECTOR (2 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0);
           FLAGS : out  STD_LOGIC_VECTOR (3 downto 0);
			  zero : out STD_LOGIC);
			  
end ALU;

architecture ALU_A of ALU is

signal output_value: STD_LOGIC_VECTOR(15 downto 0);

begin

	
	output_value <=     Register_A + Register_B when (op = "000") AND op_format='0' else
					 Register_A - Register_B when (op = "001") AND op_format='0' else
					 std_logic_vector(shift_right(unsigned(Register_A), to_integer(unsigned(Register_B)))) when (op = "010") AND op_format='0'  else
					 std_logic_vector(shift_left(unsigned(Register_A), to_integer(unsigned(Register_B)))) when (op = "011") AND op_format='0'  else
					 Register_A AND Register_B when (op = "100") AND op_format='0' else
					 Register_A OR Register_B when (op = "101") AND op_format='0' else
					 Register_A XOR Register_B when (op = "110") AND op_format='0' else
					 Register_B when (op = "111") AND op_format='0' else 
					 
					 
					 Register_B + "0000000000000001" when (op = "000")  AND op_format='1' else
					 Register_B - "0000000000000001" when (op = "001")  AND op_format='1' else
					 "0000000000000000";
					 
	--overflow
	FLAGS(0)<= 	'1' WHEN (op="000" AND Register_A(15)=Register_B(15) AND output_value(15)/=Register_A(15)  AND op_format='0') or
								(op="001" AND Register_A(15)/=Register_B(15) AND output_value(15)/=Register_A(15)  AND op_format='0') or
								(op="000" AND Register_A(15)='0' AND output_value(15)/=Register_A(15)  AND op_format='1') or
								(op="001" AND Register_A(15)/='0' AND output_value(15)/=Register_A(15)  AND op_format='1') ELSE '0';

	--caryout				
	FLAGS(1)<=  '1' WHEN (op="000" AND Register_A(15)=Register_B(15) AND output_value(15)/=Register_A(15) AND op_format='0')  or
								(op="001" AND Register_A(15)/=Register_B(15) AND output_value(15)/=Register_A(15)  AND op_format='0') or
								(op="000" AND Register_A(15)='0' AND output_value(15)/=Register_A(15) AND op_format='1')  or
								(op="001" AND Register_A(15)/='0' AND output_value(15)/=Register_A(15)  AND op_format='1') ELSE '0';

	
	--negative number
	FLAGS(2)<=  '1' when (output_value(3) = '1') else
					'0';
	
	
	--zero number
	FLAGS(3)<=  '1' when (output_value = "0000000000000000") else
					 '0';
					 
	zero <= '1' when (output_value = "0000000000000000") else
					 '0';

 
	output <= output_value;


end ALU_A;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;

entity control_unit is
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
		  O_Jump			: OUT std_logic;
		  O_StkEn		: OUT std_logic;
		  O_StkToReg	: OUT std_logic;
		  O_StkMode		: OUT std_logic;
		  O_MovToReg	: OUT std_logic
		  );
end control_unit;

architecture rtl of control_unit is
	signal code_bus: std_logic_vector(14 downto 0) := (others => '0');
	begin 
		main:process(I_op_format, I_op, I_rst)
			begin
				if I_rst = '1' then
					code_bus <= (others => '0');
				else 
					
					if I_op_format = "00" then 
						-- R-type operations
						code_bus <= "110000" & '0' & I_op & "000-0";
						
					elsif I_op_format = "01" then
						--I-type operations
						code_bus <= "101000" & '0' & I_op & "000-0";
						 
					elsif I_op_format = "10" then
						case I_op is
							when "010" => code_bus <= "1010010000000-0"; --load
							when "011" => code_bus <= "001010000000--0"; -- store
							when "000" => code_bus <= "1000001000000-0"; -- inc
							when "001" => code_bus <= "1000001001000-0"; -- dec
							when others => code_bus <= "---------------";
						end case;
					elsif I_op_format = "11" then
						case I_op is 
							when "000" => code_bus <= "0---0----110--0"; -- Jump
							when "001" => code_bus <= "0-010-000100--0"; -- beq
							when "010" => code_bus <= "0--00-----01-00"; -- push
							when "011" => code_bus <= "10-00-----01110"; -- pop
							when "100" => code_bus <= "11-00-----00--1"; -- mov
							when others => code_bus <= "---------------";
						end case;
					end if;
				end if;
			
		end process main;
	
	O_RegWrite   <= code_bus(14);
	O_RegDst     <= code_bus(13);
	O_ALUsrc     <= code_bus(12);
	O_Branch     <= code_bus(11);
	O_MemWrite   <= code_bus(10);
	O_MemToReg   <= code_bus(9);
	O_ALUFormat  <= code_bus(8);
	O_ALUop(2)   <= code_bus(7);
	O_ALUop(1)   <= code_bus(6);
	O_ALUop(0)   <= code_bus(5);
	O_Jump		 <= code_bus(4);
	O_StkEn		 <= code_bus(3);
	O_StkToReg	 <= code_bus(2);
	O_StkMode	 <= code_bus(1);
	O_MovToReg	 <= code_bus(0);
end rtl;

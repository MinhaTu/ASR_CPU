LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all ;

-- Instruction memory that stores the ISA 32 bits 
entity instruction_memory is
		generic (WIDTH: natural := 17;
					DEPTH: natural := 256
		);
		port( I_rst: IN std_logic;
				I_A : IN std_logic_vector(7 downto 0);
				O_Inst: OUT std_logic_vector(WIDTH - 1 downto 0)
				);
end instruction_memory;

architecture rtl of instruction_memory is
	type mem is array(0 to DEPTH-1) of std_logic_vector(WIDTH - 1 downto 0);
	signal Data_im: mem;
	

	begin

	------------------- BEGIN ----------
		main:process(I_rst, I_A)
			begin
				-- Reset
				if I_rst = '1' then
				else 
					-- Read-only behave 
					O_Inst <= Data_im(to_integer(unsigned(I_A)));
				end if;
		end process main;

		--Receiving the signals 
			Data_im(1) <= "11100000000000111";  -- MOV R7, #0
			Data_im(2) <= "11100000010100010"; -- MOV R2, #1010
			Data_im(3) <= "11100000011110011"; -- MOV R3, #1111
			Data_im(4) <= "11001001000111010"; -- BEQ R2, R3, Equal = 9
			Data_im(5) <= "00110001000110100"; -- XOR R2,R3, R4
			Data_im(6) <= "11100000000011000"; -- MOV R8, #1
			Data_im(7) <= "11100000000001010";  -- MOV R10, #0 Condição de parada
														  -- Count Routine:
															
			Data_im(8)  <= "00100010010001001";		-- AND R4, R8, R9
			Data_im(9)  <= "01011100010000001";		-- LSHIT R8 one time
			Data_im(10)  <= "11001100110100010";		-- BEQ R9, R10, StopCond = 2
			Data_im(11)  <= "10000----0111----";		-- INC R7
			Data_im(12)  <= "11001100010100010";		-- StopCond: BEQ R8,R10, Equal
			Data_im(13)  <= "11000000000001000";		-- Jump Count Routine 
															--EQUAL: JUMP begin
			Data_iM(14) <= "11000000000000001"; -- JUMP begin
end rtl;
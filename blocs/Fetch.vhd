library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

-- PCplus1 and PCBranch(PCjump)
entity Fetch is
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
end Fetch;


architecture Fetch_a of Fetch is

signal PC_counter: std_logic_vector(7 downto 0);
signal PC_in : std_logic_vector(7 downto 0 );

Begin


	main: Process (I_clk, I_rst)


	begin

		
		if I_rst='1' then
		
			PC_counter<= (others=>'0');
		
		else
		
			If rising_edge(I_clk) then
				if I_en='1' then
				
					If I_Jump = '1' then
						
						PC_counter <= I_JumpAdress;
					elsif I_Branch = '1' then
						PC_counter <= std_logic_vector(signed(I_Immed) + signed(PC_counter));
					else 
						PC_counter <= std_logic_vector(unsigned(PC_counter)+1);
						
					end if;
					
				end if;
				
			end if;
			
		end if;
		
	end Process;

	
PC_out <= PC_counter;


end Architecture Fetch_a;

	
			
	
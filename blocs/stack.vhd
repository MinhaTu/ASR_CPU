LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY stack IS
	GENERIC (
		WIDTH: natural := 4;
		DEPTH: natural := 5
	);
	PORT(	Data_in : IN std_logic_vector(WIDTH - 1 downto 0);
			mode, en, rst, clk    : IN std_logic;
			Data_out : OUT std_logic_vector(WIDTH - 1  downto 0);
			Full_Control, Empty_Control : OUT std_logic
			);
end stack;

architecture stackArchi of stack is

type mem_type is array(0 to DEPTH - 1 ) of std_logic_vector(WIDTH - 1 downto 0);

--signal stack_mem:mem_type := (others=> (others=> '0'));
--signal stck_ptr: natural;
--signal stack_ptr : natural := DEPTH;
begin 

main: process (clk, rst)
	variable stack_mem:mem_type := (others=> (others=> '0'));
	variable empty: std_logic;
	variable full: std_logic;
	variable stack_ptr : natural := DEPTH; -- Points to the most recent element in the stack
	begin 
		--Async Reset
		if (rst = '1') then
			stack_mem := (others => (others => '0'));
			empty := '1';
			full := '0';
			Empty_Control <= empty;
			Full_Control <= full;
			stack_ptr := DEPTH;
		else 
			
			if (rising_edge(clk) and en = '1') then 
				-- Push
				if (mode = '0' and full = '0') then
					stack_ptr := stack_ptr - 1; 
					stack_mem(stack_ptr) := Data_in; 
					Data_out <= stack_mem(stack_ptr);
				-- Pop
				elsif(mode = '1' and empty = '0') then
					
					stack_ptr := stack_ptr + 1;
					if(stack_ptr < DEPTH) then
						Data_out <= stack_mem(stack_ptr);
					end if;
				end if;
				
				-- Check for Empty
				if (stack_ptr = DEPTH) then
					empty := '1';
					Empty_Control <= '1';
				else
					empty := '0';
					Empty_Control <= '0';
				end if;
				
				-- Check for Full
				if (stack_ptr = 0) then
					full := '1';
					Full_Control <= '1';
				else 
					full := '0';
					Full_Control <= '0';
				end if;
			end if;
		end if;
		
	end process main;
	

end stackArchi;
				
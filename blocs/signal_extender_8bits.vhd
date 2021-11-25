library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
USE ieee.std_logic_signed.ALL;



entity signal_extender_8bits is
	Port (
	Immed : in STD_LOGIC_VECTOR (7 downto 0);
	Extended_Immed : out STD_LOGIC_VECTOR (15 downto 0));
end signal_extender_8bits;



architecture signal_exdender_A of signal_extender_8bits is


begin

	Extended_Immed <= std_logic_vector(resize(signed(Immed), Extended_Immed'length));

end signal_exdender_A;
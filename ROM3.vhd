LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM3 IS
	PORT (
		address : IN std_logic_vector(2 DOWNTO 0);
		dataout : OUT std_logic_vector(3 DOWNTO 0)
	);
END ROM3;

ARCHITECTURE RTL OF ROM3 IS
	TYPE MEMORY IS ARRAY (0 TO 7) OF std_logic_vector(3 DOWNTO 0);
	CONSTANT ROM_VAL : MEMORY := (
		x"a", 
		x"b", 
		x"0", 
		x"1", 
		x"2", 
		x"3", 
		x"4", 
		x"f"
	);
BEGIN
	main : PROCESS (address)
	BEGIN
		dataout <= ROM_VAL(to_integer(unsigned(address)));
	END PROCESS main;

END RTL;
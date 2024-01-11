LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM1 IS
	PORT (
		address : IN std_logic_vector(2 DOWNTO 0);
		dataout : OUT std_logic_vector(3 DOWNTO 0)
	);
END ROM1;

ARCHITECTURE RTL OF ROM1 IS
	TYPE MEMORY IS ARRAY (0 TO 7) OF std_logic_vector(3 DOWNTO 0);
	CONSTANT ROM_VAL : MEMORY := (
		x"8", 
		x"9", 
		x"a", 
		x"b", 
		x"c", 
		x"d", 
		x"e", 
		x"1"
	);
BEGIN
	main : PROCESS (address)
	BEGIN
		dataout <= ROM_VAL(to_integer(unsigned(address)));
	END PROCESS main;

END RTL;
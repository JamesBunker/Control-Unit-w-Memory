LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM0 IS
	PORT (
		address : IN std_logic_vector(2 DOWNTO 0);
		dataout : OUT std_logic_vector(3 DOWNTO 0)
	);
END ROM0;

ARCHITECTURE RTL OF ROM0 IS
	TYPE MEMORY IS ARRAY (0 TO 7) OF std_logic_vector(3 DOWNTO 0);
	CONSTANT ROM_VAL : MEMORY := (
		x"c", 
		x"d", 
		x"e", 
		x"f", 
		x"0", 
		x"5", 
		x"6", 
		x"7"
	);
BEGIN
	main : PROCESS (address)
	BEGIN
		dataout <= ROM_VAL(to_integer(unsigned(address)));
	END PROCESS main;

END RTL;
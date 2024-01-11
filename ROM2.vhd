LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM2 IS
	PORT (
		address : IN std_logic_vector(2 DOWNTO 0);
		dataout : OUT std_logic_vector(3 DOWNTO 0)
	);
END ROM2;

ARCHITECTURE RTL OF ROM2 IS
	TYPE MEMORY IS ARRAY (0 TO 7) OF std_logic_vector(3 DOWNTO 0);
	CONSTANT ROM_VAL : MEMORY := (
		x"2", 
		x"3", 
		x"4", 
		x"5", 
		x"6", 
		x"7", 
		x"8", 
		x"9"
	);
BEGIN
	main : PROCESS (address)
	BEGIN
		dataout <= ROM_VAL(to_integer(unsigned(address)));
	END PROCESS main;

END RTL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ArithmeticTop IS
	GENERIC (n : INTEGER);
	PORT (
		A : IN std_logic_vector (n - 1 DOWNTO 0);
		B : IN std_logic_vector (n - 1 DOWNTO 0);
		SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		C : IN std_logic;
		OVF : OUT std_logic;
		SUM : OUT std_logic_vector(n - 1 DOWNTO 0)
	);
END ArithmeticTop;

ARCHITECTURE Structural OF ArithmeticTop IS

	COMPONENT nBitAdder IS
		GENERIC (n : INTEGER);
		PORT (
			Ain : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Bin : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Cin : IN STD_LOGIC;
			S : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Cout : OUT STD_LOGIC
		);
	END COMPONENT nBitAdder;

	COMPONENT nBitALU IS
		GENERIC (n : INTEGER);
		PORT (
			A_nBitALU : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			B_nBitALU : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			SEL_nBitALU : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			Aout_nBitALU : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
			Bout_nBitALU : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
		);
	END COMPONENT nBitALU;

	--signal SUM_padded : std_logic_vector (31 downto 0);
	SIGNAL SEL_TMP : std_logic_vector(2 DOWNTO 0);
	SIGNAL Aout_nBitALU_temp : std_logic_vector(n - 1 DOWNTO 0);
	SIGNAL Bout_nBitALU_temp : std_logic_vector(n - 1 DOWNTO 0);

BEGIN
	SEL_TMP <= SEL & C;

	nBitArithmetic : nBitALU
		GENERIC MAP(n => n)
	PORT MAP(
		A_nBitALU => A, 
		B_nBitALU => B, 
		SEL_nBitALU => SEL_TMP, 
		Aout_nBitALU => Aout_nBitALU_temp, 
		Bout_nBitALU => Bout_nBitALU_temp
	);
		nBitAddition : nBitAdder
			GENERIC MAP(n => n)
	PORT MAP(
		Ain => Aout_nBitALU_temp, 
		Bin => Bout_nBitALU_temp, 
		Cin => C, 
		S => SUM, 
		Cout => OVF
	);

END Structural;
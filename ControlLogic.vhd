LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY ControlLogic IS
	GENERIC (bits : INTEGER);
	PORT (
		clk : IN std_logic;
		instruction : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ROM_num : IN std_logic_vector(2 DOWNTO 0);
		OVF : OUT std_logic_vector(1 DOWNTO 0);
		Cathode : OUT std_logic_vector(7 DOWNTO 0);
		Anode : OUT std_logic_vector(7 DOWNTO 0)
	);
END ControlLogic;

ARCHITECTURE Structural OF ControlLogic IS
	COMPONENT ArithmeticTop IS
		GENERIC (n : INTEGER);
		PORT (
			A : IN std_logic_vector (n - 1 DOWNTO 0);
			B : IN std_logic_vector (n - 1 DOWNTO 0);
			SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			C : IN std_logic;
			OVF : OUT std_logic;
			SUM : OUT std_logic_vector(n - 1 DOWNTO 0)
		);
	END COMPONENT ArithmeticTop;
 
	COMPONENT SSD_logic IS
		PORT (
			clk : IN STD_LOGIC; 
			input : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- 4 bytes * 8 ssd
			Cathode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT SSD_logic;

	COMPONENT ROM0 IS
		PORT (
			address : IN std_logic_vector(2 DOWNTO 0);
			dataout : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ROM1 IS
		PORT (
			address : IN std_logic_vector(2 DOWNTO 0);
			dataout : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ROM2 IS
		PORT (
			address : IN std_logic_vector(2 DOWNTO 0);
			dataout : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ROM3 IS
		PORT (
			address : IN std_logic_vector(2 DOWNTO 0);
			dataout : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;
 
	--inputs
	SIGNAL Arom : std_logic_vector ((bits * 2) - 1 DOWNTO 0);
	SIGNAL Brom : std_logic_vector ((bits * 2) - 1 DOWNTO 0);
 
	--temp values
	SIGNAL SUM_padded_temp : std_logic_vector (31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sum_temp : std_logic_vector ((bits * 2) - 1 DOWNTO 0); 

BEGIN
	-- Generate Statement to instatiate ALUS
	ALU_array : FOR i IN 0 TO 1 GENERATE
		Arithmetic : ArithmeticTop
			GENERIC MAP(n => bits)
		PORT MAP(
			A => Arom(((i + 1) * 4) - 1 DOWNTO i * 4), 
			B => Brom(((i + 1) * 4) - 1 DOWNTO i * 4), 
			SEL => instruction(2 DOWNTO 1), 
			C => instruction(0), 
			OVF => OVF(i), 
			SUM => sum_temp(((i + 1) * 4) - 1 DOWNTO i * 4)
		);
END GENERATE ALU_array;

A1 : ROM0
PORT MAP(address => ROM_num, dataout => Arom(3 DOWNTO 0));
 
B1 : ROM1
PORT MAP(address => ROM_num, dataout => Brom(3 DOWNTO 0));

A2 : ROM2
PORT MAP(address => ROM_num, dataout => Arom((2 * bits) - 1 DOWNTO bits));
 
B2 : ROM3
PORT MAP(address => ROM_num, dataout => Brom((2 * bits) - 1 DOWNTO bits));
 
--setting |A|B| |RES| |A2|B2| |RES2| on SSD
SUM_padded_temp (31 DOWNTO 28) <= Arom(bits - 1 DOWNTO 0);
SUM_padded_temp (27 DOWNTO 24) <= Brom(bits - 1 DOWNTO 0);
SUM_padded_temp (23 DOWNTO 20) <= instruction;
SUM_padded_temp (19 DOWNTO 16) <= sum_temp(bits - 1 DOWNTO 0);

SUM_padded_temp (15 DOWNTO 12) <= Arom((bits * 2) - 1 DOWNTO bits);
SUM_padded_temp (11 DOWNTO 8) <= Brom((bits * 2) - 1 DOWNTO bits);
SUM_padded_temp (7 DOWNTO 4) <= instruction;
SUM_padded_temp (3 DOWNTO 0) <= sum_temp((bits * 2) - 1 DOWNTO bits);

SSD : SSD_logic
PORT MAP(clk => clk, input => SUM_padded_temp, Cathode => Cathode, Anode => Anode);
 

END Structural;
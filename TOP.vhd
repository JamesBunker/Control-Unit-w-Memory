LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY TopLevel IS
	GENERIC (bits : INTEGER := 4);
	PORT (
		clk, RESET, STATE_BUTTONS : IN std_logic;
		REG : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		instruction_input : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		OVF_top : OUT std_logic_vector(1 DOWNTO 0);
		Cathode_top : OUT std_logic_vector(7 DOWNTO 0);
		Anode_top : OUT std_logic_vector(7 DOWNTO 0)
	);
END TopLevel;

ARCHITECTURE Structural OF TopLevel IS

	COMPONENT Control IS
		PORT (
			clk, RESET : IN std_logic;
			STATE_BUTTON : IN std_logic;
			instruction_in : IN std_logic_vector(3 DOWNTO 0);
			REG_IN : IN std_logic_vector(2 DOWNTO 0);
			instruction : OUT std_logic_vector(3 DOWNTO 0);
			REG_OUT : OUT std_logic_vector(2 DOWNTO 0)
		);
	END COMPONENT Control;

	COMPONENT ControlLogic IS
		GENERIC (bits : INTEGER);
		PORT (
			clk : IN std_logic;
			instruction : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			ROM_num : IN std_logic_vector(2 DOWNTO 0);
			OVF : OUT std_logic_vector(1 DOWNTO 0);
			Cathode : OUT std_logic_vector(7 DOWNTO 0);
			Anode : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT ControlLogic;

	SIGNAL instruction_temp : std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL REG_TEMP : std_logic_vector(2 DOWNTO 0) := "000";

BEGIN
	ControlUnit : Control
	PORT MAP(
		clk => clk, 
		RESET => RESET, 
		STATE_BUTTON => STATE_BUTTONS, 
		instruction_in => instruction_input, 
		REG_IN => REG, 
		instruction => instruction_temp, 
		REG_OUT => REG_TEMP
	);

	ProcessorLogic : ControlLogic
		GENERIC MAP(bits => bits)
	PORT MAP(
		clk => clk, 
		instruction => instruction_temp, 
		ROM_num => REG_TEMP, 
		OVF => OVF_top, 
		Cathode => Cathode_top, 
		Anode => Anode_top
	);
END Structural;
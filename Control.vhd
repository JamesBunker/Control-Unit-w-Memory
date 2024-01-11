LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
ENTITY Control IS
	PORT (
		clk, RESET: IN std_logic;
		STATE_BUTTON : in std_logic;
		instruction_in : in std_logic_vector(3 DOWNTO 0);
		REG_IN : in std_logic_vector(2 DOWNTO 0);
		instruction : OUT std_logic_vector(3 DOWNTO 0);
		REG_OUT : OUT std_logic_vector(2 DOWNTO 0)
	);
END Control;

ARCHITECTURE Behavioral OF Control IS
	--control unit
	TYPE state_type IS (IDLE, FE_EX);
	SIGNAL state, next_state : state_type;

BEGIN
	--DEPEND ON CLOCK EVENT TO RESET SYSTEM TO IDLE STATE AND IMPLEMENT STATE_REGISTER BASED ON CLK
	state_register : PROCESS (CLK, RESET)
	BEGIN
		IF (RESET = '1') THEN
			state <= IDLE;
		ELSIF (rising_edge(clk)) THEN
			state <= next_state;
		END IF;
	END PROCESS;

	--SEQUENCE TO DICTATE THE STATE YOU ARE IN GIVEN THE INPUT
	next_state_func : PROCESS (STATE_BUTTON, state)
	BEGIN
		CASE state IS
			WHEN IDLE => 
				IF STATE_BUTTON = '1' THEN
					next_state <= FE_EX;
				ELSE
					next_state <= IDLE;
				END IF;
			WHEN FE_EX => 
				next_state <= IDLE;
		END CASE;
	END PROCESS;

	--CONTROL THE DATAPATH, ITERATING THROUGH REGISTER FILES EACH BUTTON PRESS
	datapath_func : PROCESS (state,instruction_in,REG_IN)
	BEGIN
		CASE state IS
			WHEN IDLE => 
			    
			WHEN FE_EX => 
				instruction <= instruction_in;
				REG_OUT <= REG_IN; 
                
		END CASE;
	END PROCESS;

END Behavioral;
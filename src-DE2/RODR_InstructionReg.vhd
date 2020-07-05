LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;

	ENTITY RODR_InstructionReg IS
	generic(nbits : natural);
	PORT(RODR_IN  : in std_logic_vector (nbits-1 downto 0);
		  RODR_CLK : in std_logic;
		  RODR_CLR : in std_logic;
		  RODR_OUT : out std_logic_vector (nbits-1 downto 0));
	END RODR_InstructionReg ;

ARCHITECTURE LogicFunction OF RODR_InstructionReg IS
	Component RODR_NBit_Shift_Register
		generic(nbits : natural := nbits);
		Port (RODR_CLK : in STD_LOGIC;
				RODR_SET : in STD_LOGIC := '0';
				RODR_CLR : in STD_LOGIC;
				RODR_INS : in STD_LOGIC_VECTOR (7 downto 0) := (Others => '0');
				RODR_INP : in std_LOGIC_VECTOR (nbits-1 downto 0) := (Others => '0');
				Load		: in std_logic := '0';
				EN 		: IN std_logic := '1';
				RODR_OUT : out STD_LOGIC_VECTOR (nbits-1 downto 0));
	END Component;
	
	begin
		
		uut : RODR_NBit_Shift_Register PORT MAP (RODR_CLK, open, RODR_CLR, open,RODR_IN,  '0','1', RODR_OUT);


END LogicFunction;


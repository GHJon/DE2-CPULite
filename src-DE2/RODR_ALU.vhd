LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;

	ENTITY RODR_ALU IS
	generic(nbits : natural := 32);
	PORT(RODR_IN1    : in std_logic_vector(nbits-1 downto 0);
		  RODR_IN2    : in std_logic_vector(nbits-1 downto 0);
		  RODR_ALUCtr : in std_logic_vector (1 downto 0);
		  RODR_OUT    : out std_logic_vector(nbits-1 downto 0));
	END RODR_ALU ;

ARCHITECTURE LogicFunction OF RODR_ALU IS

signal tempOut : std_logic_vector (nbits -1 downto 0) := (others => '0');


Begin

process(RODR_IN1, RODR_IN2, RODR_ALUCtr, tempOut)
begin
	
	case RODR_ALUCtr is
		when "00" => -- ADD
			tempOut <= RODR_IN1 + RODR_IN2;
		when "01" => -- SUB
			tempOut <= RODR_IN1 - RODR_IN2;
		when "10" => -- ORI
			tempOut <= RODR_IN1 OR RODR_IN2;
		when others =>
			tempOut <= (others => '0');
	end case;
	
	RODR_Out <= tempOut;
end process;


END LogicFunction;


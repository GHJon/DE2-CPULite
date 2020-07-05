LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;

	ENTITY RODR_PC IS
	generic(nbits : natural := 32);
	PORT(RODR_IN  : in std_logic_vector (nbits-1 downto 0);
		  RODR_CLK : in std_logic;
		  RODR_OUT : out std_logic_vector (nbits-1 downto 0));
	END RODR_PC ;

ARCHITECTURE LogicFunction OF RODR_PC IS
	
	begin
	 
	process(RODR_IN, RODR_CLK)
	variable PCNext : std_logic_vector(nbits-1 downto 0) := RODR_IN;
	begin 
		if(Rising_Edge(RODR_CLK)) then
			  PCNext := RODR_IN;
			  RODR_Out <= PCNext;
		end if;		
	end process;

END LogicFunction;







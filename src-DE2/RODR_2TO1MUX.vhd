library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------

entity RODR_2TO1MUX is

	generic(nbits: natural);
	port(	RODR_A:	in std_logic_vector(nbits-1 downto 0);
		RODR_B:	in std_logic_vector(nbits-1 downto 0);
		RODR_SEL : in std_logic;
		RODR_OUT : Out std_logic_vector(nbits-1 downto 0));

end RODR_2TO1MUX;

--------------------------------------------------------

architecture LogicFunction of RODR_2TO1MUX is
begin
	process(RODR_SEL, RODR_A, RODR_B)
	begin 
	
		case RODR_SEL is
	
		when '0' =>
			RODR_OUT <= RODR_A;
		when others =>
			RODR_Out <= RODR_B;
		end case;
	end process;

end LogicFunction;
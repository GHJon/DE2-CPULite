library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------

entity RODR_Extender is

	generic(nbits: natural := 16);
	port(	RODR_IN:	in std_logic_vector(nbits-1 downto 0);
		RODR_SEL: in std_logic;
		RODR_OUT : Out std_logic_vector(nbits*2-1 downto 0));

end RODR_Extender;

--------------------------------------------------------

architecture LogicFunction of RODR_Extender is
begin

process(RODR_IN, RODR_SEL)
begin
	if(RODR_SEL = '0') then  -- OR IMMEDIATE
		RODR_Out <= std_logic_vector(resize(unsigned(RODR_IN), RODR_OUT'length));
	else							-- LOAD and STORE Instructions
		RODR_Out <= std_logic_vector(resize(signed(RODR_IN), RODR_OUT'length));
	end if;
end process;
end LogicFunction;
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

	ENTITY RODR_InstrMem IS
	generic(nbits : natural := 32);
	PORT(RODR_PCSource : in std_logic_vector (nbits-1 downto 0);
		  RODR_CLK : in std_logic;
		  RODR_Out : out std_logic_vector (nbits-1 downto 0));
	END RODR_InstrMem ;

ARCHITECTURE LogicFunction OF RODR_InstrMem IS

type RODR_Memory is array (0 to 31) of std_logic_vector(nbits-1 downto 0);

signal RODR_InstructionMem : RODR_Memory := (
	"00000000000000010001000000100000",  -- Add $r2, $r0, $r1
	"00000000000000010001000000100010",  -- Sub $r2, $r0, $r1
	"00110100000000010000000000000010",  -- ori $r1, $r0, 1
	"10001100000000010000000000000001",  -- lw $r1, $r0, 1
	"10101000000000010000000000000001",  -- sw $r1, $r0, 1
	"00010000000000010000000000000001",  -- BEQ $r0, $r1, 1
	"00010100000000010000000000000001",   -- BNE $r0, $r1, 1
	others=> (others=>'0'));

Begin

process(RODR_PCSource, RODR_CLK)
begin
	if(Rising_Edge(RODR_CLK)) then
		RODR_Out <= RODR_InstructionMem(to_integer(unsigned(RODR_PCSource)));
	end if;
end process;


END LogicFunction;


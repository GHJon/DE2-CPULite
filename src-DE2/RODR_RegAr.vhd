LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

	ENTITY RODR_RegAr IS
	generic(nbits : natural := 32);
	PORT(RODR_SrcAddr    : IN STD_LOGIC_VECTOR (4 downto 0);
		  RODR_SrcAddr2   : IN STD_Logic_Vector (4 downto 0);
		  RODR_DstAddr    : IN STD_Logic_vector (4 downto 0);
		  RODR_Data       : in std_logic_vector (31 downto 0);
		  RODR_RegWr      : in std_logic;
  		  RODR_Clock      : in std_logic;
	     RODR_OUT1       : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     RODR_OUT2       : OUT STD_LOGIC_VECTOR (nbits-1 downto 0));
END RODR_RegAr ;

ARCHITECTURE LogicFunction OF RODR_RegAr IS

type RODR_RegInput is array (0 to 31) of std_logic_vector(nbits-1 downto 0);
signal r : RODR_RegInput := (others=> (others=>'0'));		

begin

process(RODR_SrcAddr, RODR_SrcAddr2, RODR_DstAddr, RODR_RegWr, RODR_Clock, RODR_Data)
variable srcreg1, srcreg2, destreg : std_logic_vector (4 downto 0) := (others => '0');
variable Data : std_logic_vector (31 downto 0) := (others => '0');
variable regwr : std_logic := '0';
Begin

	srcreg1 := RODR_SrcAddr;
	srcreg2 := RODR_SrcAddr2;
	destreg := RODR_DstAddr;
	regwr := RODR_RegWr;
	Data := RODR_Data;
	
	if(rising_edge(RODR_Clock)) then
		RODR_OUT1 <= r(to_integer(unsigned(srcreg1)));
		RODR_OUT2 <= r(to_integer(unsigned(srcreg2)));
		case regwr is
			When '0' =>
			When '1' =>
				r(to_integer(unsigned(destreg))) <= Data;
			When others =>
		end case;
	end if;
end process;
END LogicFunction;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

	ENTITY RODR_DataMem IS
	generic(nbits : natural := 32);
	PORT(RODR_WrEN    : in std_logic;
		  RODR_Addr    : in std_logic_vector(nbits-1 downto 0);
		  RODR_DataIN  : in std_logic_vector(nbits-1 downto 0);
		  RODR_Clock   : in std_logic;
		  RODR_DataOUT : out std_logic_vector(nbits-1 downto 0));
	END RODR_DataMem ;

ARCHITECTURE LogicFunction OF RODR_DataMem IS

type RODR_Memory is array (0 to 31) of std_logic_vector(nbits-1 downto 0);
signal RODR_DataMemory : RODR_Memory := ( others=> (others=>'0'));

Begin

process(RODR_DataMemory, RODR_WrEN, RODR_Addr, RODR_DataIN, RODR_Clock)
variable WriteEN : std_logic := '0';
variable address, datain, dataout : std_logic_vector(nbits-1 downto 0) := (others => '0');
begin

	WriteEN := RODR_WrEN;
	address := RODR_Addr;
	datain := RODR_DataIN;
	
	if(rising_edge(RODR_Clock)) then
		case writeEN is
			when '0' =>	-- Load
			dataout :=	RODR_DataMemory(to_integer(unsigned(address)));
			when '1' => -- Store
				RODR_DataMemory(to_integer(unsigned(address))) <= Datain;
				dataout := (others => '0');
			when others =>
		end case;
		RODR_DataOut <= dataout;
	end if;
end process;
END LogicFunction;


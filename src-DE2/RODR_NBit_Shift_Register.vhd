library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RODR_NBit_Shift_Register is
	generic(nbits : integer := 32);
	Port (RODR_CLK : in STD_LOGIC;
			RODR_SET : in STD_LOGIC := '0';
			RODR_CLR : in STD_LOGIC;
			 RODR_INS : in STD_LOGIC_VECTOR (7 downto 0) := (Others => '0');
			 RODR_INP: in std_LOGIC_VECTOR (nbits-1 downto 0) := (Others => '0');
			 Load		: in std_logic := '0';
			 EN 		: IN std_logic := '0';
		    RODR_OUT : out STD_LOGIC_VECTOR (nbits-1 downto 0));
end RODR_NBit_Shift_Register ;

architecture Behavioral of RODR_NBit_Shift_Register is
signal tempOut : std_LOGIC_VECTOR (nbits-1 downto 0);		-- Bit storage for Shifting and Set/Clear

shared variable index: integer := nbits-8;
begin
	process(RODR_CLK, RODR_CLR, RODR_SET, RODR_INP, RODR_INS, tempOut, Load, EN)
	variable countINS : integer := 0;
	begin
		if(RODR_CLR ='1' AND RODR_SET = '0' AND EN = '1') then
			tempOut <= (others => '0');
			index := nbits-8;
		elsif(RODR_SET ='1' AND RODR_CLR = '0' AND EN = '1') then
			tempOut <= (others => '1');
			index := nbits-8;
		elsif (rising_edge(RODR_CLK)) then
			if(load = '1' AND EN = '1') then
				tempOut(index+7 downto index) <= RODR_INS;
				index := index-8;
				countINS := countINS + 1; 
			elsif(load = '0' AND EN = '1') then
				tempOut <= RODR_INP;
			end if;
		end if;
		if(countINS  = 4) then
			RODR_OUT <= tempOut;
			countINS := 0;
		end if;
		if(load = '0' AND EN = '1') then
			RODR_OUT <= tempOut;
		end if;
	end process;
end Behavioral;

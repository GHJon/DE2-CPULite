LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

	ENTITY RODR_RegisterArray IS
	generic(nbits : natural := 32);
	PORT(RODR_IN  : IN STD_LOGIC_VECTOR (nbits-1 downto 0);
		  RODR_Data: IN std_logic_vector (nbits-1 downto 0) := (others => '0');
		  RODR_SET	   : in std_logic := '0';
		  RODR_Clear  : in std_logic;
		  RODR_Load	  : in std_logic := '0';
		  RODR_ClockOPS : in std_logic;
  		  RODR_ClockREG : in std_logic;
		  RODR_DataCLK : in std_logic;
		  RODR_DataSEL : in std_logic_vector (4 downto 0);
	     output1  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output2  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output3  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output4  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output5  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output6  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output7  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output8  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output9  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output10  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output11 : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output12  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output13  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output14  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output15  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output16  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output17  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output18  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output19  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output20  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output21  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output22  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output23  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output24  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output25  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output26  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output27 : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output28  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output29  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output30  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output31  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     output32  : OUT STD_LOGIC_VECTOR (nbits-1 downto 0));
END RODR_RegisterArray ;


ARCHITECTURE LogicFunction OF RODR_RegisterArray IS

type RODR_RegInput is array (0 to 31) of std_logic_vector(nbits-1 downto 0);

signal r : RODR_RegInput := ((Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'));

type RODR_RegInput2 is array (0 to 31) of std_logic_vector(nbits*2-1 downto 0);

signal s : RODR_RegInput2 := ((Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'),
                             (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0'), (Others => '0') , (Others => '0') , (Others => '0') , (Others => '0'));
							
	Component RODR_NBit_Shift_Register
		generic(nbits : natural := nbits);
		Port (RODR_CLK : in STD_LOGIC;
				RODR_SET : in STD_LOGIC := '0';
				RODR_CLR : in STD_LOGIC;
				RODR_INS : in STD_LOGIC_VECTOR (7 downto 0) := (Others => '0');
				RODR_INP : in std_LOGIC_VECTOR (nbits-1 downto 0) := (Others => '0');
				Load		: in std_logic := '0';
				RODR_OUT : out STD_LOGIC_VECTOR (nbits-1 downto 0));
	END Component;
	
	signal RODR_OPCODE : std_logic_vector(5 downto 0);
	signal RODR_RS : std_logic_vector(4 downto 0);
	signal RODR_RT: std_logic_vector(4 downto 0);
	signal RODR_RD: std_logic_vector(4 downto 0);
	signal RODR_SHAMT: std_logic_vector(4 downto 0);
	signal RODR_FUNCT: std_logic_vector(5 downto 0);
	signal RODR_IMMEDIATE : std_logic_vector(31 downto 0) := (others => '0');
--	signal RODR_ADDRESS: std_logic_vector(25 downto 0);
	signal RODR_tempData : std_logic_vector(nbits-1 downto 0);
	
BEGIN
    
			Register1  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(0), '0', output1); 
			Register2  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(1), '0', output2); 
			Register3  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(2), '0', output3); 
			Register4  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(3), '0', output4); 
			Register5  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(4), '0', output5); 
			Register6  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(5), '0', output6); 
			Register7  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(6), '0', output7); 
			Register8  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(7), '0', output8);
			Register9  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(8), '0', output9); 
			Register10  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(9), '0', output10); 
			Register11  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(10), '0', output11); 
			Register12  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(11), '0', output12); 
			Register13  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(12), '0', output13); 
			Register14  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(13), '0', output14); 
			Register15  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(14), '0', output15); 
			Register16  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(15), '0', output16);
			Register17  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(16), '0', output17); 
			Register18  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(17), '0', output18); 
			Register19  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(18), '0', output19); 
			Register20  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(19), '0', output20); 
			Register21  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(20), '0', output21); 
			Register22  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(21), '0', output22); 
			Register23  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(22), '0', output23); 
			Register24  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(23), '0', output24);
			Register25  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(24), '0', output25); 
			Register26  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(25), '0', output26); 
			Register27  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(26), '0', output27); 
			Register28  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(27), '0', output28); 
			Register29  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(28), '0', output29); 
			Register30  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(29), '0', output30); 
			Register31  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(30), '0', output31); 
			Register32  : RODR_NBit_Shift_Register PORT MAP(RODR_ClockREG, open, RODR_Clear, open, r(31), '0', output32);
			
			RODR_OPCODE <= RODR_IN(nbits-1 downto nbits-6);
			RODR_RS <= RODR_IN(nbits-7 downto nbits-11);
			RODR_RT <= RODR_IN(nbits-12 downto nbits-16);
			RODR_RD <= RODR_IN(nbits-17 downto nbits-21);
			RODR_SHAMT <= RODR_IN(nbits-22 downto nbits-26);
			RODR_FUNCT <= RODR_IN(nbits-27 downto nbits-32);
		   RODR_IMMEDIATE <= std_logic_vector(resize(unsigned(RODR_IN(nbits-17 downto nbits-32)), RODR_IMMEDIATE'length));
--	      RODR_ADDRESS <= RODR_IN(nbits-7 downto nbits-32);
			RODR_tempData <= RODR_Data;

	process(r, s, RODR_OPCODE, RODR_RS, RODR_RT, RODR_RD, RODR_SHAMT, RODR_FUNCT, RODR_IMMEDIATE, RODR_ClockOPS, RODR_tempData, RODR_DataSEL, RODR_DataCLK)	-- STORAGE OF INPUTS INTO REGISTER
	  
	   variable RODR_temp1 : std_logic_vector(31 downto 0) := (others => '0');
	   variable RODR_temp2 : std_logic_vector(31 downto 0) := (others => '0');
	   variable RODR_temp1Resize: std_logic_vector(63 downto 0):= (others => '0');
	   variable RODR_temp : std_logic_vector(63 downto 0) := (others => '0');
	   variable RODR_tempLast : std_logic_vector(63 downto 0) := (others => '0');
	   variable RODR_counter: integer := 0;
	   variable RODR_ans: std_logic_vector (63 downto 0) :=(others => '0');
	   variable RODR_shift : integer := 0;
	   variable RODR_carry: std_logic := '0';
	   variable RODR_tempACC : std_logic_vector(63 downto 0) := (others => '0');
	   variable RODR_Add1 : integer := 0;
	   variable RODR_Add2 : integer := 0;
	   variable zero  : std_logic_vector (63 downto 0) := (others => '0');
	   
	  variable addA, addB, addC, addD, addE, addF, addG, addH, addI, addJ, addK, addL, addM, addN, addO, addP : std_logic_vector(nbits*2-1 downto 0) := (others => '0');                
    variable addlevelTwoA, addlevelTwoB, addlevelTwoC, addlevelTwoD, addlevelTwoE, addlevelTwoF, addlevelTwoG, addlevelTwoH : std_logic_vector(nbits*2 -1 downto 0):= (others => '0');
    variable addlevelThreeA, addlevelThreeB, addlevelThreeC, addlevelThreeD : std_logic_vector(nbits*2-1 downto 0):= (others => '0');                                                 
    variable addlevelFourA, addlevelFourB : std_logic_vector(nbits*2-1 downto 0):= (others => '0');                                                                                   
    variable addlevelFive_Out : std_logic_vector(nbits*2-1 downto 0):= (others => '0');                                                                                               

	BEGIN
	if(rising_edge(RODR_ClockOPS)) then
		if(RODR_DataCLK = '1') then
			r(to_integer(unsigned(RODR_DataSel))) <= RODR_tempData;
			
		elsif(RODR_DataCLK = '0') then 
			if(RODR_OPCODE = "000000") then
				case RODR_FUNCT is 
					when "000001" => -- not (1 HEX)
						r(to_integer(unsigned(RODR_RD))) <= not r(to_integer(unsigned(RODR_RS)));
					
					when "100100" => -- AND (24 HEX)
						r(to_integer(unsigned(RODR_RD))) <= r(to_integer(unsigned(RODR_RS))) AND r(to_integer(unsigned(RODR_RT)));
			
					when "100111" => -- NOR (27 HEX)
						r(to_integer(unsigned(RODR_RD))) <= r(to_integer(unsigned(RODR_RS))) NOR r(to_integer(unsigned(RODR_RT)));				
					when "100101" => -- OR  (25 HEX)
						r(to_integer(unsigned(RODR_RD))) <= r(to_integer(unsigned(RODR_RS))) OR r(to_integer(unsigned(RODR_RT)));				
					when "100110" => -- XOR (26 HEX)
						r(to_integer(unsigned(RODR_RD))) <= r(to_integer(unsigned(RODR_RS))) XOR r(to_integer(unsigned(RODR_RT)));				
					when "000000" => -- Shift Left (0 HEX)
						r(to_integer(unsigned(RODR_RD))) <= to_stdlogicvector(to_bitvector(r(to_integer(unsigned(RODR_RT)))) sll to_integer(unsigned(RODR_SHAMT)));
				
					when "000010" => -- Shift Right (2 HEX)
						r(to_integer(unsigned(RODR_RD))) <= to_stdlogicvector(to_bitvector(r(to_integer(unsigned(RODR_RT)))) srl to_integer(unsigned(RODR_SHAMT)));				
					when "000111" => -- Rotate Left (7 HEX)
						r(to_integer(unsigned(RODR_RD))) <= to_stdlogicvector(to_bitvector(r(to_integer(unsigned(RODR_RT)))) rol to_integer(unsigned(RODR_SHAMT)));
				
					when "001000" => -- Rotate Right (8 HEX)
						r(to_integer(unsigned(RODR_RD))) <= to_stdlogicvector(to_bitvector(r(to_integer(unsigned(RODR_RT)))) ror to_integer(unsigned(RODR_SHAMT)));
						
					when "101011" => -- sltu (2B HEX)
						if(r(to_integer(unsigned(RODR_RS))) < r(to_integer(unsigned(RODR_RT)))) then
							r(to_integer(unsigned(RODR_RD))) <= "00000000000000000000000000000001";
						else
							r(to_integer(unsigned(RODR_RD))) <= "00000000000000000000000000000000";
						end if;
					when "101010" => -- -- slts (2A HEX)
						if(signed(r(to_integer(unsigned(RODR_RS)))) < signed(r(to_integer(unsigned(RODR_RT))))) then
							r(to_integer(unsigned(RODR_RD))) <= "00000000000000000000000000000001";
						else
							r(to_integer(unsigned(RODR_RD))) <= "00000000000000000000000000000000";
						end if;
												
	        when "111101" => -- Multiply Accum (Magnitude)(3D HEX)
              RODR_temp1 := r(to_integer(unsigned(RODR_RS)));
              RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64));
              RODR_temp2 := r(to_integer(unsigned(RODR_RT)));
              RODR_shift := 0;
              RODR_temp := (others => '0');
              
        						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      s(i) <= zero;
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      s(i) <= to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;
			       addA := s(0) + s(1);
						 addB := s(2) + s(3);
						 addC := s(4) + s(5);
						 addD := s(6) + s(7);
						 addE := s(8) + s(9);
						 addF := s(10) + s(11);
						 addG := s(12) + s(13);
						 addH := s(14) + s(15)	;
						 addI := s(16) + s(17);
						 addJ := s(18) + s(19);
						 addK := s(20) + s(21);
						 addL := s(22) + s(23);
						 addM := s(24) + s(25);
						 addN := s(26) + s(27);
						 addO := s(28) + s(29);
						 addP := s(30) + s(31);			
						 
						 addlevelTwoA:= addA + addB;
						 addlevelTwoB:= addC + addD;
						 addlevelTwoC:= addE + addF;
						 addlevelTwoD:= addG + addH;
						 addlevelTwoE:= addI + addJ;
						 addlevelTwoF:= addK + addL;
						 addlevelTwoG:= addM + addN;
						 addlevelTwoH:= addO + addP;	
						 
						 addlevelThreeA:= addlevelTwoA + addlevelTwoB;
						 addlevelThreeB:= addlevelTwoC + addlevelTwoD;
						 addlevelThreeC:= addlevelTwoE + addlevelTwoF;
						 addlevelThreeD:= addlevelTwoG + addlevelTwoH;
						 
						 addlevelFourA:= addlevelTwoA + addlevelTwoB;
						 addlevelFourB:= addlevelTwoC + addlevelTwoD;
						 
						 addlevelFive_Out:= addlevelFourA + addlevelFourA;		
						 RODR_temp := addlevelFive_Out;			 
						 r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32);
             r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp(31 downto 0);
          
						
          when "011000" => -- Multiply Signed (18 HEX)
						RODR_temp1 := r(to_integer(unsigned(RODR_RS)));
      						RODR_temp2 := r(to_integer(unsigned(RODR_RT)));
						RODR_shift := 0;
						RODR_temp := (others => '0');
            
            if(RODR_temp1(31) = '0' and RODR_temp2(31) = '0') then
            RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64));
      						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      RODR_ans := to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_temp := RODR_temp + RODR_ans;
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;

						r(to_integer(unsigned(RODR_RD))+ 1) <= RODR_temp(31 downto 0); --LO
						r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32); -- HI
		

					  elsif(RODR_temp1(31) = '1' and RODR_temp2(31) = '0') then
					  RODR_temp1 := not RODR_temp1 + 1;
					  RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64));
					  
      						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      RODR_ans := to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_temp := RODR_temp + RODR_ans;
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;
            RODR_temp := not RODR_temp + 1;
						r(to_integer(unsigned(RODR_RD))+ 1) <= RODR_temp(31 downto 0); --LO
						r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32); -- HI

					  
				    elsif(RODR_temp1(31) = '0' and RODR_temp2(31) = '1') then
				    RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64));
					  RODR_temp2 := not RODR_temp2 + 1;
					  
      						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      RODR_ans := to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_temp := RODR_temp + RODR_ans;
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;
            RODR_temp := not RODR_temp + 1;
						r(to_integer(unsigned(RODR_RD))+ 1) <= RODR_temp(31 downto 0); --LO
						r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32); -- HI

					   					  
					  elsif(RODR_temp1(31) = '1' and RODR_temp2(31) = '1') then
					  RODR_temp1 := not RODR_temp1 + 1;
					  RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64));
					  RODR_temp2 := not RODR_temp2 + 1;
					  
      						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      RODR_ans := to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_temp := RODR_temp + RODR_ans;
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;

						r(to_integer(unsigned(RODR_RD))+ 1) <= RODR_temp(31 downto 0); --LO
						r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32); -- HI
			
					  end if;	   
          
          when "011001" => -- Multiply Unsigned (19 HEX)
      						RODR_temp1 := r(to_integer(unsigned(RODR_RS)));
      						RODR_temp1Resize := std_logic_vector(resize(unsigned(RODR_temp1), 64)); 
      						RODR_temp2 := r(to_integer(unsigned(RODR_RT)));
						RODR_shift := 0; 
						RODR_temp := (others => '0');
      						
      						for i in 0 to 31 loop
      						    if(RODR_temp2(i) = '0') then
      						      RODR_shift := RODR_shift + 1;
						    elsif(RODR_temp2(i) = '1') then
      						      RODR_ans := to_stdlogicvector(to_bitvector(RODR_temp1Resize) sll RODR_shift);
      						      RODR_temp := RODR_temp + RODR_ans;
      						      RODR_shift := RODR_shift + 1;
						    end if;
						 end loop;       
						r(to_integer(unsigned(RODR_RD))+ 1) <= RODR_temp(31 downto 0); --LO
						r(to_integer(unsigned(RODR_RD))) <= RODR_temp(63 downto 32); -- HI
						
				  when "011010" => -- Divide Signed(1A HEX)
				    RODR_temp1 := r(to_integer(unsigned(RODR_RS)));
					  RODR_temp2 := r(to_integer(unsigned(RODR_RT)));
					  RODR_counter := 0;
					  
					  if(RODR_temp1(31) = '0' and RODR_temp2(31) = '0') then
					     while RODR_temp1 >= RODR_temp2 loop
					       RODR_temp1 := RODR_temp1 - RODR_temp2;
					       RODR_counter := RODR_counter + 1;
					     end loop;
			  	    r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp1;
					   r(to_integer(unsigned(RODR_RD))) <= std_logic_vector(to_unsigned(RODR_counter, 32));				

					  elsif(RODR_temp1(31) = '1' and RODR_temp2(31) = '0') then
					  RODR_temp1 := not RODR_temp1 + 1;
					     while RODR_temp1 >= RODR_temp2 loop
					       RODR_temp1 :=  RODR_temp1 - RODR_temp2;
					       RODR_counter := RODR_counter - 1;
					     end loop;
					   r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp1;
					   r(to_integer(unsigned(RODR_RD))) <= (std_logic_vector(to_signed(RODR_counter, 32)));				
					  
				    elsif(RODR_temp1(31) = '0' and RODR_temp2(31) = '1') then
					  RODR_temp2 := not RODR_temp2 + 1;
					     while RODR_temp1 >= RODR_temp2 loop
					       RODR_temp1 :=  RODR_temp1 - RODR_temp2;
					       RODR_counter := RODR_counter - 1;
					     end loop;
					   r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp1;
					   r(to_integer(unsigned(RODR_RD))) <= (std_logic_vector(to_signed(RODR_counter, 32)));
					   					  
					  elsif(RODR_temp1(31) = '1' and RODR_temp2(31) = '1') then
					  RODR_temp1 := not RODR_temp1 + 1;
					  RODR_temp2 := not RODR_temp2 + 1;
					     while RODR_temp1 >= RODR_temp2 loop
					       RODR_temp1 := RODR_temp1 - RODR_temp2;
					       RODR_counter := RODR_counter + 1;
					     end loop;
			  	    r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp1;
					   r(to_integer(unsigned(RODR_RD))) <= std_logic_vector(to_unsigned(RODR_counter, 32));				
					  end if;	   
					  
					when "011011" => -- Divide Unsigned(1B HEX)
					  RODR_temp1 := r(to_integer(unsigned(RODR_RS)));
					  RODR_temp2 := r(to_integer(unsigned(RODR_RT)));
					  RODR_counter := 0;
					  
					  while RODR_temp1 >= RODR_temp2 loop
					     RODR_temp1 := RODR_temp1 - RODR_temp2;
					     RODR_counter := RODR_counter + 1;
					  end loop;
					   r(to_integer(unsigned(RODR_RD))+1) <= RODR_temp1;
					   r(to_integer(unsigned(RODR_RD))) <= std_logic_vector(to_unsigned(RODR_counter, 32));
					 
					when others =>
						null;
				
				end case;
			elsif (RODR_OPCODE /= "000000") then
				case RODR_OPCODE is 
					when "001100" => -- AND IMMEDIATE (C HEX)
						r(to_integer(unsigned(RODR_RT))) <= r(to_integer(unsigned(RODR_RS))) AND RODR_IMMEDIATE;
					when "001101" => -- OR IMMEDIATE (D HEX)
						r(to_integer(unsigned(RODR_RT))) <= r(to_integer(unsigned(RODR_RS))) OR RODR_IMMEDIATE;
					when "001011" =>	-- sltiu (B HEX)
						if(unsigned(r(to_integer(unsigned(RODR_RS)))) < unsigned(RODR_IMMEDIATE)) then
							r(conv_integer(RODR_RT)) <= "00000000000000000000000000000001";
						else
							r(conv_integer(RODR_RT)) <= "00000000000000000000000000000000";
						end if;
					when "001010" =>	-- sltis (A HEX)
						if(signed(r(to_integer(unsigned(RODR_RS)))) < signed(RODR_IMMEDIATE)) then
							r(to_integer(unsigned(RODR_RT))) <= "00000000000000000000000000000001";
						else
							r(to_integer(unsigned(RODR_RT))) <= "00000000000000000000000000000000";
						end if;	
				  when "100100" => -- BEQ(44 HEX)
				     if(r(to_integer(unsigned(RODR_RS))) = r(to_integer(unsigned(RODR_RT)))) then
				        PC <= PC + 4 + RODR_Immediate;
				     else
				        PC <= PC + 4;
				  when "100101" => -- BNE(45 HEX)
				     if(r(to_integer(unsigned(RODR_RS))) /= r(to_integer(unsigned(RODR_RT)))) then
				        PC <= PC + 4 + RODR_Immediate;
				     else
				        PC <= PC + 4;
				  when "000011" => -- Jump And Link (3 HEX)
				        PC <= PC + 4 + RODR_Immediate;
				        r(to_integer(unsigned(RODR_RS)) <= PC;

					when others =>
						null;
				
				end case;
			end if;
		end if;
	end if;
	end process;
END LogicFunction;


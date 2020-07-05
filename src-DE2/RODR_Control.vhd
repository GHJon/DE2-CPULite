LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;

	ENTITY RODR_Control IS
	generic(nbits : natural := 32);
	PORT(RODR_IN : in std_logic_vector(nbits-1 downto 0);
		  RODR_Zero : in std_logic_vector (nbits -1 downto 0);
		  RODR_ALUCtr    : out std_logic_vector (1 downto 0); -- Control (ADD, SUB, ORI)
		  RODR_MemWr     : out std_logic; -- Control deciding when to write into a register or not
		  RODR_MemtoReg  : out std_logic; -- Control Deciding when to take data from Data Memory into register
		  RODR_RegWr     : out std_logic; -- Control deciding whether to write or not to a register
		  RODR_ExtOp     : out std_logic; -- Control deciding whether to zero extend or sign extend
		  RODR_ALUSrc    : out std_logic; -- Control Deciding between busB from RegAr OR immExtend32
		  RODR_RegDst	  : out std_logic; -- Control Deciding between RT and RD register
		  RODR_PCSrc     : out std_logic);
	END RODR_Control ;

ARCHITECTURE LogicFunction OF RODR_Control IS

	signal RODR_OPCODE : std_logic_vector(5 downto 0);
	signal RODR_RS : std_logic_vector(4 downto 0);
	signal RODR_RT: std_logic_vector(4 downto 0);
	signal RODR_RD: std_logic_vector(4 downto 0);
	signal RODR_SHAMT: std_logic_vector(4 downto 0);
	signal RODR_FUNCT: std_logic_vector(5 downto 0);
	signal RODR_IMMEDIATE : std_logic_vector(15 downto 0);
Begin
	RODR_OPCODE <= RODR_IN(nbits-1 downto nbits-6);
	RODR_RS <= RODR_IN(nbits-7 downto nbits-11);
	RODR_RT <= RODR_IN(nbits-12 downto nbits-16);
	RODR_RD <= RODR_IN(nbits-17 downto nbits-21);
	RODR_SHAMT <= RODR_IN(nbits-22 downto nbits-26);
	RODR_FUNCT <= RODR_IN(nbits-27 downto nbits-32);
	RODR_IMMEDIATE <= RODR_IN(nbits-17 downto nbits-32);
	
process(RODR_OPCODE, RODR_RS, RODR_RT, RODR_RD, RODR_SHAMT, RODR_FUNCT, RODR_IMMEDIATE, RODR_Zero)
variable ALUctr : std_logic_vector (1 downto 0) := (others => '0');
variable MemWr, MemtoReg, RegWr, ExtOp, ALUSrc, RegDst, PCSrc : std_logic := '0';
begin
	if(RODR_OPCODE = "000000") then
		case RODR_FUNCT is
			when "100000" => -- ADD (20 HEX)
				ALUctr := "00";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '1';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '1';
				PCSrc := '0';
			when "100010" => -- SUB (22 HEX)
				ALUctr := "01";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '1';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '1';
				PCSrc := '0';
			when others =>
				ALUctr := "11";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '0';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '0';
				PCSrc := '0';
		end case;
	else
		case RODR_OPCODE is
			when "001101" => -- ori (13 HEX)
				ALUctr := "10";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '1';
				ExtOp := '1';
				ALUSrc := '1';
				RegDst := '0';
				PCSrc := '0';
			when "100011" => -- lw (23 HEX)
				ALUctr := "00";
				MemWr := '0';
				MemtoReg := '1';
				RegWr := '1';
				ExtOp := '1';
				ALUSrc := '1';
				RegDst := '0';
				PCSrc := '0';
			when "101010" => -- sw (2C HEX)
				ALUctr := "00";
				MemWr := '1';
				MemtoReg := '0';
				RegWr := '0';
				ExtOp := '1';
				ALUSrc := '1';
				RegDst := '0';
				PCSrc := '0';
			when "000100" => -- BEQ (4 HEX)
				ALUctr := "01";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '0';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '0';	
				if(RODR_Zero = "00000000000000000000000000000000") then
					PCSrc := '1';
				else
					PCSrc := '0';
				end if;
			when "000101" => -- BNE (5 HEX)
				ALUctr := "01";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '0';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '0';
				if(RODR_Zero = "00000000000000000000000000000000") then
					PCSrc := '1';
				else
					PCSrc := '0';
				end if;
			when others =>
				ALUctr := "11";
				MemWr := '0';
				MemtoReg := '0';
				RegWr := '0';
				ExtOp := '0';
				ALUSrc := '0';
				RegDst := '0';
				PCSrc := '0';
		end case;
	end if;
	RODR_ALUctr <= ALUCtr;
	RODR_MemWr <= MemWr;
	RODR_MemtoReg <= MemtoReg;
	RODR_RegWr <= RegWr;
	RODR_ExtOp <= ExtOp;
	RODR_ALUSrc <= ALUSrc;
	RODR_RegDst <= RegDst;
	RODR_PCSrc <= PCSrc;
end process;

END LogicFunction;


LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY RODR_MasterFile IS
	generic(nbits : natural := 32);
	PORT(RODR_Clock     : in std_logic;
		  RODR_ALUResult : out std_logic_vector(nbits-1 downto 0);
		  RODR_PCOutput  : out std_logic_vector(nbits-1 downto 0);
		  RODR_RegResult : out std_logic_vector(nbits-1 downto 0));
	END RODR_MasterFile ;

ARCHITECTURE LogicFunction OF RODR_MasterFile IS

	Component RODR_2TO1MUX is
		generic(nbits: natural := 32);
		port(	RODR_A:	in std_logic_vector(nbits-1 downto 0);
			RODR_B:	in std_logic_vector(nbits-1 downto 0);
			RODR_SEL : in std_logic;
			RODR_OUT : Out std_logic_vector(nbits-1 downto 0));

	end Component;

	Component RODR_InstrMem IS
		generic(nbits : natural := 32);
		PORT(RODR_PCSource : in std_logic_vector (nbits-1 downto 0);
			  RODR_CLK : in std_logic;
		     RODR_Out : out std_logic_vector (nbits-1 downto 0));
	END Component;
	
	Component RODR_PC IS
		generic(nbits : natural := 32);
		PORT(RODR_IN  : in std_logic_vector (nbits-1 downto 0);
			  RODR_CLK : in std_logic;
		     RODR_OUT : out std_logic_vector (nbits-1 downto 0));
	END Component;

	Component RODR_Control IS
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
	END Component;
	
	Component RODR_ALU IS
	generic(nbits : natural := 32);
	PORT(RODR_IN1    : in std_logic_vector(nbits-1 downto 0);
		  RODR_IN2    : in std_logic_vector(nbits-1 downto 0);
		  RODR_ALUCtr : in std_logic_vector (1 downto 0);
		  RODR_OUT    : out std_logic_vector(nbits-1 downto 0));
	END Component ;
	
	Component RODR_DataMem IS
		generic(nbits : natural := 32);
		PORT(RODR_WrEN    : in std_logic;
		  RODR_Addr    : in std_logic_vector(nbits-1 downto 0);
		  RODR_DataIN  : in std_logic_vector(nbits-1 downto 0);
		  RODR_Clock   : in std_logic;
		  RODR_DataOUT : out std_logic_vector(nbits-1 downto 0));
	END Component ;
	
	Component RODR_RegAr IS
	generic(nbits : natural := 32);
	PORT(RODR_SrcAddr    : IN STD_LOGIC_VECTOR (4 downto 0);
		  RODR_SrcAddr2   : IN STD_Logic_Vector (4 downto 0);
		  RODR_DstAddr    : IN STD_Logic_vector (4 downto 0);
		  RODR_Data       : in std_logic_vector (31 downto 0);
		  RODR_RegWr      : in std_logic;
  		  RODR_Clock      : in std_logic;
	     RODR_OUT1       : OUT STD_LOGIC_VECTOR (nbits-1 downto 0);
	     RODR_OUT2       : OUT STD_LOGIC_VECTOR (nbits-1 downto 0));
	END Component;
	
	Component RODR_Extender is
	generic(nbits: natural := 16);
	port(	RODR_IN:	in std_logic_vector(nbits-1 downto 0);
		RODR_SEL: in std_logic;
		RODR_OUT : Out std_logic_vector(nbits*2-1 downto 0));

	end Component;
	
	signal ProgramCounter : std_logic_vector (31 downto 0) := (Others => '0');
	signal PC1 : std_logic_vector (31 downto 0) := (others => '0');
	signal PC2 : std_logic_vector (31 downto 0) := (others => '0');
	signal PCOut : std_logic_vector (31 downto 0) := (others => '0');
	
	signal InstMemOut : std_logic_vector(31 downto 0) := (others => '0');
	
	signal RDAddress : std_logic_vector(4 downto 0) := (others => '0');
	signal RTAddress : std_logic_vector(4 downto 0) := (others => '0');
	signal RSAddress : std_logic_vector(4 downto 0) := (others => '0');
	signal RegDst : std_logic   := '0';
	signal PCSrc : std_logic := '0';
	signal RegDestAddr : std_logic_vector(4 downto 0) := (others => '0');
	signal busW : std_logic_vector (31 downto 0) := (others => '0');
	signal RegWr : std_logic := '0';
	signal busA : std_logic_vector(31 downto 0) := (others => '0');
	signal busB : std_logic_vector(31 downto 0) := (others => '0');
	
	signal ImmExtend32 : std_logic_vector(31 downto 0) := (others => '0');
	signal ALUSrc : std_logic := '0';
	signal ALUbusB : std_logic_vector (31 downto 0) := (others => '0');
	
	signal Imm16 : std_logic_vector(15 downto 0) := (others => '0');
	signal ExtOp : std_logic := '0';
	
	signal ALUCtr : std_logic_vector (1 downto 0) := (others => '0');
	signal ALUOut : std_logic_vector (31 downto 0) := (others => '0');
	
	signal MemWr : std_logic := '0';
	signal DataMemOut : std_logic_vector(31 downto 0) := (others => '0');
	
	signal MemtoReg : std_logic := '0';
	
	Begin
	
	Imm16 <= InstMemOut(15 downto 0);
	RODR_ALUResult <= ALUOut;
	RODR_PCOutput <= PCOut;
	RODR_RegResult <= busW;
	
	RDAddress <= InstMemOut(nbits-17 downto nbits-21);
	RTAddress <= InstMemOut(nbits-12 downto nbits-16);
	RSAddress <= InstMemOut(nbits-7 downto nbits-11);
	PC1 <= PCOut + 1;
	PC2 <= PC1 + ImmExtend32;

	
	RODR_ProC		 : RODR_PC								PORT MAP (ProgramCounter, RODR_Clock, PCOut);
	
	RODR_PCMux		 : RODR_2TO1MUX						PORT MAP (PC1, PC2, PCSrc, ProgramCounter);
	
	RODR_InstMem    : RODR_InstrMem                 PORT MAP (PCOut, RODR_Clock, InstMemOut);
	
	
	RODR_MuxRegDest : RODR_2TO1MUX  GENERIC MAP (5) PORT MAP (RDAddress, RTAddress, RegDst, RegDestAddr);
	RODR_RegArray   : RODR_RegAR                    PORT MAP (RSAddress, RTAddress, RegDestAddr, busW, RegWr, RODR_Clock, busA, busB);
	
	
	RODR_MuxExtSEL  : RODR_2TO1MUX                  PORT MAP (busB, ImmExtend32, ALUSrc, ALUbusB);
	RODR_Extend     : RODR_Extender                 PORT MAP (Imm16, ExtOp, ImmExtend32); 
	
	RODR_ALU1       : RODR_ALU                      PORT MAP (busA, ALUbusB, ALUCtr, ALUOut);
	
	RODR_DatMem     : RODR_DataMem                  PORT MAP (MemWr, ALUOut, busB , RODR_Clock, DataMemOut);
	
	RODR_MuxEnd     : RODR_2TO1MUX                  PORT MAP (ALUOut, DataMemOut, MemtoReg, busW);
	
	RODR_CTRL 		 : RODR_Control						PORT MAP (InstMemOut, ALUOut, ALUCtr, MemWr, MemtoReg, RegWr, ExtOp, ALUSrc, RegDst, PCSrc);
	
end LogicFunction;
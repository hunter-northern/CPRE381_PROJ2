-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32;	
	  ADDR_WIDTH : integer := 10;
	  DATA_WIDTH : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;


  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

component control is
  port(iOP      : in std_logic_vector(5 downto 0);
       iFunc    : in std_logic_vector(5 downto 0);
       oRegDst  : out std_logic; --done
	oJ	: out std_logic; -- done
       oBranch  : out std_logic; --done
       oMemtoReg: out std_logic; --done
       oALUOp   : out std_logic_vector(2 downto 0); --done
       oMemWrite: out std_logic; --done 
       oALUSrc  : out std_logic; --done
	o_ADDSUB : out std_logic; --done
	o_SHFTDIR : out std_logic; --done
	o_SHFTTYPE : out std_logic; --done
	o_LogicChoice : out std_logic_vector(1 downto 0); --done
	o_Unsigned : out std_logic;
	o_Halt	   : out std_logic;
	o_SignSelCtl : out std_logic;
       oJr	: out std_logic; --done
       oJal     : out std_logic; --done
       oBNE     : out std_logic; --done
       oRegWrite: out std_logic); --done

end component;

component RegFile is
  port(i_CLK 	: in std_logic;
       i_WE         : in std_logic;
       i_WRN        : in std_logic_vector(4 downto 0);
       i_RST        : in std_logic;
       i_WD         : in std_logic_vector(31 downto 0);	
       i_RPA	    : in std_logic_vector(4 downto 0);
       i_RPB	    : in std_logic_vector(4 downto 0);
       o_RPA	    : out std_logic_vector(31 downto 0);
       o_RPB 	    : out std_logic_vector(31 downto 0));

end component;

component ALU is
  port(i_PA 		            : in std_logic_vector(N-1 downto 0);
       i_PBoIMM		            : in std_logic_vector(N-1 downto 0);
	i_SHAMT			    : in std_logic_vector(4 downto 0);
	i_ALUOP			    : in std_logic_vector(2 downto 0);
	i_ShftDIR		    : in std_logic;
	i_LogicCtrl		    : in std_logic_vector(1 downto 0);
	i_AddSub		    : in std_logic;
	i_ShftTYP		    : in std_logic;
	i_Unsign		    : in std_logic;
        o_ALURES 		    : out std_logic_vector(N-1 downto 0);
	o_OvrFlw 	            : out std_logic;
	o_ZERO 		            : out std_logic);

end component;

component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component bitExtension is
	port(  i_SignSel	: in std_logic;
		i_bit16		: in std_logic_vector(15 downto 0);
		o_bit32	        : out std_logic_vector(31 downto 0));
end component;



component mux2t1_5 is
  -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));

end component;

component FetchLogic is
port(  i_CLK                       : in std_logic;
        i_RST                       : in std_logic;
	i_Branch		    : in std_logic;
	i_BNE			    : in std_logic;
	i_Jal			    : in std_logic;
	i_ZERO			    : in std_logic;
	i_Jr			    : in std_logic;
	i_J			    : in std_logic;
	i_WRITEDST		    : in std_logic_vector(4 downto 0);
	i_JumpAddr		    : in std_logic_vector(25 downto 0);
	i_BranchImmAddr		    : in std_logic_vector(31 downto 0);
	i_WriteData		    : in std_logic_vector(31 downto 0);
	i_RS			    : in std_logic_vector(31 downto 0);
	o_WRITEDST		    : out std_logic_vector(4 downto 0);
	o_JaloDataWrite		    : out std_logic_vector(31 downto 0);
	o_InstrAddr		    : out std_logic_vector(N-1 downto 0));

end component;

signal s_ALURES, S_RT_I : std_logic_vector(31 downto 0);
signal s_RS_A, s_RT_B, s_IMM : std_logic_vector(31 downto 0);
signal s_oC, s_Branch, s_BNE, s_J, s_Jal, s_ALUZERO, s_ZERO, s_Jr, s_RegDst, s_oMemtoReg, s_oMemWriteE, s_ALUSrc : std_logic;
signal s_ADDSUB, s_SHFTDIR, s_SHFTTYPE, s_Unsigned, s_RegWrEn : std_logic;
signal s_SignSelCtl : std_logic := '1';
signal s_iWRITEDST, s_oWRITEDST, s_RToRD : std_logic_vector(4 downto 0);
signal s_iJumpAddr : std_logic_vector(25 downto 0);
signal s_ALUWriteData, s_JaloALUWrite, s_InstrAddr, s_MEMOUT : std_logic_vector(31 downto 0); 
signal s_ALUOp : std_logic_vector(2 downto 0);
signal s_LogicChoice : std_logic_vector(1 downto 0);


  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  
-- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

FETCH1: FetchLogic
port map( i_CLK   => iCLK,
        i_RST   => iRST,    
	i_Branch => s_Branch,
	i_BNE	=> s_BNE,	
	i_Jal	=> s_Jal,	
	i_ZERO	=> s_ZERO,	
	i_Jr	=> s_Jr,	
	i_J	=> s_J,
	i_WRITEDST => s_RToRD,	
	i_JumpAddr => s_Inst(25 downto 0),
	i_BranchImmAddr	=> s_IMM,	
	i_WriteData => s_ALUWriteData,	
	i_RS	=> s_RS_A,	
	o_WRITEDST => s_RegWrAddr,	
	o_JaloDataWrite	=> s_RegWrData,
	o_InstrAddr =>   s_NextInstAddr);


CONTROL1: control
  port map(iOP      => s_Inst(31 downto 26),
       iFunc    => s_Inst(5 downto 0),
       oRegDst  => s_RegDst,
	oJ	=> s_J,
       oBranch  => s_Branch,
       oMemtoReg=> s_oMemtoReg,
       oALUOp   => s_ALUOp,
       oMemWrite=> s_DMemWr, 
       oALUSrc  => s_ALUSrc, --done
	o_ADDSUB => s_ADDSUB, --done
	o_SHFTDIR => s_SHFTDIR, --done
	o_SHFTTYPE => s_SHFTTYPE, --done
	o_LogicChoice => s_LogicChoice, --done
	o_Unsigned => s_Unsigned,
	o_Halt	  =>  s_Halt,
	o_SignSelCtl => s_SignSelCtl,
       oJr	=> s_Jr, --done
       oJal     => s_Jal, --done
       oBNE     => s_BNE, --done
       oRegWrite=> s_RegWr); --done

MUXRD: mux2t1_5 port map(
	i_S => s_RegDst,
	i_D0 => s_Inst(20 downto 16),
	i_D1 => s_Inst(15 downto 11),
	o_O  => s_RToRD);

REGFILE1: RegFile
  port map(i_CLK  => iCLK,
	i_WE => s_RegWr,
       i_WRN  =>  s_RegWrAddr,
	i_RST =>  iRST,
       i_WD   =>  s_RegWrData,	
       i_RPA  =>  s_Inst(25 downto 21),
       i_RPB  =>  s_Inst(20 downto 16),
       o_RPA  =>  s_RS_A,
       o_RPB  =>  s_RT_B);

s_DMemData <= s_RT_B;

MUXRTI: mux2t1_N port map(
	i_S => s_ALUSrc,
	i_D0 => s_RT_B,
	i_D1 => s_IMM,
	o_O  => S_RT_I);

ALU1 : ALU port map(i_PA => s_RS_A,
       i_PBoIMM	 => s_RT_I,
	i_SHAMT	 => s_Inst(10 downto 6),
	i_ALUOP	 => s_ALUOp,
	i_ShftDIR => s_SHFTDIR,
	i_LogicCtrl => s_LogicChoice,
	i_AddSub => s_ADDSUB,
	i_ShftTYP => s_SHFTTYPE,
	i_Unsign => s_Unsigned,
        o_ALURES => s_ALURES,
	o_OvrFlw => s_Ovfl,
	o_ZERO 	 => s_ALUZERO);

s_ZERO <= s_ALUZERO;
s_DMemAddr <= s_ALURES;
oALUOut <= s_ALURES;

MUXMEMOALU: mux2t1_N port map(
	i_S => s_oMemtoReg,
	i_D0 => s_ALURES,
	i_D1 => s_DMemOut,
	o_O  => S_ALUWriteData);


BITIMM: bitExtension
 port map(i_SignSel => s_SignSelCtl,
	i_bit16	=> s_Inst(15 downto 0),
	o_bit32	=> s_IMM);	



end structure;


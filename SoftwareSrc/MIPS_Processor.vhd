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

component IFIDPipeline is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_Inst	    : in std_logic_vector(31 downto 0);
	i_PCAddr    : in std_logic_vector(31 downto 0);
       o_Inst          : out std_logic_vector(31 downto 0);     -- Data value input
       o_PCAddr          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component IDEXPipeline is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PA	    : in std_logic_vector(31 downto 0);
	i_PB    	: in std_logic_vector(31 downto 0);
	i_RS	    	: in std_logic_vector(4 downto 0);
	i_RT    	: in std_logic_vector(4 downto 0);
	i_RD	    	: in std_logic_vector(4 downto 0);
	i_IMM    	: in std_logic_vector(31 downto 0);
	i_PCADDR	: in std_logic_vector(31 downto 0);
	i_ALUOP		: in std_logic_vector(2 downto 0);	
	i_Jal		: in std_logic;
	i_MemWrEn	: in std_logic;
	i_MemtoReg	: in std_logic;
	i_ALUSrc	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_RegDst	: in std_logic;
	i_ADDSUB	: in std_logic;
	i_SHFTDIR	: in std_logic;
	i_SHFTTYPE	: in std_logic;
	i_Halt		: in std_logic;
	i_Unsigned	: in std_logic;
	i_SHAMT		: in std_logic_vector(4 downto 0);
	i_LogicCtrl	: in std_logic_vector(1 downto 0);
       
	o_PA	    	: out std_logic_vector(31 downto 0);
	o_PB    	: out std_logic_vector(31 downto 0);
	o_RS	    	: out std_logic_vector(4 downto 0);
	o_RT    	: out std_logic_vector(4 downto 0);
	o_RD	    	: out std_logic_vector(4 downto 0);
	o_IMM    	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_Jal		: out std_logic;
	o_MemWrEn	: out std_logic;
	o_MemtoReg	: out std_logic;
	o_ALUOP		: out std_logic_vector(2 downto 0);
	o_ALUSrc	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_RegDst	: out std_logic;
	o_ADDSUB	: out std_logic;
	o_SHFTDIR	: out std_logic;
	o_SHFTTYPE	: out std_logic;
	o_Halt		: out std_logic;
	o_Unsigned	: out std_logic;
	o_SHAMT		: out std_logic_vector(4 downto 0);
	o_LogicCtrl	: out std_logic_vector(1 downto 0));   -- Data value output

end component;

component EXMEMPipeline is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_ALURES	    : in std_logic_vector(31 downto 0);
	i_PCADDR    	: in std_logic_vector(31 downto 0);
	i_RT    	: in std_logic_vector(31 downto 0);
	i_RGDST	    	: in std_logic_vector(4 downto 0);
	i_Jal		: in std_logic;
	i_MemtoReg	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_MemWrEn	: in std_logic;
	i_Halt		: in std_logic;
       
	o_ALURES	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_RT    	: out std_logic_vector(31 downto 0);
	o_RGDST		: out std_logic_vector(4 downto 0);
	o_Jal		: out std_logic;
	o_MemtoReg	: out std_logic;
	o_MemWrEn	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_Halt		: out std_logic);   -- Data value output

end component;

component MEMWBPipeline is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_ALURES	    : in std_logic_vector(31 downto 0);
	i_PCADDR    	: in std_logic_vector(31 downto 0);
	i_MEMDATA    	: in std_logic_vector(31 downto 0);
	i_RGDST	    	: in std_logic_vector(4 downto 0);
	i_Jal		: in std_logic;
	i_MemtoReg	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_Halt		: in std_logic;
       
	o_ALURES	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_MEMDATA    	: out std_logic_vector(31 downto 0);
	o_Jal		: out std_logic;
	o_MemtoReg	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_Halt		: out std_logic;
	o_RGDST		: out std_logic_vector(4 downto 0));   -- Data value output

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

component FetchLogic is
	--generic(N : integer := 32);

  port( i_Branch		    : in std_logic;
	i_BNE			    : in std_logic;
	i_Jr			    : in std_logic;
	i_J			    : in std_logic;
	i_JumpAddr		    : in std_logic_vector(25 downto 0);
	i_Imm			    : in std_logic_vector(31 downto 0);
	i_PCAddr		    : in std_logic_vector(31 downto 0);
	i_PA			    : in std_logic_vector(31 downto 0);
	i_PB			    : in std_logic_vector(31 downto 0);
	o_PCADDRNext		    : out std_logic_vector(31 downto 0);
	o_Flush			    : out std_logic);

end component;

component PC is
  port(	i_CLK  :in std_logic;
	i_WE        : in std_logic;
	i_RST 	    : in std_logic;
       	i_WD         : in std_logic_vector(31 downto 0);	
       	o_InsAdd     : out std_logic_vector(31 downto 0));

end component;

component mux2t1_5 is
  -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));

end component;

component AdderSub_N is
  port(i_X 		            :in std_logic_vector(N-1 downto 0);
       i_Y 		            :in std_logic_vector(N-1 downto 0);
       Add_Sub	 		    : in std_logic;
       o_C 		            : out std_logic;
       o_Over			    : out std_logic;
       o_B 		            : out std_logic_vector(N-1 downto 0));

end component;

component AdderH_n is
  port(i_X         : in std_logic_vector(N-1 downto 0);
	i_Y		: in std_logic_vector(N-1 downto 0);
	i_C		: in std_logic;
	o_C		: out std_logic;
	o_Over		: out std_logic;
       o_B          : out std_logic_vector(N-1 downto 0));
end component;

component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

end component;

signal s_oC, s_Branch, s_BNE, s_J, s_Jr, s_oMemtoReg, s_SHFTDIR : std_logic;
signal s_SignSelCtl : std_logic := '1';
signal s_ALUWriteData, s_JaloALUWrite, s_InstrAddr, s_MEMOUT, s_JumpAddr : std_logic_vector(31 downto 0); 
signal s_LogicChoice : std_logic_vector(1 downto 0);

 --IF PIPE Signals
signal s_PCADDR, s_JumpoBranchAddr, s_PCADDRNEXT : std_logic_vector(31 downto 0);
signal s_PCADDR4 : std_logic_vector(31 downto 0) := x"00400000";

 --ID PIPE Signals
signal s_IDPCADDR, s_IDINST, s_IDPA, s_IDPB, s_IDIMM, s_IDBranchZero, s_BranchImm, s_IDBranchAddr, s_BranchoPC, s_BranchoPCoJ, s_BoPCoJoJr: std_logic_vector(31 downto 0); 
signal s_IDRS, s_IDRT, s_IDRD : std_logic_vector(4 downto 0);
signal s_IDALUOP : std_logic_vector(2 downto 0);
signal s_IDLogicCtrl : std_logic_vector(1 downto 0);
signal s_IDRegDst, s_IDMemToReg, s_IDMemWrEn, s_IDALUSRC, s_IDADDSUB, s_IDSHFTDIR, s_IDSHFTTYPE, s_IDHalt, s_IDJal, s_IDRegWrEn : std_logic;
signal s_IDC, s_BranchTrue, s_JorBranch, s_IDOVER1, s_IDOVER2, s_IDC1, s_IDC2, s_IDOVER3, s_IDZero, s_IDNotZero, s_JorBrnch, s_IDFlush1 : std_logic; 

 --EX PIPE Signals
signal s_EXPCADDR, s_EXINST, s_EXPA, s_EXPB, s_EXALURES, s_EXIMM, s_EXPBoIMM: std_logic_vector(31 downto 0); 
signal s_EXRS, s_EXRT, s_EXRD, s_EXREGDST, s_EXSHAMT : std_logic_vector(4 downto 0);
signal s_EXALUOP : std_logic_vector(2 downto 0);
signal s_EXLogicCtrl : std_logic_vector(1 downto 0);
signal s_EXRegDstSel, s_EXMemToReg, s_EXMemWrEn, s_EXALUSRC, s_EXADDSUB, s_EXSHFTDIR, s_EXSHFTTYPE, s_EXHalt, s_EXJal, s_EXRegWrEn : std_logic;
signal s_EXALUZERO, s_IDUnsigned, s_EXUnsigned, s_IDFLUSH : std_logic;

 --MEM PIPE Signals
signal s_MEMPCADDR, s_MEMALURES, s_MEMPB: std_logic_vector(31 downto 0); 
signal s_MEMREGDST : std_logic_vector(4 downto 0);
signal s_MEMMemToReg, s_MEMMemWrEn, s_MEMHalt, s_MEMJal, s_MEMRegWrEn : std_logic;

 --WB PIPE Signals
signal s_WBPCADDR, s_WBALURES, s_WBMemData: std_logic_vector(31 downto 0); 
signal s_WBREGDST : std_logic_vector(4 downto 0);
signal s_WBMemToReg, s_WBMHalt, s_WBJal, s_WBRegWrEn : std_logic;


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


PCREG: PC port map(
	i_CLK  => iCLK,
	i_WE   => '1',
	i_RST  => iRST,
       	i_WD   => s_PCADDRNEXT,	
       	o_InsAdd  => s_PCADDR);

s_NextInstAddr <= s_PCADDR;

PCADD1: AdderH_N port map(
	i_X  => s_PCADDR,
	i_Y  => x"00000004",
	i_C  => '0',
	o_C  => s_oC, 
       	o_B  => s_PCADDR4);

s_IDFlush1 <= (s_IDFLUSH or iRST);

IDIFPIPE: IFIDPipeline port map(
	i_CLK  => iCLK,
       i_RST   => s_IDFlush1,
       i_Inst  => s_Inst,
	i_PCAddr => s_PCADDR4,
       o_Inst   => s_IDINST,
       o_PCAddr => s_IDPCADDR);

CONTROL1: control
  port map(iOP      => s_IDINST(31 downto 26),
       iFunc    => s_IDINST(5 downto 0),
       oRegDst  => s_IDRegDst,
	oJ	=> s_J,
       oBranch  => s_Branch,
       oMemtoReg=> s_IDMemtoReg,
       oALUOp   => s_IDALUOp,
       oMemWrite=> s_IDMemWrEn, 
       oALUSrc  => s_IDALUSrc, --done
	o_ADDSUB => s_IDADDSUB, --done
	o_SHFTDIR => s_IDSHFTDIR, --done
	o_SHFTTYPE => s_IDSHFTTYPE, --done
	o_LogicChoice => s_IDLogicCtrl, --done
	o_Unsigned => s_IDUnsigned,
	o_Halt	  =>  s_IDHalt,
	o_SignSelCtl => s_SignSelCtl,
       oJr	=> s_Jr, --done
       oJal     => s_IDJal, --done
       oBNE     => s_BNE, --done
       oRegWrite => s_IDRegWrEn); --done



REGFILE1: RegFile
  port map(i_CLK  => iCLK,
	i_WE => s_RegWr,
       i_WRN  =>  s_RegWrAddr,
	i_RST =>  iRST,
       i_WD   =>  s_RegWrData,	
       i_RPA  =>  s_IDINST(25 downto 21),
       i_RPB  =>  s_IDINST(20 downto 16),
       o_RPA  =>  s_IDPA,
       o_RPB  =>  s_IDPB);

BITIMM: bitExtension
 port map(i_SignSel => s_SignSelCtl,
	i_bit16	=> s_IDINST(15 downto 0),
	o_bit32	=> s_IDIMM);	

 FETCHID: FetchLogic port map( 
	i_Branch	=> s_Branch,
	i_BNE		=> s_BNE,
	i_Jr		=> s_Jr,
	i_J		=> s_J,
	i_JumpAddr	=> s_Inst(25 downto 0),
	i_Imm		=> s_IDIMM,
	--i_PCAddr	=> s_IDPCADDR,
	i_PCAddr	=> s_PCADDR4,
	i_PA		=> s_IDPA,
	i_PB		=> s_IDPB,
	o_PCADDRNext	=> s_PCADDRNEXT,
	o_Flush		=> s_IDFLUSH);   

IDEXPIPE: IDEXPipeline port map(
	i_CLK  => iCLK,
       	i_RST   => iRST,
       	i_PA    => s_IDPA,
	i_PB   => s_IDPB,
	i_RS   => s_IDINST(25 downto 21),
	i_RT   => s_IDINST(20 downto 16),
	i_RD   => s_IDINST(15 downto 11),
	i_IMM  => s_IDIMM,
	i_PCADDR => s_IDPCADDR,
	i_ALUOP	 => s_IDALUOP,	
	i_Jal	 => s_IDJal,
	i_MemWrEn => s_IDMemWrEn,
	i_MemtoReg => s_IDMemtoReg,
	i_ALUSrc  => s_IDALUSrc,
	i_RegWrEn => s_IDRegWrEn,
	i_RegDst  => s_IDRegDst,
	i_ADDSUB  	=> s_IDADDSUB,
	i_SHFTDIR	=> s_SHFTDIR,
	i_SHFTTYPE	=> s_IDSHFTTYPE,
	i_Halt		=> s_IDHalt,
	i_Unsigned	=> s_IDUnsigned,
	i_SHAMT		=> s_IDINST(10 downto 6),
	i_LogicCtrl	=> s_IDLogicCtrl,
       
	o_PA	    	=> s_EXPA,
	o_PB    	=> s_EXPB,
	o_RS	    	=> s_EXRS,
	o_RT    	=> s_EXRT,
	o_RD	    	=> s_EXRD,
	o_IMM    	=> s_EXIMM,
	o_PCADDR	=> s_EXPCADDR,
	o_Jal		=> s_EXJal,
	o_MemWrEn	=> s_EXMemWrEn,
	o_MemtoReg	=> s_EXMemtoReg,
	o_ALUOP		=> s_EXALUOP,
	o_ALUSrc	=> s_EXALUSrc,
	o_RegWrEn	=> s_EXRegWrEn,
	o_RegDst	=> s_EXRegDstSel,
	o_ADDSUB	=> s_EXADDSUB,
	o_SHFTDIR	=> s_EXSHFTDIR,
	o_SHFTTYPE	=> s_EXSHFTTYPE,
	o_Halt		=> s_EXHalt,
	o_Unsigned	=> s_EXUnsigned,
	o_SHAMT		=> s_EXSHAMT,
	o_LogicCtrl	=> s_EXLogicCtrl);


MUXRTI: mux2t1_N port map(
	i_S => s_EXALUSrc,
	i_D0 => s_EXPB,
	i_D1 => s_EXIMM,
	o_O  => s_EXPBoIMM);

ALU1 : ALU port map(i_PA => s_EXPA,
       i_PBoIMM	 => s_EXPBoIMM,
	i_SHAMT	 => s_EXSHAMT,
	i_ALUOP	 => s_EXALUOp,
	i_ShftDIR => s_EXSHFTDIR,
	i_LogicCtrl => s_EXLogicCtrl,
	i_AddSub => s_EXADDSUB,
	i_ShftTYP => s_EXSHFTTYPE,
	i_Unsign => s_EXUnsigned,
        o_ALURES => s_EXALURES,
	o_OvrFlw => s_Ovfl,
	o_ZERO 	 => s_EXALUZERO);

--Stall will turn off the Write Enable on IFID and IDEX 

oALUOut <= s_EXALURES; -- MIGHT NEED TO BE FROM WB

REGDST1: mux2t1_5 port map(
	i_S  => s_EXRegDstSel,
       i_D0  => s_EXRT,
       i_D1  => s_EXRD,
       o_O   => s_EXREGDST);

EXMEMPIPE: EXMEMPipeline port map(
	i_CLK  => iCLK,
       i_RST   => iRST,
       i_ALURES	=> s_EXALURES,
	i_PCADDR  => s_EXPCADDR,
	i_RT   => s_EXPB,
	i_RGDST	 => s_EXREGDST,
	i_Jal	=> s_EXJal,
	i_MemtoReg	=> s_EXMemtoReg,
	i_RegWrEn	=> s_EXRegWrEn,
	i_MemWrEn	=> s_EXMemWrEn,
	i_Halt		=> s_EXHalt,
       
	o_ALURES	=> s_MEMALURES,
	o_PCADDR	=> s_MEMPCADDR,
	o_RT    	=> s_MEMPB,
	o_RGDST		=> s_MEMREGDST,
	o_Jal		=> s_MEMJal,
	o_MemtoReg	=> s_MEMMemtoReg,
	o_MemWrEn	=> s_MEMMemWrEn,
	o_RegWrEn	=> s_MEMRegWrEn,
	o_Halt		=> s_MEMHalt);

s_DMemData <= s_MEMPB;
s_DMemAddr <= s_MEMALURES;
s_DMemWr  <=  s_MEMMemWrEn;

MEMWBPIPE: MEMWBPipeline port map(i_CLK => iCLK,
       i_RST => iRST,
       i_ALURES	 => s_MEMALURES,
	i_PCADDR => s_MEMPCADDR,
	i_MEMDATA => s_DMemOut,
	i_RGDST	  => s_MEMRegDst,
	i_Jal	  => s_MEMJal,
	i_MemtoReg => s_MEMMemtoReg,
	i_RegWrEn  => s_MEMRegWrEn,
	i_Halt	   => s_MEMHalt,
       
	o_ALURES   => s_WBALURES,
	o_PCADDR   => s_WBPCADDR,
	o_MEMDATA  => s_WBMEMDATA,
	o_Jal	   => s_WBJal,
	o_MemtoReg => s_WBMemtoReg,
	o_RegWrEn  => s_WBRegWrEn,
	o_Halt	   => s_Halt,
	o_RGDST	   => s_WBREGDST);

--ADD WRITE BACK LOGIC FOR DATA AND MUXES
s_RegWr <= s_WBRegWrEn;

MUXMEMOALU: mux2t1_N port map(
	i_S => s_WBMemtoReg,
	i_D0 => s_WBALURES,
	i_D1 => s_DMemOut,
	o_O  => s_ALUWriteData);

MUXMEMOALUOJAL: mux2t1_N port map(
	i_S => s_WBJal,
	i_D0 => s_ALUWriteData,
	i_D1 => s_WBPCADDR,
	o_O  => s_RegWrData);

REGDSTJal: mux2t1_5 port map(
	i_S  => s_WBJal,
       i_D0  => s_WBREGDST,
       i_D1  => "11111",
       o_O   => s_RegWrAddr);

end structure;


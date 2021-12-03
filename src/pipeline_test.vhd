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

entity pipeline_test is
  generic(N : integer := 32);
  port( iCLK            : in std_logic;
        iIFIDStall 	: in std_logic;
	iIDEXStall 	: in std_logic;
	iMEMWBStall 	: in std_logic;
	iEXMEMStall 	: in std_logic;
	iIFIDFlush 	: in std_logic;
	iIDEXFlush 	: in std_logic;
	iMEMWBFlush 	: in std_logic;
	iEXMEMFlush 	: in std_logic;
        iInst           : in std_logic_vector(N-1 downto 0);
        oInst           : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  pipeline_test;


architecture structure of pipeline_test is


component IFIDPipeline is
  port(i_CLK         : in std_logic;     -- Clock input
       i_RST         : in std_logic;     -- Reset input
       i_Stall	     : in std_logic;
       i_Inst	     : in std_logic_vector(31 downto 0);
       i_PCAddr      : in std_logic_vector(31 downto 0);
       o_Inst        : out std_logic_vector(31 downto 0);     -- Data value input
       o_PCAddr      : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component IDEXPipeline is

  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
	i_Inst	        : in std_logic_vector(31 downto 0);
        i_PA	    	: in std_logic_vector(31 downto 0);
	i_Stall		: in std_logic;
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
       
	o_Inst	        : out std_logic_vector(31 downto 0);
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

  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
	i_Stall		: in std_logic;
	i_Inst	        : in std_logic_vector(31 downto 0);
        i_ALURES	: in std_logic_vector(31 downto 0);
	i_PCADDR    	: in std_logic_vector(31 downto 0);
	i_RT    	: in std_logic_vector(31 downto 0);
	i_RGDST	    	: in std_logic_vector(4 downto 0);
	i_Jal		: in std_logic;
	i_MemtoReg	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_MemWrEn	: in std_logic;
	i_Halt		: in std_logic;
       
	o_Inst	        : out std_logic_vector(31 downto 0);
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
  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
	i_Stall		: in std_logic;
	i_Inst	        : in std_logic_vector(31 downto 0);
        i_ALURES	: in std_logic_vector(31 downto 0);
	i_PCADDR    	: in std_logic_vector(31 downto 0);
	i_MEMDATA    	: in std_logic_vector(31 downto 0);
	i_RGDST	    	: in std_logic_vector(4 downto 0);
	i_Jal		: in std_logic;
	i_MemtoReg	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_Halt		: in std_logic;
       
	o_Inst	        : out std_logic_vector(31 downto 0);
	o_ALURES	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_MEMDATA    	: out std_logic_vector(31 downto 0);
	o_Jal		: out std_logic;
	o_MemtoReg	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_Halt		: out std_logic;
	o_RGDST		: out std_logic_vector(4 downto 0));   -- Data value output

end component;

signal s_IDInst, s_EXInst, s_MEMInst : std_logic_vector(31 downto 0);

begin

IDIFPIPE: IFIDPipeline port map(
	i_CLK    => iCLK,
	i_RST    => iIFIDFlush,
	i_Stall	 => iIFIDStall,
        i_Inst   => iInst,
	o_Inst => s_IDInst);

IDEXPIPE: IDEXPipeline port map(
	i_CLK  		=> iCLK,
        i_RST   	=> iIDEXFlush,
	i_Stall 	=> iIDEXStall,
	i_Inst		=> s_IDInst,
	o_Inst		=> s_EXInst);   

EXMEMPIPE: EXMEMPipeline port map(
	i_CLK  		=> iCLK,
        i_RST   	=> iEXMEMFlush,
	i_Stall 	=> iEXMEMStall,
	i_Inst		=> s_EXInst,
	o_Inst		=> s_MEMInst);

MEMWBPIPE: MEMWBPipeline port map(
	i_CLK      => iCLK,
        i_RST      => iMEMWBFlush,
	i_Stall    => iMEMWBStall,
	i_Inst	   => s_MEMInst,
	o_Inst	   => oInst);

end structure;


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

entity hazard_detection is
  generic(N : integer := 32);
  port( iCLK            : in std_logic;
        oIFIDStall 	: in std_logic;
	oIDEXStall 	: in std_logic;
	oMEMWBStall 	: in std_logic;
	oEXMEMStall 	: in std_logic;
	oIFIDFlush 	: in std_logic;
	oIDEXFlush 	: in std_logic;
	oMEMWBFlush 	: in std_logic;
	oEXMEMFlush 	: in std_logic);
end  hazard_detection;


architecture structure of hazard_detection is


component IFIDPipeline is
  port(i_CLK         : in std_logic;     -- Clock input
       i_RST         : in std_logic;     -- Reset input
       i_Stall	     : in std_logic;
       i_Inst	     : in std_logic_vector(31 downto 0);
       i_PCAddr      : in std_logic_vector(31 downto 0);
       o_Inst        : out std_logic_vector(31 downto 0);     -- Data value input
       o_PCAddr      : out std_logic_vector(31 downto 0));   -- Data value output
end component;

signal s_IDInst, s_EXInst, s_MEMInst : std_logic_vector(31 downto 0);

begin

IDIFPIPE: IFIDPipeline port map(
	i_CLK    => iCLK,
	i_RST    => iIFIDFlush,
	i_Stall	 => iIFIDStall,
        i_Inst   => iInst,
	i_PCAddr => iInst,
	o_Inst => s_IDInst);


end structure;


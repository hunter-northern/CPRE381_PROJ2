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

entity forwarding_unit is
  generic(N : integer := 32);
  port( iCLK            : in std_logic;
        iMEMWBRegWr 	: in std_logic;
	iMEMWBRegRd 	: in std_logic_vector(4 downto 0);
	iIDEXRegRs	: in std_logic_vector(4 downto 0);
	iIDEXRegRt	: in std_logic_vector(4 downto 0);
	iEXMEMRegWr	: in std_logic;	
	iEXMEMRegRd	: in std_logic_vector(4 downto 0);
	iIDEXMemRead	: in std_logic_vector(4 downto 0);
	iIFIDRegRs	: in std_logic_vector(4 downto 0);
	iIFIDRegRt	: in std_logic_vector(4 downto 0);
	oAluA    	: in std_logic_vector(1 downto 0);
	oAluB 		: in std_logic_vector(1 downto 0));
end  forwarding_unit;


architecture dataflow of forwarding_unit is

--signal s_IDInst, s_EXInst, s_MEMInst : std_logic_vector(31 downto 0);

begin

IDIFPIPE: IFIDPipeline port map(
	i_CLK    => iCLK,
	i_RST    => iIFIDFlush,
	i_Stall	 => iIFIDStall,
        i_Inst   => iInst,
	i_PCAddr => iInst,
	o_Inst => s_IDInst);


end dataflow;


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
	iIDEXMemRead	: in std_logic;
	iIDEXRegRt	: in std_logic_vector(4 downto 0);
	iIFIDRegRs	: in std_logic_vector(4 downto 0);
	iIFIDRegRt	: in std_logic_vector(4 downto 0);
	oPCStall	: out std_logic;
        oIFIDStall 	: out std_logic;
	oIDEXStall 	: out std_logic;
	oMEMWBStall 	: out std_logic;
	oEXMEMStall 	: out std_logic;
	oIFIDFlush 	: out std_logic;
	oIDEXFlush 	: out std_logic;
	oMEMWBFlush 	: out std_logic;
	oEXMEMFlush 	: out std_logic);
end  hazard_detection;


architecture dataflow of hazard_detection is

begin

PROCESS (iMEMWBRegWr, iMEMWBRegRd, iIDEXRegRs, iIDEXRegRt, iEXMEMRegWr, iEXMEMRegRd, iIDEXMemRead, iIFIDRegRs, iIFIDRegRt)
	begin

	if iIDEXMemRead = '1' AND (iIDEXRegRt = iIFIDRegRs or iIDEXRegRt = iIFIDRegRt) then		--load-use
	  oPCStall	<= '0'; --
          oIFIDStall 	<= '0'; --
    	  oIDEXStall 	<= '0';	--flush instead?
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '0';
	  oIDEXFlush 	<= '0';
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';

--	elsif iMEMWBRegWr = '1' AND iMEMWBRegRd /= "00000" and not (iEXMEMRegWr = '1' and (iEXMEMRegRd /= "00000") and (iEXMEMRegRd /= iIDEXRegRt)) and iMEMWBRegRd = iIDEXRegRt then
--	oAluB <= "01";
	
	else
	  oPCStall	<= '1';
          oIFIDStall 	<= '1';
    	  oIDEXStall 	<= '1';
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '0';
	  oIDEXFlush 	<= '0';
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';

	end if;
	
END PROCESS;


end dataflow;


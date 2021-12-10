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
	iJump		: in std_logic;
	iJAL		: in std_logic;
	iBranch		: in std_logic;
	iJR		: in std_logic;
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

PROCESS (iIDEXRegRt, iIDEXMemRead, iIFIDRegRs, iIFIDRegRt, iJAL, iJump, iBranch, iJR)
	begin

	if iIDEXMemRead = '1' AND ((iIDEXRegRt = iIFIDRegRs) or (iIDEXRegRt = iIFIDRegRt)) then		--load-use
	  oPCStall	<= '0'; --
          oIFIDStall 	<= '0'; --
    	  oIDEXStall 	<= '1';	
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '0';
	  oIDEXFlush 	<= '1'; --
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';
	elsif iJump = '1' or iJAL = '1' then --jump
	  oPCStall	<= '1';
          oIFIDStall 	<= '1';
    	  oIDEXStall 	<= '1';
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '1'; --
	  oIDEXFlush 	<= '0'; --depends where we do comparison, assume we are doing it correct, so this is not flushed
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';
	elsif iJR = '1' and iIFIDRegRs = iIDEXRegRt then
	  oPCStall	<= '0'; --
	  oIFIDStall	<= '0'; --
	  oIDEXStall 	<= '1';
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '0';
	  oIDEXFlush	<= '1'; --
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';
	elsif iBranch = '1' and ((iIDEXRegRt = iIFIDRegRs) or (iIDEXRegRt = iIFIDRegRt)) and iIDEXRegRt /= "00000" then
	  oPCStall	<= '0'; --
	  oIFIDStall	<= '0'; --
	  oIDEXStall 	<= '1';
	  oMEMWBStall 	<= '1';
	  oEXMEMStall 	<= '1';
	  oIFIDFlush 	<= '0';
	  oIDEXFlush	<= '1'; --
	  oMEMWBFlush 	<= '0';
	  oEXMEMFlush 	<= '0';
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


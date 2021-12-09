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
	iIDEXMemRead	: in std_logic;
	iIFIDRegRs	: in std_logic_vector(4 downto 0);
	iIFIDRegRt	: in std_logic_vector(4 downto 0);
	oAluA    	: in std_logic_vector(1 downto 0);
	oAluB 		: in std_logic_vector(1 downto 0);
	oRdA    	: in std_logic_vector(1 downto 0);
	oRdB    	: in std_logic_vector(1 downto 0));
end  forwarding_unit;


architecture dataflow of forwarding_unit is

--signal s_IDInst, s_EXInst, s_MEMInst : std_logic_vector(31 downto 0);

begin

PROCESS (iMEMWBRegWr, iMEMWBRegRd, iIDEXRegRs, iIDEXRegRt, iEXMEMRegWr, iEXMEMRegRd, iIDEXMemRead, iIFIDRegRs, iIFIDRegRt)
	begin

	if iMEMWBRegWr = '1' AND iMEMWBRegRd /= "00000" and iMEMWBRegRd = iIDEXRegRs then	
	oAluA <= "01";

	elsif iMEMWBRegWr = '1' AND iMEMWBRegRd /= "00000" and iMEMWBRegRd = iIDEXRegRt then
	oAluB <= "01";

	elsif iEXMEMRegWr = '1' AND iEXMEMRegRd /= "00000" and iEXMEMRegRd = iIDEXRegRs then
	oAluA <= "10";

	elsif iEXMEMRegWr = '1' AND iEXMEMRegRd /= "00000" and iEXMEMRegRd = iIDEXRegRt then
	oAluB <= "10";

	elsif iMEMWBRegWr = '1' AND iMEMWBRegRd /= "00000" and not (iEXMEMRegWr = '1' and (iEXMEMRegRd /= "00000") and (iEXMEMRegRd /= iIDEXRegRs)) and iMEMWBRegRd = iIDEXRegRs then
	oAluA <= "01";

	elsif iMEMWBRegWr = '1' AND iMEMWBRegRd /= "00000" and not (iEXMEMRegWr = '1' and (iEXMEMRegRd /= "00000") and (iEXMEMRegRd /= iIDEXRegRt)) and iMEMWBRegRd = iIDEXRegRt then
	oAluB <= "01";
	
	else
	  oAluA <= "00";
	  oAluB <= "00";

	end if;
	
END PROCESS;


end dataflow;


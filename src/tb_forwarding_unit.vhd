-------------------------------------------------------------------------
-- Evan Gossling
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the barrel_shifter unit.
--              
-- 09/07/2021 by EGOS::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_forwarding_unit is
  generic(gCLK_HPER   : time := 10 ns; 
          N : integer := 32);   -- Generic for half of the clock cycle period
end tb_forwarding_unit;

architecture mixed of tb_forwarding_unit is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component forwarding_unit is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port( iMEMWBRegWr 	: in std_logic;
	iMEMWBRegRd 	: in std_logic_vector(4 downto 0);
	iIDEXRegRs	: in std_logic_vector(4 downto 0);
	iIDEXRegRt	: in std_logic_vector(4 downto 0);
	iEXMEMRegWr	: in std_logic;	
	iEXMEMRegRd	: in std_logic_vector(4 downto 0);
	iIDEXMemRead	: in std_logic;
	iIFIDRegRs	: in std_logic_vector(4 downto 0);
	iIFIDRegRt	: in std_logic_vector(4 downto 0);
	oAluA    	: out std_logic_vector(1 downto 0);
	oAluB 		: out std_logic_vector(1 downto 0));
end component;
--	oRdA    	: out std_logic_vector(1 downto 0);
--	oRdB    	: out std_logic_vector(1 downto 0)

signal CLK, reset : std_logic := '0';

signal s_iMEMWBRegWr    : std_logic;
signal s_iMEMWBRegRd    : std_logic_vector(4 downto 0);
signal s_iIDEXRegRs	: std_logic_vector(4 downto 0);
signal s_iIDEXRegRt	: std_logic_vector(4 downto 0);
signal s_iEXMEMRegWr	: std_logic;	
signal s_iEXMEMRegRd	: std_logic_vector(4 downto 0);
signal s_iIDEXMemRead	: std_logic;
signal s_iIFIDRegRs	: std_logic_vector(4 downto 0);
signal s_iIFIDRegRt	: std_logic_vector(4 downto 0);
signal s_oAluA    	: std_logic_vector(1 downto 0);
signal s_oAluB 		: std_logic_vector(1 downto 0);
--signal s_oRdA    	: std_logic_vector(1 downto 0);
--signal s_oRdB    	: std_logic_vector(1 downto 0);

begin

  DUT0: forwarding_unit
  port map(iMEMWBRegWr 	=>  s_iMEMWBRegWr,
	   iMEMWBRegRd 	=>  s_iMEMWBRegRd,
  	   iIDEXRegRs 	=>  s_iIDEXRegRs,
	   iIDEXRegRt 	=>  s_iIDEXRegRt,
	   iEXMEMRegWr 	=>  s_iEXMEMRegWr,
	   iEXMEMRegRd 	=>  s_iEXMEMRegRd,
	   iIDEXMemRead =>  s_iIDEXMemRead,
           iIFIDRegRs   =>  s_iIFIDRegRs,
	   iIFIDRegRt	=>  s_iIFIDRegRt,
	   oAluA 	=>  s_oAluA,
	   oAluB 	=>  s_oAluB);

--           oRdA         =>  s_oRdA,
--   	   oRdB		=>  s_oRdB

  
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER; -- for waveform clarity, I prefer not to change inputs on clk edges
wait for gCLK_HPER;
wait for gCLK_HPER;
wait for gCLK_HPER;

    -- Test case 1:
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "11111";
	s_iIDEXRegRs	<= "11111";
	s_iIDEXRegRt	<= "01101";
	
	s_iEXMEMRegWr	<= '1';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 2: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "11111";
	s_iIDEXRegRs	<= "11101";
	s_iIDEXRegRt	<= "01101";
	
	s_iEXMEMRegWr	<= '1';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 3: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "11111";
	s_iIDEXRegRs	<= "11111";
	s_iIDEXRegRt	<= "01101";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11111";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 4: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "11111";
	s_iIDEXRegRs	<= "11000";
	s_iIDEXRegRt	<= "11111";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11111";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 5: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11111";
	s_iIDEXRegRt	<= "01101";
	
	s_iEXMEMRegWr	<= '1';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 6: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11001";
	s_iIDEXRegRt	<= "01101";
	
	s_iEXMEMRegWr	<= '1';	
	s_iEXMEMRegRd	<= "11001";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 7: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11101";
	s_iIDEXRegRt	<= "11001";
	
	s_iEXMEMRegWr	<= '1';	
	s_iEXMEMRegRd	<= "11001";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 8: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11101";
	s_iIDEXRegRt	<= "11001";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 9: 
	s_iMEMWBRegWr   <= '1';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11100";
	s_iIDEXRegRt	<= "11101";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 10: 
	s_iMEMWBRegWr   <= '0';
	s_iMEMWBRegRd   <= "01101";
	s_iIDEXRegRs	<= "11100";
	s_iIDEXRegRt	<= "11101";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;

    -- Test case 11: 
	s_iMEMWBRegWr   <= '0';
	s_iMEMWBRegRd   <= "00000";
	s_iIDEXRegRs	<= "11100";
	s_iIDEXRegRt	<= "11101";
	
	s_iEXMEMRegWr	<= '0';	
	s_iEXMEMRegRd	<= "11101";
	s_iIDEXMemRead	<= '1';
	s_iIFIDRegRs	<= "11111";
	s_iIFIDRegRt	<= "11111";
    wait for gCLK_HPER*2;



  end process;

end mixed;

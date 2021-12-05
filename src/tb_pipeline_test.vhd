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

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_pipeline_test is
  generic(gCLK_HPER   : time := 10 ns; 
          N : integer := 32);   -- Generic for half of the clock cycle period
end tb_pipeline_test;

architecture mixed of tb_barrel_shifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component pipeline_test is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
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
        oInst           : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iIFIDStall    : std_logic;
signal s_iIDEXStall    : std_logic;
signal s_iMEMWBStall   : std_logic;
signal s_iEXMEMStall   : std_logic;
signal s_iIFIDFlush    : std_logic;
signal s_iIDEXFlush    : std_logic;
signal s_iMEMWBFlush   : std_logic;
signal s_iEXMEMFlush   : std_logic;
signal s_iInst         : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: pipeline_test
  port map(iIFIDStall 	=>  s_iIFIDStall,
	   iIDEXStall 	=>  s_iIDEXStall,
	   iMEMWBStall 	=>  s_iMEMWBStall,
  	   iEXMEMStall 	=>  s_iEXMEMStall,
	   iIFIDFlush 	=>  s_iIFIDFlush,
	   iIDEXFlush 	=>  s_iIDEXFlush,
	   iMEMWBFlush 	=>  s_iMEMWBFlush,
	   iEXMEMFlush 	=>  s_iEXMEMFlush,
           iInst        =>  s_iInst);

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    iIFIDStall 	<= '1';
    iIDEXStall 	<= '1';
    iMEMWBStall <= '1';
    iEXMEMStall <= '1';
    iIFIDFlush 	<= '0';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '0';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 2:
    iIFIDStall 	<= '0';
    iIDEXStall 	<= '0';
    iMEMWBStall <= '0';
    iEXMEMStall <= '0';
    iIFIDFlush 	<= '0';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '0';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 3:
    iIFIDStall 	<= '0';
    iIDEXStall 	<= '0';
    iMEMWBStall <= '1';
    iEXMEMStall <= '1';
    iIFIDFlush 	<= '0';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '1';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 4:
    iIFIDStall 	<= '1';
    iIDEXStall 	<= '1';
    iMEMWBStall <= '1';
    iEXMEMStall <= '1';
    iIFIDFlush 	<= '1';
    iIDEXFlush 	<= '1';
    iMEMWBFlush <= '1';
    iEXMEMFlush <= '1';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 5:
    iIFIDStall 	<= '0';
    iIDEXStall 	<= '0';
    iMEMWBStall <= '0';
    iEXMEMStall <= '0';
    iIFIDFlush 	<= '1';
    iIDEXFlush 	<= '1';
    iMEMWBFlush <= '1';
    iEXMEMFlush <= '1';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 6:
    iIFIDStall 	<= '1';
    iIDEXStall 	<= '0';
    iMEMWBStall <= '0';
    iEXMEMStall <= '0';
    iIFIDFlush 	<= '0';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '0';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 7:
    iIFIDStall 	<= '1';
    iIDEXStall 	<= '1';
    iMEMWBStall <= '1';
    iEXMEMStall <= '1';
    iIFIDFlush 	<= '1';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '0';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

    -- Test case 1:
    iIFIDStall 	<= '1';
    iIDEXStall 	<= '1';
    iMEMWBStall <= '1';
    iEXMEMStall <= '1';
    iIFIDFlush 	<= '0';
    iIDEXFlush 	<= '0';
    iMEMWBFlush <= '1';
    iEXMEMFlush <= '0';
    iInst       <= "00000000010000000000000000000100";
    wait for gCLK_HPER*2;

  end process;

end mixed;

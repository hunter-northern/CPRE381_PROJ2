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
entity tb_hazard_detection is
  generic(gCLK_HPER   : time := 10 ns; 
          N : integer := 32);   -- Generic for half of the clock cycle period
end tb_hazard_detection;

architecture mixed of tb_hazard_detection is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component hazard_detection is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port( iIDEXMemRead	: in std_logic;
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
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iIDEXMemRead	: std_logic;
signal s_iIDEXRegRt    	: std_logic_vector(4 downto 0);
signal s_iIFIDRegRs   	: std_logic_vector(4 downto 0);
signal s_iIFIDRegRt	: std_logic_vector(4 downto 0);
signal s_oPCStall   	: std_logic;
signal s_oIFIDStall     : std_logic;
signal s_oIDEXStall     : std_logic;
signal s_oMEMWBStall    : std_logic;
signal s_oEXMEMStall    : std_logic;
signal s_oIFIDFlush     : std_logic;
signal s_oIDEXFlush     : std_logic;
signal s_oMEMWBFlush    : std_logic;
signal s_oEXMEMFlush    : std_logic;
signal s_iJump		: std_logic;
signal s_iJAL		: std_logic;
signal s_iBranch		: std_logic;
signal s_iJR		: std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: hazard_detection
  port map(iIDEXMemRead =>  s_iIDEXMemRead,
	   iIDEXRegRt 	=>  s_iIDEXRegRt,
	   iIFIDRegRs 	=>  s_iIFIDRegRs,
	   iIFIDRegRt	=>  s_iIFIDRegRt,
	   iJump	=>  s_iJump,
	   iJAL		=>  s_iJAL,
	   iBranch	=>  s_iBranch,
	   iJR		=>  s_iJR,
  	   oPCStall 	=>  s_oPCStall,
	   oIFIDStall 	=>  s_oIFIDStall,
	   oIDEXStall 	=>  s_oIDEXStall,
	   oMEMWBStall 	=>  s_oMEMWBStall,
	   oEXMEMStall 	=>  s_oEXMEMStall,
           oIFIDFlush   =>  s_oIFIDFlush,
	   oIDEXFlush	=>  s_oIDEXFlush,
	   oMEMWBFlush  =>  s_oMEMWBFlush,
	   oEXMEMFlush	=>  s_oEXMEMFlush);

  
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
    wait for gCLK_HPER; -- for waveform clarity, I prefer not to change inputs on clk edges
wait for gCLK_HPER;
wait for gCLK_HPER;
wait for gCLK_HPER;

    -- Test case 1:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "11111";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;

    -- Test case 2:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10101";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';	
    wait for gCLK_HPER*2;

    -- Test case 3:
    s_iIDEXMemRead <= '0';
    s_iIDEXRegRt   <= "10101";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;

    -- Test case 4:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10111";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;	

    -- Test case 5:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10111";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '1';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;

    -- Test case 6:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10111";
    s_iIFIDRegRs   <= "11111";
    s_iIFIDRegRt   <= "10101";	
    s_iJump	   <= '0';
    s_iJAL	   <= '1';
    s_iBranch 	   <= '0';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;

    -- Test case 7:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10111";
    s_iIFIDRegRs   <= "10111";
    s_iIFIDRegRt   <= "11111";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '1';
    s_iJR	   <= '0';
    wait for gCLK_HPER*2;

    -- Test case 8:
    s_iIDEXMemRead <= '1';
    s_iIDEXRegRt   <= "10111";
    s_iIFIDRegRs   <= "10111";
    s_iIFIDRegRt   <= "11111";	
    s_iJump	   <= '0';
    s_iJAL	   <= '0';
    s_iBranch 	   <= '0';
    s_iJR	   <= '1';
    wait for gCLK_HPER*2;

  end process;

end mixed;

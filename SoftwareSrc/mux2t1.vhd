-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 multiplexor
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1 is

  port(i_S 		            : in std_logic;
       i_D0 		            : in std_logic;
       i_D1 		            : in std_logic;
       o_O 		            : out std_logic);

end mux2t1;

architecture structure of mux2t1 is
  
  -- Describe the component entities as defined in Adder.vhd, Reg.vhd,
  -- Multiplier.vhd, RegLd.vhd (not strictly necessary).

component invg 
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

component andg2 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;


  -- Signal to carry not i_S
  signal s_N         : std_logic;
  -- Signal to carry stored or input from mux 0 value
  signal or_0        : std_logic;
  -- Signal to carry stored or input from mux 1 value
  signal or_1       : std_logic;

begin

 g_NotS: invg
 port MAP(i_A => i_S,
	  o_F => s_N);

g_And0: andg2
port MAP(i_A => i_D0,
	 i_B => s_N,
	 o_F => or_0);

g_And1: andg2
port MAP(i_A => i_D1,
	 i_B => i_S,
	 o_F => or_1);

g_OrOut: org2
port MAP(i_A => or_0,
	 i_B => or_1,
	 o_F => o_O);	

  end structure;
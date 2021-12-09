library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK  :in std_logic;
	i_WE        : in std_logic;
	i_RST 	    : in std_logic;
       i_WD         : in std_logic_vector(31 downto 0);	
       o_InsAdd     : out std_logic_vector(31 downto 0));

end PC;

architecture structural of PC is

  component DffR_N is
  --generic(N : integer := ); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1_N is
 -- generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

signal s_PCData : std_logic_vector(31 downto 0) := x"00400000";

begin

MUX1: mux2t1_N port map(
	i_S => i_RST,
	i_D0 => i_WD,
	i_D1 => x"00400000",
	o_O  => s_PCData);


  REG0: DffR_N port map(
       i_Clk => i_CLK,
       i_RST => '0',      
       i_WE  => '1', 
       i_D   => s_PCData,          
       o_Q   => o_InsAdd);

end structural;
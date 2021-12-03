
library IEEE;
use IEEE.std_logic_1164.all;

entity IFIDPipeline is
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32

  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
	i_Stall	    	: in std_logic;
        i_Inst	    	: in std_logic_vector(31 downto 0);
	i_PCAddr    	: in std_logic_vector(31 downto 0);
        o_Inst		: out std_logic_vector(31 downto 0);     -- Data value input
        o_PCAddr        : out std_logic_vector(31 downto 0));   -- Data value output

end IFIDPipeline;

architecture mixed of IFIDPipeline is

component DffR_N is
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));

end component;

begin

INSTDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_Inst,
	o_Q   => o_Inst);

PCADDRDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_PCAddr,
	o_Q   => o_PCAddr);
 
end mixed;


library IEEE;
use IEEE.std_logic_1164.all;

entity EXMEMPipeline is
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32

  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
        i_ALURES	: in std_logic_vector(31 downto 0);
	i_Stall		: in std_logic;
	i_Inst	        : in std_logic_vector(31 downto 0);
	i_PCADDR    	: in std_logic_vector(31 downto 0);
	i_RT    	: in std_logic_vector(31 downto 0);
	i_RGDST	    	: in std_logic_vector(4 downto 0);
	i_Jal		: in std_logic;
	i_MemtoReg	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_MemWrEn	: in std_logic;
	i_Halt		: in std_logic;
       
	o_ALURES	: out std_logic_vector(31 downto 0);
	o_Inst	    	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_RT    	: out std_logic_vector(31 downto 0);
	o_RGDST		: out std_logic_vector(4 downto 0);
	o_Jal		: out std_logic;
	o_MemtoReg	: out std_logic;
	o_MemWrEn	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_Halt		: out std_logic);   -- Data value output

end EXMEMPipeline;

architecture mixed of EXMEMPipeline is

component DffR_N is
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));

end component;

component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;

component DffR_5 is
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(4 downto 0);
       o_Q          : out std_logic_vector(4 downto 0));

end component;

component DffR_3 is
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(2 downto 0);
       o_Q          : out std_logic_vector(2 downto 0));

end component;

component DffR_2 is
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(1 downto 0);
       o_Q          : out std_logic_vector(1 downto 0));

end component;

begin

INSTDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_Inst,
	o_Q   => o_Inst);

ALURESDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_ALURES,
	o_Q   => o_ALURES);

RTDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RT,
	o_Q   => o_RT);

PCADDRDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_PCADDR,
	o_Q   => o_PCADDR);


REGDSTDFF: DffR_5 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RGDST,
	o_Q   => o_RGDST);


MemToRegDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_MemtoReg,
	o_Q   => o_MemtoReg);

JALDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_Jal,
	o_Q   => o_Jal);

REGWRENDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RegWrEn,
	o_Q   => o_RegWrEn);

MEMWRENDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_MemWrEn,
	o_Q   => o_MemWrEn);

HALTDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_Halt,
	o_Q   => o_Halt);


 
end mixed;

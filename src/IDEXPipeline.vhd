
library IEEE;
use IEEE.std_logic_1164.all;

entity IDEXPipeline is
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32

  port( i_CLK        	: in std_logic;     -- Clock input
        i_RST        	: in std_logic;     -- Reset input
	i_Stall	   	: in std_logic;
        i_PA	    	: in std_logic_vector(31 downto 0);
	i_PB    	: in std_logic_vector(31 downto 0);
	i_RS	    	: in std_logic_vector(4 downto 0);
	i_RT    	: in std_logic_vector(4 downto 0);
	i_RD	    	: in std_logic_vector(4 downto 0);
	i_IMM    	: in std_logic_vector(31 downto 0);
	i_PCADDR	: in std_logic_vector(31 downto 0);
	i_ALUOP		: in std_logic_vector(2 downto 0);	
	i_Jal		: in std_logic;
	i_MemWrEn	: in std_logic;
	i_MemtoReg	: in std_logic;
	i_ALUSrc	: in std_logic;
	i_RegWrEn	: in std_logic;
	i_RegDst	: in std_logic;
	i_ADDSUB	: in std_logic;
	i_SHFTDIR	: in std_logic;
	i_SHFTTYPE	: in std_logic;
	i_Halt		: in std_logic;
	i_Unsigned	: in std_logic;
	i_SHAMT		: in std_logic_vector(4 downto 0);
	i_LogicCtrl	: in std_logic_vector(1 downto 0);
       
	o_PA	    	: out std_logic_vector(31 downto 0);
	o_PB    	: out std_logic_vector(31 downto 0);
	o_RS	    	: out std_logic_vector(4 downto 0);
	o_RT    	: out std_logic_vector(4 downto 0);
	o_RD	    	: out std_logic_vector(4 downto 0);
	o_IMM    	: out std_logic_vector(31 downto 0);
	o_PCADDR	: out std_logic_vector(31 downto 0);
	o_Jal		: out std_logic;
	o_MemWrEn	: out std_logic;
	o_MemtoReg	: out std_logic;
	o_ALUOP		: out std_logic_vector(2 downto 0);
	o_ALUSrc	: out std_logic;
	o_RegWrEn	: out std_logic;
	o_RegDst	: out std_logic;
	o_ADDSUB	: out std_logic;
	o_SHFTDIR	: out std_logic;
	o_SHFTTYPE	: out std_logic;
	o_Halt		: out std_logic;
	o_Unsigned	: out std_logic;
	o_SHAMT		: out std_logic_vector(4 downto 0);
	o_LogicCtrl	: out std_logic_vector(1 downto 0));   -- Data value output

end IDEXPipeline;

architecture mixed of IDEXPipeline is

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

PADFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_PA,
	o_Q   => o_PA);

PBDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_PB,
	o_Q   => o_PB);

PCADDRDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_PCADDR,
	o_Q   => o_PCADDR);

IMMDFF: DffR_N port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_IMM,
	o_Q   => o_IMM);

RSDFF: DffR_5 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RS,
	o_Q   => o_RS);

RTDFF: DffR_5 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RT,
	o_Q   => o_RT);

RDDFF: DffR_5 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RD,
	o_Q   => o_RD);

SHAMTDFF: DffR_5 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_SHAMT,
	o_Q   => o_SHAMT);

ALUOPDFF: DffR_3 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_ALUOP,
	o_Q   => o_ALUOP);


LGCTRLDFF: DffR_2 port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_LogicCtrl,
	o_Q   => o_LogicCtrl);

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

MemWrEnDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_MemWrEn,
	o_Q   => o_MemWrEn);

ALUSRCDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_ALUSrc,
	o_Q   => o_ALUSrc);

REGWRENDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RegWrEn,
	o_Q   => o_RegWrEn);

REGDSTDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_RegDst,
	o_Q   => o_RegDst);

ADDSUBDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_ADDSUB,
	o_Q   => o_ADDSUB);

SHFTDIRDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_SHFTDIR,
	o_Q   => o_SHFTDIR);

SHFTTYPEDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_SHFTTYPE,
	o_Q   => o_SHFTTYPE);

HALTDFF: dffg port map(
	i_Clk => i_CLK,
	i_RST => i_RST,
	i_WE  => i_Stall,
	i_D   => i_Halt,
	o_Q   => o_Halt);

UNSIGNEDDFF: dffg port map(
	i_CLK => i_CLK,
       i_RST  => i_RST,
       i_WE   => i_Stall,
       i_D    => i_Unsigned,
       o_Q    => o_Unsigned); 


 
end mixed;

library IEEE;
use IEEE.std_logic_1164.all;


entity FetchLogic is
	generic(N : integer := 32;
	DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 10);

  port( i_CLK                       : in std_logic;
        i_RST                       : in std_logic;
	i_Branch		    : in std_logic;
	i_BNE			    : in std_logic;
	i_Jal			    : in std_logic;
	i_ZERO			    : in std_logic;
	i_Jr			    : in std_logic;
	i_J			    : in std_logic;
	i_WRITEDST		    : in std_logic_vector(4 downto 0);
	i_JumpAddr		    : in std_logic_vector(25 downto 0);
	i_BranchImmAddr		    : in std_logic_vector(31 downto 0);
	i_WriteData		    : in std_logic_vector(31 downto 0);
	i_RS			    : in std_logic_vector(31 downto 0);
	o_WRITEDST		    : out std_logic_vector(4 downto 0);
	o_JaloDataWrite		    : out std_logic_vector(31 downto 0);
	o_InstrAddr		    : out std_logic_vector(31 downto 0));

end FetchLogic;

architecture structure of FetchLogic is

component AdderH_n is
 -- generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(	i_X         	: in std_logic_vector(N-1 downto 0);
	i_Y		: in std_logic_vector(N-1 downto 0);
	i_C		: in std_logic;
	o_C	    	: out std_logic;
       	o_B          	: out std_logic_vector(N-1 downto 0));

end component;

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1_5 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(5-1 downto 0);
       i_D1         : in std_logic_vector(5-1 downto 0);
       o_O          : out std_logic_vector(5-1 downto 0));

end component;

component mem is
	port 
	(	clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

end component;

component PC is
  port(	i_CLK  :in std_logic;
	i_WE        : in std_logic;
	i_RST 	    : in std_logic;
       	i_WD         : in std_logic_vector(31 downto 0);	
       	o_InsAdd     : out std_logic_vector(31 downto 0));

end component;

signal s_PCADD, S_InstrAddr, s_MEMDATA : std_logic_vector(31 downto 0);
signal s_JumpAddr, s_BranchAddr, s_BranchImmAddr, s_BRANCHoPC, s_BRANCHoBNEoPC, s_BRANCHoBNEoPCoJ, s_PCIN : std_logic_vector(31 downto 0);
--signal s_RS_A,  : std_logic_vector(31 downto 0);
signal s_oC, s_BAND0, s_NOTZERO, s_BNEANDNOTZERO : std_logic;


begin

PC1: PC port map(
	i_CLK  => i_CLK,
	i_WE   => '1',
	i_RST  => i_RST,
       	i_WD   => s_PCIN,	
       	o_InsAdd => s_InstrAddr);

o_InstrAddr <= s_InstrAddr;

PCADD1: AdderH_N port map(
	i_X  => s_InstrAddr,
	i_Y  => x"00000004",
	i_C  => '0',
	o_C  => s_oC, 
       	o_B  => s_PCADD);

s_JumpAddr <= s_PCADD(31 downto 28) & i_JumpAddr & "00";

JALWRITEDATA: mux2t1_n port map(
 	i_S  => i_Jal,
       i_D0  => i_WriteData,
       i_D1  => s_PCADD,
       o_O   => o_JaloDataWrite);

JALREGSEL: mux2t1_5 port map(
	i_S  => i_Jal,
       i_D0  => i_WRITEDST,
       i_D1  => "11111",
       o_O   => o_WRITEDST);

s_BranchImmAddr <= i_BranchImmAddr(29 downto 0) & "00";

BRANCHADDER: AdderH_n port map(
	i_X  => s_PCADD,
	i_Y  => s_BranchImmAddr,
	i_C  => '0',
	o_C  => s_oC, 
       	o_B  => s_BranchAddr);

BRANCHANDZERO: andg2 port map(
	i_A  => i_Branch,
       i_B   => i_ZERO,
       o_F   => s_BAND0);
	
BRANCHMUX: mux2t1_N port map(i_S => s_BAND0,
       i_D0 => s_PCADD,
       i_D1 => s_BranchAddr,
       o_O  => s_BRANCHoPC);

NOT0: invg port map(
	i_A => i_ZERO,
       o_F  => s_NOTZERO);

ANDNOTZEROBNE: andg2 port map(
	i_A  => i_BNE,
       i_B   => s_NOTZERO,
       o_F   => s_BNEANDNOTZERO);

BNEMUX: mux2t1_N port map(i_S => s_BNEANDNOTZERO,
       i_D0 => s_BRANCHoPC,
       i_D1 => s_BranchAddr,
       o_O  => s_BRANCHoBNEoPC);
	
JOBRANCHMUX: mux2t1_N port map(
	i_S => i_J,
       i_D0 => s_BRANCHoBNEoPC,
       i_D1 => s_JumpAddr,
       o_O  => s_BRANCHoBNEoPCoJ);

JRMUX: mux2t1_N port map(
	i_S => i_Jr,
       i_D0 => s_BRANCHoBNEoPCoJ,
       i_D1 => i_RS,
       o_O  => s_PCIN);



  end structure;

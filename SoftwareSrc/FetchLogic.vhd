library IEEE;
use IEEE.std_logic_1164.all;


entity FetchLogic is
	generic(N : integer := 32);

  port( i_Branch		    : in std_logic;
	i_BNE			    : in std_logic;
	i_Jr			    : in std_logic;
	i_J			    : in std_logic;
	i_JumpAddr		    : in std_logic_vector(25 downto 0);
	i_Imm			    : in std_logic_vector(31 downto 0);
	i_PCAddr		    : in std_logic_vector(31 downto 0);
	i_PA			    : in std_logic_vector(31 downto 0);
	i_PB			    : in std_logic_vector(31 downto 0);
	o_PCADDRNext		    : out std_logic_vector(31 downto 0);
	o_Flush			    : out std_logic);

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

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


component AdderSub_N is

  port(i_X 		            :in std_logic_vector(N-1 downto 0);
       i_Y 		            :in std_logic_vector(N-1 downto 0);
       Add_Sub	 		    : in std_logic;
       o_C 		            : out std_logic;
	o_Over			    : out std_logic;
       o_B 		            : out std_logic_vector(N-1 downto 0));

end component;

component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

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

signal s_PCADD, S_InstrAddr, s_MEMDATA, s_BranchZero : std_logic_vector(31 downto 0);
signal s_JumpAddr, s_BranchAddr, s_BranchImmAddr, s_BRANCHoPC, s_BRANCHoBNEoPC, s_BRANCHoBNEoPCoJ : std_logic_vector(31 downto 0);
--signal s_RS_A,  : std_logic_vector(31 downto 0);
signal s_BAND0, s_NOTZERO, s_BNEANDNOTZERO, s_Zero1, s_Branch, s_Over1 : std_logic;


begin
s_PCADD <= i_PCAddr;
s_JumpAddr <= s_PCADD(31 downto 28) & i_JumpAddr & "00";
s_BranchImmAddr <= i_Imm(29 downto 0) & "00";

BRANCHADDER: AdderH_n port map(
	i_X  => s_PCADD,
	i_Y  => s_BranchImmAddr,
	i_C  => '0',
	o_C  => open, 
       	o_B  => s_BranchAddr);

BRACNHZERO: AdderSub_N port map(
	i_X => i_PA,
       	i_Y => i_PB, 
       	Add_Sub	 => '1',
       	o_C => open,
	o_Over	=> s_Over1,
       	o_B  => s_BranchZero);
		

s_Zero1 <= not(s_BranchZero(0) or s_BranchZero(1) or s_BranchZero(2) or
		s_BranchZero(3) or s_BranchZero(4) or s_BranchZero(5) or
		s_BranchZero(6) or s_BranchZero(7) or s_BranchZero(8) or
		s_BranchZero(9) or s_BranchZero(10) or s_BranchZero(11) or
		s_BranchZero(12) or s_BranchZero(13) or s_BranchZero(14) or
		s_BranchZero(15) or s_BranchZero(16) or s_BranchZero(17) or
		s_BranchZero(18) or s_BranchZero(19) or s_BranchZero(20) or
		s_BranchZero(21) or s_BranchZero(22) or s_BranchZero(23) or
		s_BranchZero(24) or s_BranchZero(25) or s_BranchZero(26) or
		s_BranchZero(27) or s_BranchZero(28) or s_BranchZero(29) or
		s_BranchZero(30) or s_BranchZero(31));

BRANCHANDZERO: andg2 port map(
	i_A  => i_Branch,
       i_B   => s_Zero1,
       o_F   => s_BAND0);

NOT0: invg port map(
	i_A => s_Zero1,
       o_F  => s_NOTZERO);

ANDNOTZEROBNE: andg2 port map(
	i_A  => i_BNE,
       i_B   => s_NOTZERO,
       o_F   => s_BNEANDNOTZERO);

BORBNE: org2 port map(
	i_A => s_BNEANDNOTZERO,
	i_B => s_BAND0,
	o_F => s_Branch);

BRANCHMUX: mux2t1_N port map(i_S => s_Branch,
       i_D0 => s_PCADD,
       i_D1 => s_BranchAddr,
       o_O  => s_BRANCHoPC);

JOBRANCHMUX: mux2t1_N port map(
	i_S => i_J,
       i_D0 => s_BRANCHoPC,
       i_D1 => s_JumpAddr,
       o_O  => s_BRANCHoBNEoPCoJ);

JRMUX: mux2t1_N port map(
	i_S => i_Jr,
       i_D0 => s_BRANCHoBNEoPCoJ,
       i_D1 => i_PA,
       o_O  => o_PCADDRNext);

o_Flush <= (i_J or i_Jr or i_Branch or i_BNE);

  end structure;

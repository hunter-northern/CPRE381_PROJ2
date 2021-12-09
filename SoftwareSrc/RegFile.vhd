library IEEE;
use IEEE.std_logic_1164.all;

entity RegFile is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK  :in std_logic;
	i_WE        : in std_logic;
	i_RST 	    : in std_logic;
       i_WRN        : in std_logic_vector(4 downto 0);
       i_WD         : in std_logic_vector(31 downto 0);	
       i_RPA	    : in std_logic_vector(4 downto 0);
       i_RPB	    : in std_logic_vector(4 downto 0);
       o_RPA	    : out std_logic_vector(31 downto 0);
       o_RPB 	    : out std_logic_vector(31 downto 0));

end RegFile;

architecture structural of RegFile is

  component DffR_N is
  --generic(N : integer := ); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Clk        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;	
       i_D	    : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));

end component;

component decoder5t32 is

  port(i_S  : in std_logic_vector (4 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end component;

component mux32t1 is

  port(i_S  : in std_logic_vector (4 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	i_R4 : in std_logic_vector(31 downto 0);
	i_R5 : in std_logic_vector(31 downto 0);
	i_R6 : in std_logic_vector(31 downto 0);
	i_R7 : in std_logic_vector(31 downto 0);
	i_R8 : in std_logic_vector(31 downto 0);
	i_R9 : in std_logic_vector(31 downto 0);
	i_R10 : in std_logic_vector(31 downto 0);
	i_R11 : in std_logic_vector(31 downto 0);
	i_R12 : in std_logic_vector(31 downto 0);
	i_R13 : in std_logic_vector(31 downto 0);
	i_R14 : in std_logic_vector(31 downto 0);
	i_R15 : in std_logic_vector(31 downto 0);
	i_R16 : in std_logic_vector(31 downto 0);
	i_R17 : in std_logic_vector(31 downto 0);
	i_R18 : in std_logic_vector(31 downto 0);
	i_R19 : in std_logic_vector(31 downto 0);
	i_R20 : in std_logic_vector(31 downto 0);
	i_R21 : in std_logic_vector(31 downto 0);
	i_R22 : in std_logic_vector(31 downto 0);
	i_R23 : in std_logic_vector(31 downto 0);
	i_R24 : in std_logic_vector(31 downto 0);
	i_R25 : in std_logic_vector(31 downto 0);
	i_R26 : in std_logic_vector(31 downto 0);
	i_R27 : in std_logic_vector(31 downto 0);
	i_R28 : in std_logic_vector(31 downto 0);
	i_R29 : in std_logic_vector(31 downto 0);
	i_R30 : in std_logic_vector(31 downto 0);
	i_R31 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end component;

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

type sig_Deco is array (0 to 31) of std_logic;
signal sigDeco : sig_Deco;

type WriteSignal is array (0 to 31) of std_logic;
signal sigWri : WriteSignal;

type RegBus is array (0 to 31) of std_logic_vector(31 downto 0);
signal sigBus : RegBus;

signal DecoderOutput : std_logic_vector(31 downto 0);

begin

G_DECO: decoder5t32 port map(
	i_S  => i_WRN,
	o_Y => DecoderOutput);

  G_ANDWRITE: for i in 0 to N-1 generate
    ANDG: andg2 port map(
	i_A => DecoderOutput(i),
	i_B => i_WE,
	o_F => sigWri(i));
 end generate G_ANDWRITE;

  REG0: DffR_N port map(
       i_Clk => i_CLK,
       i_RST => '1',      
       i_WE  => '0', 
       i_D   => i_WD,          
       o_Q   => sigBus(0));

G_REGYTIME: for i in 1 to N-1 generate
	REGBIG: DffR_N port map(
        i_Clk    => i_CLK,      -- All instances share the same select input.
        i_RST     => i_RST,  -- ith instance's data 0 input hooked up to ith data 0 input.
        i_WE     => sigWri(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
        i_D      => i_WD,    
	o_Q      => sigBus(i));
end generate G_REGYTIME;

G_MUXPRTA: mux32t1 port map(
  i_S => i_RPA,
  i_R0 => sigBus(0),
i_R1 => sigBus(1),
i_R2 => sigBus(2),
i_R3 => sigBus(3),
i_R4 => sigBus(4),
i_R5 => sigBus(5),
i_R6 => sigBus(6),
i_R7 => sigBus(7),
i_R8 => sigBus(8),
i_R9 => sigBus(9),
i_R10 => sigBus(10),
i_R11 => sigBus(11),
i_R12 => sigBus(12),
i_R13 => sigBus(13),
i_R14 => sigBus(14),
i_R15 => sigBus(15),
i_R16 => sigBus(16),
i_R17 => sigBus(17),
i_R18 => sigBus(18),
i_R19 => sigBus(19),
i_R20 => sigBus(20),
i_R21 => sigBus(21),
i_R22 => sigBus(22),
i_R23 => sigBus(23),
i_R24 => sigBus(24),
i_R25 => sigBus(25),
i_R26 => sigBus(26),
i_R27 => sigBus(27),
i_R28 => sigBus(28),
i_R29 => sigBus(29),
i_R30 => sigBus(30),
i_R31 => sigBus(31),
o_Y => o_RPA);

G_MUXPRTB: mux32t1 port map(
  i_S => i_RPB,
  i_R0 => sigBus(0),
i_R1 => sigBus(1),
i_R2 => sigBus(2),
i_R3 => sigBus(3),
i_R4 => sigBus(4),
i_R5 => sigBus(5),
i_R6 => sigBus(6),
i_R7 => sigBus(7),
i_R8 => sigBus(8),
i_R9 => sigBus(9),
i_R10 => sigBus(10),
i_R11 => sigBus(11),
i_R12 => sigBus(12),
i_R13 => sigBus(13),
i_R14 => sigBus(14),
i_R15 => sigBus(15),
i_R16 => sigBus(16),
i_R17 => sigBus(17),
i_R18 => sigBus(18),
i_R19 => sigBus(19),
i_R20 => sigBus(20),
i_R21 => sigBus(21),
i_R22 => sigBus(22),
i_R23 => sigBus(23),
i_R24 => sigBus(24),
i_R25 => sigBus(25),
i_R26 => sigBus(26),
i_R27 => sigBus(27),
i_R28 => sigBus(28),
i_R29 => sigBus(29),
i_R30 => sigBus(30),
i_R31 => sigBus(31),
o_Y => o_RPB);
  
end structural;
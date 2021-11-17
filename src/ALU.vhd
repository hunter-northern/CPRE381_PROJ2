-- AdderH.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 multiplexor
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--vsim -voptargs="+acc" tb_mux2t1_N
entity ALU is
	generic(N : integer := 32);

  port(i_PA 		            : in std_logic_vector(N-1 downto 0);
       i_PBoIMM		            : in std_logic_vector(N-1 downto 0);
	i_SHAMT			    : in std_logic_vector(4 downto 0);
	i_ALUOP			    : in std_logic_vector(2 downto 0);
	i_ShftDIR		    : in std_logic;
	i_LogicCtrl		    : in std_logic_vector(1 downto 0);
	i_AddSub		    : in std_logic;
	i_ShftTYP		    : in std_logic;
	i_Unsign		    : in std_logic;
        o_ALURES 		    : out std_logic_vector(N-1 downto 0);
	o_OvrFlw 	            : out std_logic;
	o_ZERO 		            : out std_logic);

end ALU;

architecture structure of ALU is
  
component LogicUnit
  --generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_PA 		            :in std_logic_vector(N-1 downto 0);
       i_PB 		            :in std_logic_vector(N-1 downto 0);
       o_AND 		            : out std_logic_vector(N-1 downto 0);
	o_OR 		            : out std_logic_vector(N-1 downto 0);
	o_NOR 		            : out std_logic_vector(N-1 downto 0);
	o_XOR 		            : out std_logic_vector(N-1 downto 0));
end component;

component barrelShifter
port(i_X : in std_logic_vector(31 downto 0);
       i_shamt : in std_logic_vector(4 downto 0);
       i_type : in std_logic; -- 0 for logical, 1 for arithmetic
       i_dir : in std_logic; -- 0 for right, 1 for left
       o_Y : out std_logic_vector(31 downto 0));
end component;

component AdderSub_N
  port(i_X 		            :in std_logic_vector(N-1 downto 0);
       i_Y 		            :in std_logic_vector(N-1 downto 0);
       Add_Sub	 		    : in std_logic;
       o_C 		            : out std_logic;
       o_Over			    : out std_logic;
       o_B 		            : out std_logic_vector(N-1 downto 0));
end component;

component mux4t1 is

  port(i_S  : in std_logic_vector (1 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end component;

component mux8t1 is

  port(i_S  : in std_logic_vector (2 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	i_R4 : in std_logic_vector(31 downto 0);
	i_R5 : in std_logic_vector(31 downto 0);
	i_R6 : in std_logic_vector(31 downto 0);
	i_R7 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end component;

component mux2t1 is

  port(i_S 		            : in std_logic;
       i_D0 		            : in std_logic;
       i_D1 		            : in std_logic;
       o_O 		            : out std_logic);

end component;

signal s_AND, s_OR, s_XOR, s_NOR, s_LOGIC : std_logic_vector(N-1 downto 0);
signal s_Overflow, s_Carry : std_logic;
signal s_REPLQB, s_ADDERES, s_SLT, s_SHIFT, s_LUI : std_logic_vector(N-1 downto 0);

begin

DUTSHIFT: barrelShifter port map(
		i_X => i_PBoIMM,
       		i_shamt =>  i_SHAMT, 
       		i_type =>  i_ShftTYP,
       		i_dir   => i_ShftDIR,
       		o_Y => s_SHIFT);

DUTADDR: AdderSub_N port map(
	i_X  => i_PA,
       i_Y   => i_PBoIMM,
       Add_Sub => i_AddSub,
       o_C     => s_Carry,
       o_Over  => s_Overflow,
       o_B   => s_ADDERES);

s_SLT <= ("0000000000000000000000000000000" & s_ADDERES(31));

o_ZERO <= not(s_ADDERES(0) or s_ADDERES(1) or s_ADDERES(2) or
		s_ADDERES(3) or s_ADDERES(4) or s_ADDERES(5) or
		s_ADDERES(6) or s_ADDERES(7) or s_ADDERES(8) or
		s_ADDERES(9) or s_ADDERES(10) or s_ADDERES(11) or
		s_ADDERES(12) or s_ADDERES(13) or s_ADDERES(14) or
		s_ADDERES(15) or s_ADDERES(16) or s_ADDERES(17) or
		s_ADDERES(18) or s_ADDERES(19) or s_ADDERES(20) or
		s_ADDERES(21) or s_ADDERES(22) or s_ADDERES(23) or
		s_ADDERES(24) or s_ADDERES(25) or s_ADDERES(26) or
		s_ADDERES(27) or s_ADDERES(28) or s_ADDERES(29) or
		s_ADDERES(30) or s_ADDERES(31));

DUTMUXUNSIGN: mux2t1 port map(
	i_S => i_Unsign,
	i_D0 => s_Overflow,
	i_D1 => '0',
	o_O  => o_OvrFlw);


DUTLOGICUNIT: LogicUnit port map(
	i_PA => i_PA,
        i_PB  => i_PBoIMM,		            
        o_AND => s_AND,		
	o_OR => s_OR,		           
	o_NOR => s_NOR,	          
	o_XOR => s_XOR);

DUTMUX4LOG: mux4t1 port map(
	i_S  => i_LogicCtrl,
	i_R0 => s_AND,
	i_R1 => s_OR,
	i_R2 => s_NOR,
	i_R3 => s_XOR,
	o_Y  => s_LOGIC);

s_LUI <= (i_PBoIMM(15 downto 0) & x"0000");
s_REPLQB <= (i_PBoIMM(7 downto 0) & i_PBoIMM(7 downto 0) 
		& i_PBoIMM(7 downto 0) & i_PBoIMM(7 downto 0));

DUTALUMUX: mux8t1 port map(
	i_S  => i_ALUOP,
	i_R0 => s_SHIFT,
	i_R1 => s_SLT,
	i_R2 => s_ADDERES,
	i_R3 => s_LOGIC,
	i_R4 => s_LUI,
	i_R5 => s_REPLQB,
	i_R6 => x"00000000",
	i_R7 => x"00000000",
	o_Y => o_ALURES);
	


  end structure;

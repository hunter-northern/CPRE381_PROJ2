library IEEE;
use IEEE.std_logic_1164.all;

entity AdderH_n is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_X         : in std_logic_vector(N-1 downto 0);
	i_Y		: in std_logic_vector(N-1 downto 0);
	i_C		: in std_logic;
	o_C		: out std_logic;
	o_Over		: out std_logic;
       o_B          : out std_logic_vector(N-1 downto 0));

end AdderH_n;

architecture structural of AdderH_n is

  component AdderH is

  port(i_X 		            : in std_logic;
       i_Y 		            : in std_logic;
       i_C 		            : in std_logic;
       o_C 		            : out std_logic;
       o_B 		            : out std_logic);


  end component;

component xorg2 is
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;


signal carry :  std_logic_vector(N-1 downto 0);

begin

    ADD0: AdderH port map(i_X     => i_X(0),  -- ith instance's data 1 input hooked up to ith data 1 input.
              		i_Y     => i_Y(0),
			i_C     => i_C,
			o_B     => o_B(0),
                       o_C      => carry(0));  -- ith instance's data output hooked up to ith data output.


  -- Instantiate N Adder instances.
  G_NBit_AdderH: for i in 1 to N-2 generate
    ADDH: AdderH port map(i_X     => i_X(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              		i_Y     => i_Y(i),
			i_C     => carry(i-1),
			o_B     => o_B(i),
                       o_C      => carry(i));  -- ith instance's data output hooked up to ith data output.

end generate G_NBit_AdderH;

ADDL: AdderH port map(i_X     => i_X(N-1),  -- ith instance's data 1 input hooked up to ith data 1 input.
              		i_Y     => i_Y(N-1),
			i_C     => carry(N-2),
			o_B     => o_B(N-1),
                       o_C      => carry(N-1));  -- ith instance's data output hooked up to ith data output.

OVRFLW: xorg2 port map(i_A => carry(N-2),
			i_B => carry(N-1),
			o_F => o_Over);
o_C <= carry(N-1);

end structural;
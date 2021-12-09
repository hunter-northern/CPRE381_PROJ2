library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1 is

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

end mux32t1;

architecture structure of mux32t1 is
begin

o_Y <=
i_R0 when i_S = "00000" else
i_R1 when i_S = "00001" else
i_R2 when i_S = "00010" else
i_R3 when i_S = "00011" else
i_R4 when i_S = "00100" else
i_R5 when i_S = "00101" else
i_R6 when i_S = "00110" else
i_R7 when i_S = "00111" else
i_R8 when i_S = "01000" else
i_R9 when i_S = "01001" else
i_R10 when i_S = "01010" else
i_R11 when i_S = "01011" else
i_R12 when i_S = "01100" else
i_R13 when i_S = "01101" else
i_R14 when i_S = "01110" else
i_R15 when i_S = "01111" else
i_R16 when i_S = "10000" else
i_R17 when i_S = "10001" else
i_R18 when i_S = "10010" else
i_R19 when i_S = "10011" else
i_R20 when i_S = "10100" else
i_R21 when i_S = "10101" else
i_R22 when i_S = "10110" else
i_R23 when i_S = "10111" else
i_R24 when i_S = "11000" else
i_R25 when i_S = "11001" else
i_R26 when i_S = "11010" else
i_R27 when i_S = "11011" else
i_R28 when i_S = "11100" else
i_R29 when i_S = "11101" else
i_R30 when i_S = "11110" else
i_R31 when i_S = "11111";
end structure;
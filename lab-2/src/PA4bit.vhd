library IEEE;
use IEEE.std_logic_1164.all;

entity four_bit_adder is
    Port ( A, B : in  std_logic_vector(3 downto 0);
           Cin    : in  std_logic;
           Sum    : out std_logic_vector(3 downto 0);
           Cout   : out std_logic);
end four_bit_adder;

architecture structural of four_bit_adder is

    component full_adder
        Port ( A, B, Cin : in  std_logic;
               Sum, Cout : out  std_logic);
    end component;

    signal Carry : std_logic_vector(3 downto 0);

begin

    FA0: full_adder port map (
        A => A(0),
        B => B(0),
        Cin => Cin,
        Sum => Sum(0),
        Cout => Carry(0)
    );

    FA1: full_adder port map (
        A => A(1),
        B => B(1),
        Cin => Carry(0),
        Sum => Sum(1),
        Cout => Carry(1)
    );

    FA2: full_adder port map (
        A => A(2),
        B => B(2),
        Cin => Carry(1),
        Sum => Sum(2),
        Cout => Carry(2)
    );

    FA3: full_adder port map (
        A => A(3),
        B => B(3),
        Cin => Carry(2),
        Sum => Sum(3),
        Cout => Cout
    );

end structural;
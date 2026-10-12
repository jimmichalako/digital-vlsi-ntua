library IEEE;
use IEEE.std_logic_1164.all;

entity bcd is
    port ( A, B : in  std_logic_vector(3 downto 0);
           Cin : in std_logic;
           Sum : out  std_logic_vector(3 downto 0);
           Cout : out std_logic);
end bcd;

architecture structural of bcd is

    component four_bit_adder
        port ( A, B : in  std_logic_vector(3 downto 0);
               Cin : in std_logic;
               Sum : out  std_logic_vector(3 downto 0);
               Cout : out std_logic);
    end component;

    signal Sum1, B1 : std_logic_vector(3 downto 0);
    signal Carry1, Carry2, Carry3 : std_logic;

begin
    BinSum: four_bit_adder port map (
        A => A,
        B => B,
        Sum => Sum1,
        Cin => Cin,
        Cout => Carry1
    );

    Carry2 <= Carry1 or (Sum1(3) and Sum1(2)) or (Sum1(3) and Sum1(1));

    B1(0) <= '0';
    B1(1) <= Carry2;
    B1(2) <= Carry2;
    B1(3) <= '0';

    BCDSum: four_bit_adder port map (
        A => Sum1,
        B => B1,
        Sum => Sum,
        Cin => '0',
        Cout => Carry3
    );

    Cout <= Carry2;
end structural;
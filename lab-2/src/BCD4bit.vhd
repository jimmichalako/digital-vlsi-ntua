library IEEE;
use IEEE.std_logic_1164.all;

entity four_bit_bcd is
    port ( A, B : in  std_logic_vector(15 downto 0);
           Cin  : in  std_logic;
           Sum  : out std_logic_vector(15 downto 0);
           Cout : out std_logic);
end four_bit_bcd;

architecture structural of four_bit_bcd is

    component bcd is
        port ( A, B : in  std_logic_vector(3 downto 0);
               Cin : in std_logic;
               Sum : out  std_logic_vector(3 downto 0);
               Cout : out std_logic);
    end component;

    signal Carry : std_logic_vector(2 downto 0);

begin

    BCD1 : bcd port map (
        A => A(3 downto 0),
        B => B(3 downto 0),
        Cin => Cin,
        Sum => Sum(3 downto 0),
        Cout => Carry(0)
    );

    BCD2 : bcd port map (
        A => A(7 downto 4),
        B => B(7 downto 4),
        Cin => Carry(0),
        Sum => Sum(7 downto 4),
        Cout => Carry(1)
    );

    BCD3 : bcd port map (
        A => A(11 downto 8),
        B => B(11 downto 8),
        Cin => Carry(1),
        Sum => Sum(11 downto 8),
        Cout => Carry(2)
    );

    BCD4 : bcd port map (
        A => A(15 downto 12),
        B => B(15 downto 12),
        Cin => Carry(2),
        Sum => Sum(15 downto 12),
        Cout => Cout
    );

end structural;
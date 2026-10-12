library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
    Port ( A, B, Cin : in  std_logic;
           Sum, Cout : out  std_logic);
end full_adder;

architecture structural of full_adder is

    component half_adder
        Port ( A, B : in  std_logic;
               Sum, Carry : out  std_logic);
    end component;

    signal Sum1, Carry1, Carry2 : std_logic;

begin

    HA1: half_adder port map (
        A => A,
        B => B,
        Sum => Sum1,
        Carry => Carry1
    );

    HA2: half_adder port map (
        A => Sum1,
        B => Cin,
        Sum => Sum,
        Carry => Carry2
    );

    Cout <= Carry1 or Carry2;
    
end structural;
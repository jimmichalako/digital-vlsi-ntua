library IEEE;
use IEEE.std_logic_1164.all;

entity mac is 
    port (A, B, S_in, Cin, Clk : in std_logic;
          Sum, Cout : out std_logic);
end mac;

architecture Structural of mac is

    component sync_full_adder is
        port (A, B, Cin, Clk : in  std_logic;
              Sum, Cout : out  std_logic);
    end component;

    signal mult_result : std_logic;

begin
    process (A, B)
    begin
        mult_result <= A and B;
    end process;
    
    FA: sync_full_adder port map(
        A => mult_result,
        B => S_in,
        Cin => Cin,
        Clk => Clk,
        Sum => Sum,
        Cout => Cout
    );
end Structural;
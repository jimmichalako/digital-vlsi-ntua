library IEEE;
use IEEE.std_logic_1164.all;

entity half_adder_tb is
end half_adder_tb;

architecture tb_arch of half_adder_tb is

    component half_adder
        Port ( A, B : in  std_logic;
               Sum, Carry : out  std_logic);
    end component;
    
    signal A_tb, B_tb, Sum_tb, Carry_tb : std_logic;

begin

    DUT: half_adder port map (
        A => A_tb,
        B => B_tb,
        Sum => Sum_tb,
        Carry => Carry_tb
    );

    stimulus_proc: process
    begin
        A_tb <= '0';
        B_tb <= '0';
        wait for 10 ns;

        A_tb <= '0';
        B_tb <= '1';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '0';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '1';
        wait for 10 ns;

        wait;
    end process;
end tb_arch;
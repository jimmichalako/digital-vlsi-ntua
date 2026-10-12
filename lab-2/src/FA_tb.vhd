library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_tb is
end full_adder_tb;

architecture tb_arch of full_adder_tb is

    component full_adder
        Port ( A, B, Cin : in  std_logic;
               Sum, Cout : out  std_logic);
    end component;

    signal A_tb, B_tb, Cin_tb, Sum_tb, Cout_tb : std_logic;

begin

    DUT: full_adder port map (
        A => A_tb,
        B => B_tb,
        Cin => Cin_tb,
        Sum => Sum_tb,
        Cout => Cout_tb
    );

    stimulus_proc: process
    begin
        A_tb <= '0';
        B_tb <= '0';
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= '0';
        B_tb <= '0';
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= '0';
        B_tb <= '1';
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= '0';
        B_tb <= '1';
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '0';
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '0';
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '1';
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= '1';
        B_tb <= '1';
        Cin_tb <= '1';
        wait for 10 ns;

        wait;
    end process;
end tb_arch;
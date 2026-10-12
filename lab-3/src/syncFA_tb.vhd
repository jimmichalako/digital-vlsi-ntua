library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_tb is
end full_adder_tb;

architecture tb_arch of full_adder_tb is

    component sync_full_adder
        Port ( A, B, Cin, Clk : in  std_logic;
               Sum, Cout : out  std_logic);
    end component;

    signal A_tb, B_tb, Cin_tb, Clk_tb, Sum_tb, Cout_tb : std_logic;
    constant CLK_PERIOD : time := 5 ns;

begin

    DUT: sync_full_adder port map (
        A => A_tb,
        B => B_tb,
        Cin => Cin_tb,
        Clk => Clk_tb,
        Sum => Sum_tb,
        Cout => Cout_tb
    );

    clk_process: process
    begin
        while true loop
            Clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            Clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stimulus_proc: process
    begin
        for i in 0 to 7 loop
            for i in std_logic range '0' to '1' loop
                A_tb <= i;
                for j in std_logic range '0' to '1' loop
                    B_tb <= j;
                    for k in std_logic range '0' to '1' loop
                        Cin_tb <= k;
                        wait for 10 ns;
                    end loop;
                end loop;
            end loop;
        end loop;
        wait;
    end process;
end tb_arch;
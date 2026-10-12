library IEEE;
use IEEE.std_logic_1164.all;

entity bcd_tb is
end bcd_tb;

architecture tb_arch of bcd_tb is

    component bcd
        Port ( A, B : in  std_logic_vector(3 downto 0);
               Cin : in std_logic;
               Sum : out  std_logic_vector(3 downto 0);
               Cout : out std_logic);
    end component;

    signal A_tb, B_tb, Sum_tb : std_logic_vector(3 downto 0);
    signal Cin_tb, Cout_tb : std_logic;

begin

    DUT: bcd port map (
        A => A_tb,
        B => B_tb,
        Cin => Cin_tb,
        Sum => Sum_tb,
        Cout => Cout_tb
    );

    stimulus_process: process

    begin
        A_tb <= "0100";
        B_tb <= "0010";
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= "1001";
        B_tb <= "0001";
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= "0110";
        B_tb <= "0111";
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= "1000";
        B_tb <= "0101";
        Cin_tb <= '0';
        wait for 10 ns;

        wait;
    end process;

end tb_arch;
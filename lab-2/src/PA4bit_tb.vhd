library IEEE;
use IEEE.std_logic_1164.all;

entity four_bit_adder_tb is
end four_bit_adder_tb;

architecture tb_arch of four_bit_adder_tb is

    component four_bit_adder
        Port ( A, B : in  std_logic_vector(3 downto 0);
               Cin    : in  std_logic;
               Sum    : out std_logic_vector(3 downto 0);
               Cout   : out std_logic);
    end component;

    signal A_tb, B_tb, Sum_tb : std_logic_vector(3 downto 0);
    signal Cin_tb, Cout_tb : std_logic;

begin

    DUT: four_bit_adder port map (
        A    => A_tb,
        B    => B_tb,
        Cin  => Cin_tb,
        Sum  => Sum_tb,
        Cout => Cout_tb
        );

    stimulus_proc: process
    begin
        A_tb <= "0010";
        B_tb <= "0110";
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= "0101";
        B_tb <= "1100";
        Cin_tb <= '0';
        wait for 10 ns;

        A_tb <= "1111";
        B_tb <= "0011";
        Cin_tb <= '1';
        wait for 10 ns;

        A_tb <= "1000";
        B_tb <= "0110";
        Cin_tb <= '1';
        wait for 10 ns;

        wait;
    end process stimulus_proc;
    
end tb_arch;
library IEEE;
use IEEE.std_logic_1164.all;

entity four_bit_bcd_tb is
end four_bit_bcd_tb;

architecture tb_arch of four_bit_bcd_tb is

    component four_bit_bcd is
        port ( A, B : in  std_logic_vector(15 downto 0);
               Cin  : in  std_logic;
               Sum  : out std_logic_vector(15 downto 0);
               Cout : out std_logic);
    end component;

    signal A_tb, B_tb, Sum_tb : std_logic_vector(15 downto 0);
    signal Cin_tb, Cout_tb : std_logic;

begin

  DUT: four_bit_bcd port map (
        A => A_tb,
        B => B_tb,
        Cin => Cin_tb,
        Sum => Sum_tb,
        Cout => Cout_tb
    );

    stim_proc: process
    begin
        A_tb <= "0000000101110101"; --  175
        B_tb <= "0000001101000111"; -- +347
        Cin_tb <= '0';              -- 522 = "0000 0101 0010 0010"
        wait for 10 ns;
        
        A_tb <= "0110010100010011"; --  6513
        B_tb <= "0101010000100110"; -- +5426
        Cin_tb <= '0';              -- (Cout=1)1939 = "0001 1001 0011 1001"
        wait for 10 ns;
        
        A_tb <= "0000000000000110"; --  6
        B_tb <= "0000000000000011"; -- +3
        Cin_tb <= '1';              -- +1 (Cin)
        wait for 10 ns;             -- 10="0000000000010000"
        
        wait;
    end process;

end tb_arch;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sync_Mult_4bit_tb is
end entity;

architecture Behavioral of Sync_Mult_4bit_tb is
    component Sync_Mult_4bit is
        port (A, B : in std_logic_vector(3 downto 0);
              Clk : in std_logic;
              Product : out std_logic_vector(7 downto 0));
    end component;
    signal A_tb, B_tb : std_logic_vector(3 downto 0);
    signal P    : std_logic_vector(7 downto 0);
    signal Clk  : std_logic := '0';

begin
    DUT: Sync_Mult_4bit 
        port map (
            A => A_tb,
            B => B_tb,
            Clk => Clk, 
            Product => P
        );

    clk_proc: process is
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;

    stimulus: process is
    begin

    wait for 10 ns;

    for i in 0 to 15 loop
      A_tb <= std_logic_vector(to_unsigned(i, A_tb'length));
      for j in 0 to 15 loop
        B_tb <= std_logic_vector(to_unsigned(j, B_tb'length));
        wait for 10 ns;
      end loop;
    end loop;
  end process;

end architecture;
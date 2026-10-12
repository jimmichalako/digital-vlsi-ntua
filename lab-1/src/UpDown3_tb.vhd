library IEEE;
use IEEE.std_logic_1164.all;

entity count3_tb is
end entity count3_tb;

architecture tb_arch of count3_tb is
    constant CLOCK_PERIOD : time := 10 ns;

    signal clk, resetn, count_en, count_up_en : std_logic := '0';
    signal sum : std_logic_vector(2 downto 0);
    signal cout : std_logic;

    component count3
        port(
            clk, resetn, count_en, count_up_en : in std_logic;
            sum : out std_logic_vector(2 downto 0);
            cout : out std_logic
        );
    end component;

begin
    DUT: count3
    port map (
        clk => clk,
        resetn => resetn,
        count_en => count_en,
        count_up_en => count_up_en,
        sum => sum,
        cout => cout
    );

    clk_process: process
    begin
        while now < 250 ns loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stimulus: process
    begin
        resetn <= '1';
        count_en <= '0';
        count_up_en <= '1';
        wait for 20 ns;

        count_en <= '1';
        wait for 100 ns;
        
        count_up_en <= '0';
        wait for 50 ns;

        resetn <= '0';
        wait for 20 ns;
        resetn <= '1';
        wait for 50 ns;

        wait;
    end process;

end architecture tb_arch;
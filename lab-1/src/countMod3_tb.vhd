library IEEE;
use IEEE.std_logic_1164.all;

entity count3_tb is
end entity count3_tb;

architecture tb_arch of count3_tb is
    constant CLK_PERIOD : time := 10 ns;
    signal clk, resetn, count_en : std_logic := '0';
    signal target_count : std_logic_vector(2 downto 0) := "101";
    signal sum : std_logic_vector(2 downto 0);
    signal cout : std_logic;
    
    component count3_limit
        port(
            clk, resetn, count_en : in std_logic;
            target_count : in std_logic_vector(2 downto 0);
            sum : out std_logic_vector(2 downto 0);
            cout : out std_logic
        );
    end component;
    
begin
    DUT: count3_limit
        port map (
            clk => clk,
            resetn => resetn,
            count_en => count_en,
            target_count => target_count,
            sum => sum,
            cout => cout
        );

    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    stimulus_process: process
    begin
        resetn <= '1';
        count_en <= '1';
        wait for 50 ns;

        count_en <= '0';
        wait for 50 ns;

        count_en <= '1';
        wait for 50 ns;

        resetn <= '0';
        wait for 50 ns;

        resetn <= '1';
        wait;
    end process stimulus_process;

end tb_arch;
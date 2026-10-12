library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg_directional_tb is
end shift_reg_directional_tb;

architecture tb_arch of shift_reg_directional_tb is
    component shift_reg_directional
        port (
            clk, rst, si, en, pl, dir : in std_logic;
            din: in std_logic_vector(3 downto 0);
            so: out std_logic
        );
    end component;

    -- Testbench signals
    signal clk_tb, rst_tb, si_tb, en_tb, pl_tb, so_tb, dir_tb: std_logic;
    signal din_tb: std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- Clock period

begin
    DUT: shift_reg_directional
        port map(
            clk => clk_tb,
            rst => rst_tb,
            si => si_tb,
            en => en_tb,
            pl => pl_tb,
            dir => dir_tb,
            din => din_tb,
            so => so_tb
        );

    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stimulus: process
    begin
        rst_tb <= '1';
        wait for CLK_PERIOD * 2;
        
        pl_tb <= '1';
        din_tb <= "0010";
        wait for CLK_PERIOD * 5;

        -- Test left shift
        pl_tb <= '0';
        en_tb <= '1';
        dir_tb <= '0';
        si_tb <= '1';
        wait for CLK_PERIOD * 5;
        
        pl_tb <= '1';
        en_tb <= '0';
        din_tb <= "1101";
        wait for CLK_PERIOD * 5;

        -- Test right shift
        pl_tb <= '0';
        en_tb <= '1';
        dir_tb <= '1';
        si_tb <= '0';
        wait for CLK_PERIOD * 5;
        
        rst_tb <= '0';
        wait;
    end process;
end tb_arch;
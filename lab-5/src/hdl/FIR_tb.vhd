library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity FIR_tb is
end FIR_tb;

architecture Behavioral of FIR_tb is
    component fir is
    port (clk, rst, valid_in : in std_logic;
          x : in std_logic_vector(7 downto 0);
          valid_out : out std_logic;
          y : out std_logic_vector(18 downto 0)
    );
    end component;

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '1';
    signal x_tb : std_logic_vector(7 downto 0) := (others => '0');
    signal y_tb : std_logic_vector(18 downto 0);
    signal valid_out_tb : std_logic;
    signal valid_in_tb: std_logic := '0';
    constant CLK_PERIOD : time := 10 ns;

begin
    DUT: fir port map (
        clk => clk_tb,
        rst => rst_tb,
        x => x_tb,
        y => y_tb,
        valid_in => valid_in_tb,
        valid_out => valid_out_tb
    );
    
    clk_process : process
    begin
        while now < 10000 ns loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    validin_process : process
    begin
        while now < 10000 ns loop
            valid_in_tb <= '1';
            wait for 1*CLK_PERIOD;
            valid_in_tb <= '0';
            wait for 7*CLK_PERIOD;
        end loop;
    end process;
   
    stim_process : process
        variable x_data : std_logic_vector(7 downto 0);
    begin
        rst_tb <= '0';
        
        x_data := std_logic_vector(to_unsigned(208,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(231,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(32,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(233,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(161,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(24,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(71,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(140,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(245,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(247,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(40,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(248,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(245,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(124,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(204,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(36,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD ;
        x_data := std_logic_vector(to_unsigned(107,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(234,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(202,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(245,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
        x_data := std_logic_vector(to_unsigned(0,8));
        x_tb <= x_data;
        wait for 8*CLK_PERIOD;
                                               
        wait;
    end process stim_process;

end Behavioral;
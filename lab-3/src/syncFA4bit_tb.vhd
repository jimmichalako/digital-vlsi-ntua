library IEEE;
use IEEE.std_logic_1164.all;

entity sync_4bit_adder_tb is
end sync_4bit_adder_tb;

architecture tb_arch of sync_4bit_adder_tb is
    component Sync_Full_Adder_4bit is
        Port ( A, B : in  std_logic_vector (3 downto 0);
               Cin : in  std_logic;
               Clock : in std_logic;
               Sum : out  std_logic_vector (3 downto 0);
               Cout : out std_logic);
    end component;

    signal a_tb : std_logic_vector(3 downto 0);
    signal b_tb : std_logic_vector(3 downto 0);
    signal sum_tb : std_logic_vector(3 downto 0);
    signal cin_tb, cout_tb, clk_tb : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    
    DUT: Sync_Full_Adder_4bit
    port map (
        A => a_tb,
        B => b_tb,
        Cin => cin_tb,
        Sum => sum_tb,
        Cout => cout_tb,
        Clock => clk_tb
    );

    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stimulus: process
    begin
            a_tb <= "0101";
            b_tb <= "0010";
            cin_tb <= '1';
            wait for CLK_PERIOD;

            a_tb <= "0111";
            b_tb <= "1010";
            cin_tb <= '1';
            wait for CLK_PERIOD;
            
            a_tb <= "1011";
            b_tb <= "0011";
            cin_tb <= '0';
            wait for CLK_PERIOD;

            a_tb <= "1100";
            b_tb <= "0100";
            cin_tb <= '1';
            wait for CLK_PERIOD;
            
            a_tb <= "1110";
            b_tb <= "0001";
            cin_tb <= '0';
            wait for CLK_PERIOD;

            a_tb <= "1101";
            b_tb <= "1000";
            cin_tb <= '0';
            wait for CLK_PERIOD;

            a_tb <= "1001";
            b_tb <= "0110";
            cin_tb <= '1';
            wait;
    end process;
end tb_arch;
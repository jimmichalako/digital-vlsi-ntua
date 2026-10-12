library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity dec8_tb is
end dec8_tb;

architecture tb_arch of dec8_tb is
    component dec8
        Port (
            enc : in  std_logic_vector(2 downto 0);
            dec : out std_logic_vector(7 downto 0)
        );
    end component;

    signal input_sig : std_logic_vector(2 downto 0);
    signal output_sig : std_logic_vector(7 downto 0);

begin
    UUT: dec8 port map (
        enc => input_sig,
        dec => output_sig
    );

    stimulus_process: process
    begin
        for i in 0 to 7 loop
            input_sig <= std_logic_vector(to_unsigned(i, input_sig'length));
            wait for 10 ns;
            assert output_sig = std_logic_vector(to_unsigned(2**i, output_sig'length))
                report "Test case failed: " & integer'image(i)
                severity error;
        end loop;
        wait;
    end process stimulus_process;
end tb_arch;
library IEEE;
use IEEE.std_logic_1164.all;

entity dec8 is
    port (
        enc : in  std_logic_vector(2 downto 0);
        dec : out std_logic_vector(7 downto 0)
    );
end dec8;

architecture behavioral of dec8 is
begin
    process(enc)
    begin
        case enc is
            when "000" =>
                dec <= "00000001";
            when "001" =>
                dec <= "00000010";
            when "010" =>
                dec <= "00000100";
            when "011" =>
                dec <= "00001000";
            when "100" =>
                dec <= "00010000";
            when "101" =>
                dec <= "00100000";
            when "110" =>
                dec <= "01000000";
            when "111" =>
                dec <= "10000000";
            when others =>
                dec <= (others => '0');
        end case;
    end process;
end behavioral;

architecture dataflow of dec8 is
begin
    dec(0) <= '1' when enc = "000" else '0';
    dec(1) <= '1' when enc = "001" else '0';
    dec(2) <= '1' when enc = "010" else '0';
    dec(3) <= '1' when enc = "011" else '0';
    dec(4) <= '1' when enc = "100" else '0';
    dec(5) <= '1' when enc = "101" else '0';
    dec(6) <= '1' when enc = "110" else '0';
    dec(7) <= '1' when enc = "111" else '0';
end dataflow;
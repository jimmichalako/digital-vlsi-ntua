library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mac is
    port (clk, mac_init : in std_logic;
          rom_out, ram_out : in std_logic_vector(7 downto 0);
          y : out std_logic_vector(18 downto 0)
    );
end mac;

architecture Behavioral of mac is

    signal result : std_logic_vector(18 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if mac_init = '1' then
                result <= (others => '0');
                result(15 downto 0) <= rom_out * ram_out;
            else
                result <= result + (rom_out * ram_out);
            end if;
        y <= result;
        end if;
    end process;

end Behavioral;
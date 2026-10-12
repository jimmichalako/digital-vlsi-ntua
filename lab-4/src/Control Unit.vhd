library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity control_unit is
    port (clk, rst, valid_in : in std_logic;
          mac_init, we, valid_out : out std_logic;
          rom_addr, ram_addr : out std_logic_vector(2 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is
    
    signal count_reg : std_logic_vector (2 downto 0) := (others => '0');
    signal temp_valid_out : std_logic_vector (9 downto 0) := (others => '0');
    
begin

    process (clk)
    begin
        if rst='1' then
            count_reg <= (others => '0');
            mac_init <= '1';
            valid_out <= '0';
        elsif rising_edge(clk) then
            if count_reg = "000" then
                we <= valid_in;
                mac_init <= '1';
                temp_valid_out(0) <= valid_in;
            else
                we <= valid_in;
                mac_init <= '0';
                temp_valid_out(0) <= valid_in;
            end if;
        rom_addr <= count_reg;
        ram_addr <= count_reg;
        count_reg <= count_reg + 1;
        valid_out <= temp_valid_out(9);
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            temp_valid_out(9 downto 1) <= temp_valid_out(8 downto 0);
        end if;
    end process;

end Behavioral;
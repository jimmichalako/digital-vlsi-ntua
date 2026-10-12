library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg_directional is
    port (
        clk, rst, si, en, pl, dir: in std_logic;
        din: in std_logic_vector(3 downto 0);
        so: out std_logic
    );
end shift_reg_directional;

architecture rtl of shift_reg_directional is
    signal dff: std_logic_vector(3 downto 0);
    begin
        edge: process (clk, rst)
        begin
            if rst = '0' then
                dff <= (others => '0');
            elsif clk'event and clk = '1' then
                if pl = '1' then
                    dff <= din;
                elsif en = '1' then
                    if dir = '1' then -- Right shift
                        dff <= si & dff(3 downto 1);
                        so <= dff(0);
                    else -- Left shift
                        dff <= dff(2 downto 0) & si;
                        so <= dff(3);
                    end if;
                end if;
            end if;
    end process;
end rtl;
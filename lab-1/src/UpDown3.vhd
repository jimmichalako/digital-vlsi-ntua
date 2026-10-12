library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count3 is 
    port( 
        clk,  
        resetn,  
        count_en, 
        count_up_en : in std_logic; 
        sum            : out std_logic_vector(2 downto 0); 
        cout           : out std_logic
    ); 
end entity count3;

architecture rtl_limit of count3 is 
    signal count : std_logic_vector(2 downto 0); 
begin 
    process(clk, resetn) 
    begin 
        if resetn = '0' then 
            count <= (others => '0'); 
        elsif clk'event and clk='1' then 
            if count_en = '1' then 
                case count_up_en is
                    when '1' =>
                        if count/=7 then
                            count <= count+1;
                        else
                            count <= (others => '0');
                            cout <= '1';
                        end if;
                    when '0' =>
                        if (count/=0) then
                            count <= count-1;
                        else
                            count <= (others => '1');
                            cout <= '0';
                        end if;
                    when others =>
                        count <= (others => 'X');
                end case;
            end if;
        end if;
    end process; 
    sum  <= count; 
end architecture rtl_limit;
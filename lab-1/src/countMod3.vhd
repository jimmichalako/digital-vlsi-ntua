library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count3_limit is 
    port(
        clk,resetn,count_en : in std_logic;
        target_count : in std_logic_vector(2 downto 0);
        sum : out std_logic_vector(2 downto 0);
        cout : out std_logic
    ); 
end entity count3_limit; 

architecture rtl_limit of count3_limit is 
    signal count : std_logic_vector(2 downto 0); 
begin 
    process(clk, resetn) 
    begin 
        if resetn = '0' then 
            count <= (others => '0'); 
        elsif clk'event and clk = '1' then 
            if count_en = '1' then 
                if count/= target_count then
                    count <= count + 1; 
                else 
                    count <= (others => '0');
                    cout <= '1';
                end if; 
            end if; 
        end if; 
    end process; 
    sum <= count;
end rtl_limit;
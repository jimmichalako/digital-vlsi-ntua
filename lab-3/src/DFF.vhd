library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
    port (
      D  : in  std_logic;
      Clk : in  std_logic;
      Q  : out  std_logic
    );
end DFF;

architecture behavioral of DFF is
    begin
      process(Clk)
      begin
        if Clk'event and Clk='1' then
          Q <= D;
        end if;
      end process;  
end behavioral;
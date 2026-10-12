library IEEE;
use IEEE.std_logic_1164.all;

entity sync_full_adder is
    Port ( A, B, Cin, Clk : in  std_logic;
           Sum, Cout : out  std_logic);
end sync_full_adder;

architecture behavioral of sync_full_adder is
    signal wire : std_logic_vector (2 downto 0);
    begin
    wire(2) <= A;
    wire(1) <= B;
    wire(0) <= Cin;
    
    process (wire, Clk)
    begin
        if Clk'event and Clk='1' then
            if (wire = "001" or wire = "010" or wire = "100" or wire = "111") then 
            Sum <= '1';
            else
            Sum <= '0';
            end if;

            if (wire = "011" or wire = "101" or wire = "110" or wire = "111") then 
            Cout <= '1';
            else 
            Cout <= '0';
            end if;
        end if ;
    end process;
end behavioral;
library IEEE;
use IEEE.std_logic_1164.all;

entity half_adder is
    Port ( A, B : in  std_logic;
           Sum, Carry : out  std_logic);
end half_adder;

architecture dataflow of half_adder is
begin
    Sum <= A xor B;
    Carry <= A and B;
end dataflow;
library IEEE;
use IEEE.std_logic_1164.all;

entity Sync_Full_Adder_4bit is
    Port ( A, B : in  std_logic_vector (3 downto 0);
           Cin : in  std_logic;
           Clock : in std_logic;
           Sum : out  std_logic_vector (3 downto 0);
           Cout : out std_logic);
end Sync_Full_Adder_4bit;

architecture Pipeline of Sync_Full_Adder_4bit is

    component sync_full_adder
        Port ( A, B, Cin, Clk : in  std_logic;
               Sum, Cout : out  std_logic);
    end component;

    component DFF
        Port ( D, Clk : in std_logic;
               Q : out std_logic);
    end component;

    signal a1, b1, s2: std_logic;
    signal a2, b2, s1: std_logic_vector (1 downto 0);
    signal a3, b3, s0, c : std_logic_vector(2 downto 0);

begin
    --STAGE 0
    FA0: sync_full_adder port map (A(0), B(0), Cin, Clock, s0(0), c(0));
    D0a1: DFF port map (A(1), Clock, a1);
    D0b1: DFF port map (B(1), Clock, b1);
    D0a2: DFF port map (A(2), Clock, a2(0));
    D0b2: DFF port map (B(2), Clock, b2(0));
    D0a3: DFF port map (A(3), Clock, a3(0));
    D0b3: DFF port map (B(3), Clock, b3(0));

    --STAGE 1
    D1s0: DFF port map (s0(0), Clock, s0(1));
    FA1: sync_full_adder port map (a1, b1, c(0), Clock, s1(0), c(1));
    D1a2: DFF port map (a2(0), Clock, a2(1));
    D1b2: DFF port map (b2(0), Clock, b2(1));
    D1a3: DFF port map (a3(0), Clock, a3(1));
    D1b3: DFF port map (b3(0), Clock, b3(1));

    --STAGE 2
    D2s0: DFF port map (s0(1), Clock, s0(2));
    D2s1: DFF port map (s1(0), Clock, s1(1));
    FA2: sync_full_adder port map (a2(1), b2(1), c(1), Clock, s2, c(2));
    D2a3: DFF port map (a3(1), Clock, a3(2));
    D2b3: DFF port map (b3(1), Clock, b3(2));

    --STAGE 3
    D3s0: DFF port map (s0(2), Clock, Sum(0));
    D3s1: DFF port map (s1(1), Clock, Sum(1));
    D3s2: DFF port map (s2, Clock, Sum(2));
    FA3: sync_full_adder port map (a3(2), b3(2), c(2), Clock, Sum(3), Cout);
end Pipeline;
library IEEE;
use IEEE.std_logic_1164.all;

entity Sync_Mult_4bit is
    port (A, B : in std_logic_vector(3 downto 0);
          Clk : in std_logic;
          Product : out std_logic_vector(7 downto 0));
end entity;

architecture Systolic of Sync_Mult_4bit is

    component DFF is
    port (D, Clk : in std_logic;
          Q : out std_logic);
    end component;

    component mac is 
    port (A, B, S_in, Cin, Clk : in std_logic;
          Sum, Cout : out std_logic);
    end component;
    
    signal s00 : std_logic;
    signal c00 : std_logic;
    signal A0, B0 : std_logic_vector(3 downto 0);

    signal s01 : std_logic;
    signal c01 : std_logic;
    signal A1, B1 : std_logic_vector(3 downto 0);
    signal p1 : std_logic;

    signal s02, s10 : std_logic;
    signal c02, c10 : std_logic;
    signal A2, B2 : std_logic_vector(3 downto 0);
    signal p2 : std_logic_vector(1 downto 0);

    signal s03, s11 : std_logic;
    signal c03, c11 : std_logic;
    signal c03_delayed : std_logic;
    signal A3 : std_logic_vector(3 downto 0);
    signal B3 : std_logic_vector(3 downto 1);
    signal p3 : std_logic_vector(1 downto 0);

    signal s12, s20 : std_logic;
    signal c12, c20 : std_logic;
    signal A4 : std_logic_vector(3 downto 0);
    signal B4 : std_logic_vector(3 downto 1);
    signal p4 : std_logic_vector(2 downto 0);

    signal s13, s21 : std_logic;
    signal c13, c21 : std_logic;
    signal c13_delayed : std_logic;
    signal A5 : std_logic_vector(3 downto 0);
    signal B5 : std_logic_vector(3 downto 2);
    signal p5 : std_logic_vector(2 downto 0);

    signal s22, s30 : std_logic;
    signal c22, c30 : std_logic;
    signal A6 : std_logic_vector(3 downto 1);
    signal B6 : std_logic_vector(3 downto 2);
    signal p6 : std_logic_vector(3 downto 0);

    signal s23, s31 : std_logic;
    signal c23, c31 : std_logic;
    signal c23_delayed : std_logic;
    signal A7 : std_logic_vector(3 downto 2);
    signal B7 : std_logic_vector(3 downto 3);
    signal p7 : std_logic_vector(4 downto 0);

    signal s32 : std_logic;
    signal c32 : std_logic;
    signal A8, B8 : std_logic_vector(3 downto 3);
    signal p8 : std_logic_vector(5 downto 0);

begin
    --STAGE 0
    MAC00: mac port map (A(0), B(0), '0', '0', Clk, s00, c00);
    D0a0: DFF port map (A(0), Clk, A0(0));
    D0a1: DFF port map (A(1), Clk, A0(1));
    D0a2: DFF port map (A(2), Clk, A0(2));
    D0a3: DFF port map (A(3), Clk, A0(3));
    D0b0: DFF port map (B(0), Clk, B0(0));
    D0b1: DFF port map (B(1), Clk, B0(1));
    D0b2: DFF port map (B(2), Clk, B0(2));
    D0b3: DFF port map (B(3), Clk, B0(3));

    --STAGE 1
    MAC01: mac port map (A0(1), B0(0), '0', c00, Clk, s01, c01);
    D1a0: DFF port map (A0(0), Clk, A1(0));
    D1a1: DFF port map (A0(1), Clk, A1(1));
    D1a2: DFF port map (A0(2), Clk, A1(2));
    D1a3: DFF port map (A0(3), Clk, A1(3));
    D1b0: DFF port map (B0(0), Clk, B1(0));
    D1b1: DFF port map (B0(1), Clk, B1(1));
    D1b2: DFF port map (B0(2), Clk, B1(2));
    D1b3: DFF port map (B0(3), Clk, B1(3));
    D1p0: DFF port map (s00, Clk, p1);

    --STAGE 2
    MAC02: mac port map (A1(2), B1(0), '0', c01, Clk, s02, c02);
    MAC10: mac port map (A1(0), B1(1), s01, '0', Clk, s10, c10);
    D2a0: DFF port map (A1(0), Clk, A2(0));
    D2a1: DFF port map (A1(1), Clk, A2(1));
    D2a2: DFF port map (A1(2), Clk, A2(2));
    D2a3: DFF port map (A1(3), Clk, A2(3));
    D2b0: DFF port map (B1(0), Clk, B2(0));
    D2b1: DFF port map (B1(1), Clk, B2(1));
    D2b2: DFF port map (B1(2), Clk, B2(2));
    D2b3: DFF port map (B1(3), Clk, B2(3));
    D2p0: DFF port map (p1, Clk, p2(0));
    D2p1: DFF port map (s10, Clk, p2(1));

    --STAGE 3
    MAC03: mac port map (A2(3), B2(0), '0', c02, Clk, s03, c03);
    MAC11: mac port map (A2(1), B2(1), s02, c10, Clk, s11, c11);
    D3a0: DFF port map (A2(0), Clk, A3(0));
    D3a1: DFF port map (A2(1), Clk, A3(1));
    D3a2: DFF port map (A2(2), Clk, A3(2));
    D3a3: DFF port map (A2(3), Clk, A3(3));
    D3b1: DFF port map (B2(1), Clk, B3(1));
    D3b2: DFF port map (B2(2), Clk, B3(2));
    D3b3: DFF port map (B2(3), Clk, B3(3));
    D3p0: DFF port map (p2(0), Clk, p3(0));
    D3p1: DFF port map (p2(1), Clk, p3(1));
    D3c03: DFF port map (c03, Clk, c03_delayed);

    --STAGE 4
    MAC12: mac port map (A3(2), B3(1), s03, c11, Clk, s12, c12);
    MAC20: mac port map (A3(0), B3(2), s11, '0', Clk, s20, c20);
    D4a0: DFF port map (A3(0), Clk, A4(0));
    D4a1: DFF port map (A3(1), Clk, A4(1));
    D4a2: DFF port map (A3(2), Clk, A4(2));
    D4a3: DFF port map (A3(3), Clk, A4(3));
    D4b1: DFF port map (B3(1), Clk, B4(1));
    D4b2: DFF port map (B3(2), Clk, B4(2));
    D4b3: DFF port map (B3(3), Clk, B4(3));
    D4p0: DFF port map (p3(0), Clk, p4(0));
    D4p1: DFF port map (p3(1), Clk, p4(1));
    D4p2: DFF port map (s20, Clk, p4(2));

    --STAGE 5
    MAC13: mac port map (A4(3), B4(1), c03_delayed, c12, Clk, s13, c13);
    MAC21: mac port map (A4(1), B4(2), s12, c20, Clk, s21, c21);
    D5a0: DFF port map (A4(0), Clk, A5(0));
    D5a1: DFF port map (A4(1), Clk, A5(1));
    D5a2: DFF port map (A4(2), Clk, A5(2));
    D5a3: DFF port map (A4(3), Clk, A5(3));
    D5b2: DFF port map (B4(2), Clk, B5(2));
    D5b3: DFF port map (B4(3), Clk, B5(3));
    D5p0: DFF port map (p4(0), Clk, p5(0));
    D5p1: DFF port map (p4(1), Clk, p5(1));
    D5p2: DFF port map (p4(2), Clk, p5(2));
    D5c13: DFF port map (c13, Clk, c13_delayed);

    --STAGE 6
    MAC22: mac port map (A5(2), B5(2), s13, c21, Clk, s22, c22);
    MAC30: mac port map (A5(0), B5(3), s21, '0', Clk, s30, c30);
    D6a1: DFF port map (A5(1), Clk, A6(1));
    D6a2: DFF port map (A5(2), Clk, A6(2));
    D6a3: DFF port map (A5(3), Clk, A6(3));
    D6b2: DFF port map (B5(2), Clk, B6(2));
    D6b3: DFF port map (B5(3), Clk, B6(3));
    D6p0: DFF port map (p5(0), Clk, p6(0));
    D6p1: DFF port map (p5(1), Clk, p6(1));
    D6p2: DFF port map (p5(2), Clk, p6(2));
    D6p3: DFF port map (s30, Clk, p6(3));

    --STAGE 7
    MAC23: mac port map (A6(3), B6(2), c13_delayed, c22, Clk, s23, c23);
    MAC31: mac port map (A6(1), B6(3), s22, c30, Clk, s31, c31);
    D7a2: DFF port map (A6(2), Clk, A7(2));
    D7a3: DFF port map (A6(3), Clk, A7(3));
    D7b3: DFF port map (B6(3), Clk, B7(3));
    D7p0: DFF port map (p6(0), Clk, p7(0));
    D7p1: DFF port map (p6(1), Clk, p7(1));
    D7p2: DFF port map (p6(2), Clk, p7(2));
    D7p3: DFF port map (p6(3), Clk, p7(3));
    D7p4: DFF port map (s31, Clk, p7(4));
    D7c23: DFF port map (c23, Clk, c23_delayed);

    --STAGE 8
    MAC32: mac port map (A7(2), B7(3), s23, c31, Clk, s32, c32);
    D8a3: DFF port map (A7(3), Clk, A8(3));
    D8b3: DFF port map (B7(3), Clk, B8(3));
    D8p0: DFF port map (p7(0), Clk, p8(0));
    D8p1: DFF port map (p7(1), Clk, p8(1));
    D8p2: DFF port map (p7(2), Clk, p8(2));
    D8p3: DFF port map (p7(3), Clk, p8(3));
    D8p4: DFF port map (p7(4), Clk, p8(4));
    D8p5: DFF port map (s32, Clk, p8(5));

    --STAGE 9
    MAC33: mac port map (A8(3), B8(3), c23_delayed, c32, Clk, Product(6), Product(7));
    Product(0) <= p8(0);
    Product(1) <= p8(1);
    Product(2) <= p8(2);
    Product(3) <= p8(3);
    Product(4) <= p8(4);
    Product(5) <= p8(5);
end Systolic;
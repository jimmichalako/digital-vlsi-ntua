LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY DEBAYERING IS
    GENERIC (N : INTEGER := 1024);
    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        valid_in : IN STD_LOGIC;
        pixel : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        new_image : IN STD_LOGIC;
        R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        G : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        valid_out : OUT STD_LOGIC;
        image_finished : OUT STD_LOGIC
    );
END DEBAYERING;

ARCHITECTURE Behavioral OF DEBAYERING IS

    COMPONENT s2p
        GENERIC (N : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            pixel : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_pxl : IN STD_LOGIC;
            s00 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s01 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s02 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s10 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s11 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s12 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s20 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s21 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            s22 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT COMPUTE_UNIT
        GENERIC (N : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            s00 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s01 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s02 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s10 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s11 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s12 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s20 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s21 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            s22 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            lline : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0);
            column : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            G : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT CONTROL
        GENERIC (N : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            valid_in : IN STD_LOGIC;
            new_image : IN STD_LOGIC;
            start : IN STD_LOGIC;
            lline : OUT STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0);
            column : OUT STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0);
            valid_out : OUT STD_LOGIC;
            image_finished : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL clk_gate : STD_LOGIC;
    SIGNAL ss00, ss01, ss02, ss10, ss11, ss12, ss20, ss21, ss22 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL lin, col : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL start : STD_LOGIC;
    SIGNAL valid_out1 : STD_LOGIC;

BEGIN

    CTRL : CONTROL
    GENERIC MAP(N => N)
    PORT MAP(
        clk => clk_gate,
        rst_n => rst_n,
        valid_in => valid_in,
        new_image => new_image,
        start => start,
        lline => lin,
        column => col,
        valid_out => valid_out1,
        image_finished => image_finished
    );

    CU : COMPUTE_UNIT
    GENERIC MAP(N => N)
    PORT MAP(
        clk => clk_gate,
        rst_n => rst_n,
        s00 => ss00,
        s01 => ss01,
        s02 => ss02,
        s10 => ss10,
        s11 => ss11,
        s12 => ss12,
        s20 => ss20,
        s21 => ss21,
        s22 => ss22,
        lline => lin,
        column => col,
        R => R,
        G => G,
        B => B
    );

    S_2_P : S2P
    GENERIC MAP(N => N)
    PORT MAP(
        clk => clk_gate,
        rst_n => rst_n,
        pixel => pixel,
        valid_pxl => '1',
        s00 => ss00,
        s01 => ss01,
        s02 => ss02,
        s10 => ss10,
        s11 => ss11,
        s12 => ss12,
        s20 => ss20,
        s21 => ss21,
        s22 => ss22,
        valid_out => start
    );

    valid_out <= valid_out1 AND valid_in;
    clk_gate <= (clk AND valid_in);

END Behavioral;
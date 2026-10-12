LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY COMPUTE_UNIT IS
    GENERIC (N : INTEGER := 1024);
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
END COMPUTE_UNIT;

ARCHITECTURE Behavioral OF COMPUTE_UNIT IS

    SIGNAL downright, downleft, upright, upleft, right, left, center, up, down : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL validout : STD_LOGIC;
    SIGNAL w0, w1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL w2, w3 : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL up_down : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL left_right : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL corners : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL cross : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    w0 <= ("00" & left) + ("00" & right) + ("00" & up) + ("00" & down);
    w1 <= ("00" & upleft) + ("00" & upright) + ("00" & downleft) + ("00" & downright);
    w2 <= ('0' & up) + ('0' & down);
    w3 <= ('0' & left) + ('0' & right);
    cross <= w0(9 DOWNTO 2);
    corners <= w1(9 DOWNTO 2);
    up_down <= w2(8 DOWNTO 1);
    left_right <= w3(8 DOWNTO 1);
    upleft <= s22 WHEN to_integer(unsigned(lline)) /= 0 AND to_integer(unsigned(column)) /= 0 ELSE (OTHERS => '0');
    up <= s21 WHEN to_integer(unsigned(lline)) /= 0 ELSE (OTHERS => '0');
    upright <= s20 WHEN to_integer(unsigned(lline)) /= 0 AND to_integer(unsigned(column)) /= N - 1 ELSE (OTHERS => '0');
    left <= s12 WHEN to_integer(unsigned(column)) /= 0 ELSE (OTHERS => '0');
    center <= s11;
    right <= s10 WHEN to_integer(unsigned(column)) /= N - 1 ELSE (OTHERS => '0');
    downleft <= s02 WHEN to_integer(unsigned(lline)) /= N - 1 AND to_integer(unsigned(column)) /= 0 ELSE (OTHERS => '0');
    down <= s01 WHEN to_integer(unsigned(lline)) /= N - 1 ELSE (OTHERS => '0');
    downright <= s00 WHEN to_integer(unsigned(lline)) /= N - 1 AND to_integer(unsigned(column)) /= N - 1 ELSE (OTHERS => '0');

    PROCESS (clk, rst_n)
    BEGIN
        IF rising_edge(clk) THEN
            IF lline(0) = '0' THEN
                IF column(0) = '0' THEN --green
                    R <= up_down;
                    G <= center;
                    B <= left_right;
                ELSE --blue
                    R <= corners;
                    G <= cross;
                    B <= center;
                END IF;
            ELSE
                IF column(0) = '0' THEN --red
                    R <= center;
                    G <= cross;
                    B <= corners;
                ELSE --green
                    R <= left_right;
                    G <= center;
                    B <= up_down;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY CONTROL IS
    GENERIC (
        N : INTEGER := 1024
    );
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
END CONTROL;

ARCHITECTURE Behavioral OF CONTROL IS

    SIGNAL ColReg, LineReg : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN

    column <= ColReg;
    lline <= LineReg;

    PROCESS (clk, rst_n)
    BEGIN
        IF rst_n(0) = '1' THEN
            LineReg <= (OTHERS => '0');
            ColReg <= (OTHERS => '0');
            valid_out <= '0';
        ELSIF rising_edge(clk) THEN
            valid_out <= '0';
            IF (start = '1') THEN
                valid_out <= '1';
                ColReg <= ColReg + 1;
                IF to_integer(unsigned(ColReg)) = N - 1 THEN
                    LineReg <= LineReg + 1;
                END IF;
            END IF;
            IF (to_integer(unsigned(LineReg)) = N - 1 AND to_integer(unsigned(ColReg)) = N - 1) THEN
                image_finished <= '1';
            ELSE
                image_finished <= '0';
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
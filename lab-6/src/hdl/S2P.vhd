LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY S2P IS
    GENERIC (N : INTEGER := 1024);
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
END S2P;

ARCHITECTURE Behavioral OF s2p IS
    COMPONENT fifo_generator_0
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC;
            valid : OUT STD_LOGIC;
            data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;

    TYPE arr IS ARRAY (2 DOWNTO 0) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL L0, L1, L2 : arr := (OTHERS => (OTHERS => '0'));
    SIGNAL counter : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N * N)))) DOWNTO 0) := (OTHERS => '0');
    SIGNAL out0, out1, out2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd_en0, rd_en1, rd_en2 : STD_LOGIC := '0';
    SIGNAL full0, full1, full2, empty0, empty1, empty2, valid0, valid1, valid2 : STD_LOGIC;
    SIGNAL data_count0, data_count1, data_count2 : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
    RAM_FIFO_0 : fifo_generator_0
    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        din => pixel,
        wr_en => '1',
        rd_en => rd_en0,
        dout => out0,
        full => full0,
        empty => empty0,
        valid => valid0,
        data_count => data_count0
    );
    RAM_FIFO_1 : fifo_generator_0
    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        din => out0,
        wr_en => '1',
        rd_en => rd_en1,
        dout => out1,
        full => full1,
        empty => empty1,
        valid => valid1,
        data_count => data_count1
    );
    RAM_FIFO_2 : fifo_generator_0
    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        din => out1,
        wr_en => '1',
        rd_en => rd_en2,
        dout => out2,
        full => full2,
        empty => empty2,
        valid => valid2,
        data_count => data_count2
    );

    PROCESS (clk, rst_n)
    BEGIN
        IF rst_n(0) = '1' THEN
            rd_en0 <= '0';
            rd_en1 <= '0';
            rd_en2 <= '0';
            valid_out <= '0';
            counter <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF valid_pxl = '1' THEN
                counter <= counter + 1;
                IF to_integer(unsigned(counter)) = 2 * N + 3 THEN
                    valid_out <= '1';
                END IF;
                IF to_integer(unsigned(data_count0)) = N - 2 THEN
                    rd_en0 <= '1';
                    rd_en1 <= '1';
                    rd_en2 <= '1';
                END IF;
                L0 <= L0(1 DOWNTO 0) & out0;
                L1 <= L1(1 DOWNTO 0) & out1;
                L2 <= L2(1 DOWNTO 0) & out2;
                s00 <= L0(0);s01 <= L0(1);s02 <= L0(2);
                s10 <= L1(0);s11 <= L1(1);s12 <= L1(2);
                s20 <= L2(0);s21 <= L2(1);s22 <= L2(2);
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
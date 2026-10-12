LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;

ENTITY DEBAYERING_tb IS
END DEBAYERING_tb;

ARCHITECTURE tb_arch OF DEBAYERING_tb IS
    CONSTANT N : INTEGER := 32;

    COMPONENT DEBAYERING
        GENERIC (N : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            new_image : IN STD_LOGIC;
            valid_in : IN STD_LOGIC;
            pixel : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            G : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_out : OUT STD_LOGIC;
            image_finished : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst_n : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
    SIGNAL new_image : STD_LOGIC := '0';
    SIGNAL valid_in : STD_LOGIC := '0';
    SIGNAL pixel : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL enable : STD_LOGIC := '0';
    SIGNAL R, G, B : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL valid_out : STD_LOGIC;
    SIGNAL image_finished : STD_LOGIC;
    CONSTANT CLK_PERIOD : TIME := 1ns;

BEGIN
    UUT : DEBAYERING
    GENERIC MAP(N => N)
    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        new_image => new_image,
        valid_in => valid_in,
        pixel => pixel,
        R => R,
        G => G,
        B => B,
        valid_out => valid_out,
        image_finished => image_finished
    );

    clk_proc : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD / 2;
        clk <= '1';
        WAIT FOR CLK_PERIOD / 2;
    END PROCESS;

    init : PROCESS
    BEGIN
        WAIT FOR clk_period/2;
        rst_n <= "0";
        enable <= '1';
        valid_in <= '1';
        WAIT FOR 1048576 * clk_period;
        valid_in <= '0';
        WAIT FOR 10 * clk_period;
        WAIT FOR 2 * clk_period;
        WAIT;
    END PROCESS;

    read_proc : PROCESS (clk, rst_n)
        FILE input_file : text OPEN read_mode IS "C:\Users\Dimitris\Desktop\read.txt";
        VARIABLE row_read : line;
        VARIABLE pixel_read : INTEGER;
        VARIABLE pixel_row_counter : INTEGER := 0;
        FILE output_file : text OPEN write_mode IS "C:\Users\Dimitris\Desktop\write.txt";
        VARIABLE row_write : line;

    BEGIN
        IF (rst_n = "1") THEN
            pixel_row_counter := 0;
            pixel_read := - 1;
        ELSIF (rising_edge(clk)) THEN
            IF (enable = '1') THEN
                IF (NOT endfile(input_file)) THEN
                    IF (pixel_row_counter = 0) THEN
                        new_image <= '1';
                    ELSE
                        IF (pixel_row_counter = N * N - 1) THEN
                            pixel_row_counter := - 1;
                        END IF;
                        new_image <= '0';
                    END IF;
                    pixel_row_counter := pixel_row_counter + 1;
                    readline(input_file, row_read);
                END IF;
                read(row_read, pixel_read);
                pixel <= STD_LOGIC_VECTOR(to_unsigned(pixel_read, 8));
            END IF;
            IF (valid_out = '1') THEN
                write(row_write, to_integer(unsigned(R)), left, 4);
                write(row_write, to_integer(unsigned(G)), left, 4);
                write(row_write, to_integer(unsigned(B)), left, 4);
                writeline(output_file, row_write);
            END IF;
            IF (image_finished = '1' AND valid_out = '1') THEN
                write(row_write, STRING'("<Image Finished>"));
                writeline(output_file, row_write);
            END IF;
        END IF;
    END PROCESS;

END tb_arch;
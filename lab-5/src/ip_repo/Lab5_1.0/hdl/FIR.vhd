library IEEE;
use IEEE.std_logic_1164.all;

entity dff is
    port (clk, rst, d : in std_logic;
          q : out std_logic
    );
end dff;

architecture Behavioral of dff is
begin

    process (clk, rst)
    begin
        if rst = '1' then
            q <= '0';
        elsif clk'event and clk = '1' then
            q <= d;
        end if;
    end process;

end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity mlab_rom is
	generic (
		coeff_width : integer :=8  				--- width of coefficients (bits)
	);
    Port ( clk : in  std_logic;
		   en : in  std_logic;				--- operation enable
           addr : in  std_logic_vector (2 downto 0);			-- memory address
           rom_out : out  std_logic_vector (coeff_width-1 downto 0));	-- output data
end mlab_rom;

architecture Behavioral of mlab_rom is

    type rom_type is array (7 downto 0) of std_logic_vector (coeff_width-1 downto 0);                 
    signal rom : rom_type:= ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
                             "00000001");      				 -- initialization of rom with user data                 

    signal rdata : std_logic_vector(coeff_width-1 downto 0) := (others => '0');
begin

    rdata <= rom(conv_integer(addr));

    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (en = '1') then
                rom_out <= rdata;
            end if;
        end if;
    end process;			

end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mlab_ram is
	 generic (
		data_width : integer :=8  				--- width of data (bits)
	 );
    port (clk  : in std_logic;
          rst  : in std_logic;
          we   : in std_logic;						--- memory write enable
		  en   : in std_logic;				--- operation enable
          addr : in std_logic_vector(2 downto 0);			-- memory address
          di   : in std_logic_vector(data_width-1 downto 0);		-- input data
          do   : out std_logic_vector(data_width-1 downto 0));		-- output data
end mlab_ram;

architecture Behavioral of mlab_ram is

    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
	 
begin

    process (clk)
    begin
        if rst = '1' then
            RAM <= (others => (others => '0'));
        elsif clk'event and clk = '1' then
            if en = '1' then
                if we = '1' then				-- write operation
                    for i in 0 to 6 loop
                        RAM(7-i) <= RAM(6-i);
                    end loop;                
                    RAM(0) <= di; 
                    do <= di;
                else						-- read operation
                    do <= RAM(conv_integer(addr));
                end if;
            end if;
        end if;
    end process;

end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity control_unit is
    port (clk, rst, valid_in : in std_logic;
          mac_init, we, valid_out : out std_logic;
          rom_addr, ram_addr : out std_logic_vector(2 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is

    component dff is
        port (clk, rst, d : in std_logic;
              q : out std_logic
        );
    end component;
    
    signal calculate : std_logic := '0';
    signal valid_out_temp, flag, w1, w2, w3, w4, w5, w6, w7 : std_logic;
    signal count_reg : std_logic_vector (2 downto 0) := (others => '1');
    
begin

    process (clk)
    begin
        if rst='1' then
            count_reg <= (others => '0');
            mac_init <= '1';
            valid_out_temp <= '0';
        elsif clk'event and clk = '1' then
            if (valid_in = '1') and (calculate = '0') then
                flag <= '1';
            end if;
            if count_reg = "000" then
                mac_init <= '1';
                if calculate = '1' then
                    valid_out_temp <= '1';
                else
                    valid_out_temp <= '0';
                end if;
                if valid_in = '0' then
                    we <= '0';
                    calculate <= '0';
                else
                    we <= '1';
                    calculate <= '1';
                end if;
            else
                we <= '0';
                valid_out_temp <= '0';
                mac_init <= '0';
            end if;
            if count_reg = "111" then
                flag <= '0';
            end if;
            if flag = '1' then
                count_reg <= count_reg + 1;
            else 
                count_reg <= "000";
            end if;
            rom_addr <= count_reg;
            ram_addr <= count_reg;
        end if;
    end process;

    DFF1: dff port map (clk=>clk, rst=>rst, d=>valid_out_temp, q=>w1);
    DFF2: dff port map (clk=>clk, rst=>rst, d=>w1, q=>w2);
    DFF3: dff port map (clk=>clk, rst=>rst, d=>w2, q=>w3);
    DFF4: dff port map (clk=>clk, rst=>rst, d=>w3, q=>w4);
    DFF5: dff port map (clk=>clk, rst=>rst, d=>w4, q=>w5);
    DFF6: dff port map (clk=>clk, rst=>rst, d=>w5, q=>w6);
    DFF7: dff port map (clk=>clk, rst=>rst, d=>w6, q=>w7);
    DFF8: dff port map (clk=>clk, rst=>rst, d=>w7, q=>valid_out);

end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mac is
    port (clk, rst, mac_init : in std_logic;
          rom_out, ram_out : in std_logic_vector(7 downto 0);
          y : out std_logic_vector(18 downto 0)
    );
end mac;

architecture Behavioral of mac is

    signal result : std_logic_vector(18 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rst = '1' then
            result <= (others => '0');
        elsif clk'event and clk = '1' then
            if mac_init = '1' then
                result <= (others => '0');
                result(15 downto 0) <= rom_out * ram_out;
            else
                result <= result + (rom_out * ram_out);
            end if;
        y <= result;
        end if;
    end process;

end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fir is
    port (clk, rst, valid_in : in std_logic;
          x : in std_logic_vector(7 downto 0);
          valid_out : out std_logic;
          y : out std_logic_vector(18 downto 0)
    );
end fir;

architecture Structural of fir is

    component control_unit is
        port (clk, rst, valid_in : in std_logic;
              mac_init, we, valid_out : out std_logic;
              rom_addr, ram_addr : out std_logic_vector(2 downto 0)
        );
    end component;

    component mac is
        port (clk, rst, mac_init : in std_logic;
              rom_out, ram_out : in std_logic_vector(7 downto 0);
              y : out std_logic_vector(18 downto 0)
        );
    end component;

    component mlab_rom is
        generic (
           coeff_width : integer :=8
        );
        port ( clk : in  std_logic;
              en : in  std_logic;
              addr : in  std_logic_vector (2 downto 0);
              rom_out : out  std_logic_vector (coeff_width-1 downto 0));
    end component;
    
    component mlab_ram is
        generic (
           data_width : integer :=8
        );
        port (clk  : in std_logic;
             rst  : in std_logic;
             we   : in std_logic;
             en   : in std_logic;
             addr : in std_logic_vector(2 downto 0);
             di   : in std_logic_vector(data_width-1 downto 0);
             do   : out std_logic_vector(data_width-1 downto 0));
    end component;

    component dff is
        port (clk, rst, d : in std_logic;
              q : out std_logic
        );
    end component;
    
    signal mac_init_sig, mac_init_reg, we_sig, valid_out_sig, valid_out_reg : std_logic;
    signal rom_addr_sig, ram_addr_sig : std_logic_vector(2 downto 0);
    signal x_reg, rom_out_sig, ram_out_sig : std_logic_vector(7 downto 0);

begin

    DFFx0: dff port map (clk=>clk, rst=>rst, d=>x(0), q=>x_reg(0));
    DFFx1: dff port map (clk=>clk, rst=>rst, d=>x(1), q=>x_reg(1));
    DFFx2: dff port map (clk=>clk, rst=>rst, d=>x(2), q=>x_reg(2));
    DFFx3: dff port map (clk=>clk, rst=>rst, d=>x(3), q=>x_reg(3));
    DFFx4: dff port map (clk=>clk, rst=>rst, d=>x(4), q=>x_reg(4));
    DFFx5: dff port map (clk=>clk, rst=>rst, d=>x(5), q=>x_reg(5));
    DFFx6: dff port map (clk=>clk, rst=>rst, d=>x(6), q=>x_reg(6));
    DFFx7: dff port map (clk=>clk, rst=>rst, d=>x(7), q=>x_reg(7));
    ControlUnit: control_unit port map (clk=>clk, rst=>rst, valid_in=>valid_in, mac_init=>mac_init_sig, we=>we_sig, valid_out=>valid_out_sig, rom_addr=>rom_addr_sig, ram_addr=>ram_addr_sig);
    DFFmac_init: dff port map (clk=>clk, rst=>rst, d=>mac_init_sig, q=>mac_init_reg);
    ROM: mlab_rom port map (clk=>clk, en=>'1', addr=>rom_addr_sig, rom_out=>rom_out_sig);
    RAM: mlab_ram port map (clk=>clk, rst=>rst, en=>'1', we=>we_sig, addr=>ram_addr_sig, di=>x_reg, do=>ram_out_sig);
    MAC0: mac port map (clk=>clk, rst=>rst, rom_out=>rom_out_sig, ram_out=>ram_out_sig, mac_init=>mac_init_reg, y=>y);
    DFFvalid_out0: dff port map (clk=>clk, rst=>rst, d=>valid_out_sig, q=>valid_out_reg);
    DFFvalid_out1: dff port map (clk=>clk, rst=>rst, d=>valid_out_reg, q=>valid_out);

end Structural;
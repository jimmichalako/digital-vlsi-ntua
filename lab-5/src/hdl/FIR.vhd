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
    
    signal count_reg : std_logic_vector (2 downto 0) := (others => '0');
    signal temp_valid_out : std_logic_vector (9 downto 0) := (others => '0');
    
begin

    process (clk)
    begin
        if rst='1' then
            count_reg <= (others => '0');
            mac_init <= '1';
            valid_out <= '0';
        elsif rising_edge(clk) then
            if count_reg = "000" then
                we <= valid_in;
                mac_init <= '1';
                temp_valid_out(0) <= valid_in;
            else
                we <= valid_in;
                mac_init <= '0';
                temp_valid_out(0) <= valid_in;
            end if;
        rom_addr <= count_reg;
        ram_addr <= count_reg;
        count_reg <= count_reg + 1;
        valid_out <= temp_valid_out(9);
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            temp_valid_out(9 downto 1) <= temp_valid_out(8 downto 0);
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
          we   : in std_logic;						                --- memory write enable
		  en   : in std_logic;				                        --- operation enable
          addr : in std_logic_vector(2 downto 0);			        -- memory address
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
                    RAM(7 downto 1) <= RAM(6 downto 0);                
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

entity mac is
    port (clk, mac_init : in std_logic;
          rom_out, ram_out : in std_logic_vector(7 downto 0);
          y : out std_logic_vector(18 downto 0)
    );
end mac;

architecture Behavioral of mac is

    signal result : std_logic_vector(18 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
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
        port (clk, mac_init : in std_logic;
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
    
    signal mac_init, mac_init_reg, we : std_logic;
    signal rom_addr, ram_addr : std_logic_vector(2 downto 0);
    signal x_reg, rom_out, ram_out : std_logic_vector(7 downto 0);

begin
    CU: control_unit port map (clk=>clk, rst=>rst, valid_in=>valid_in, mac_init=>mac_init, we=>we, valid_out=>valid_out, rom_addr=>rom_addr, ram_addr=>ram_addr);
    ROM: mlab_rom port map (clk=>clk, en=>'1', addr=>rom_addr, rom_out=>rom_out);
    RAM: mlab_ram port map (clk=>clk, rst=>rst, en=>'1', we=>we, addr=>ram_addr, di=>x_reg, do=>ram_out);
    MAC0: mac port map (clk=>clk, rom_out=>rom_out, ram_out=>ram_out, mac_init=>mac_init_reg, y=>y);

    process (clk)
    begin
        if rising_edge(clk) then
            x_reg <= x;
            mac_init_reg <= mac_init;
        end if;
    end process;

end Structural;
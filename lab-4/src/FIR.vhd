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
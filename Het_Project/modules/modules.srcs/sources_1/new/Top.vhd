-- top.vhd (nu met 9 cellen!)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        sw      : in  std_logic_vector(8 downto 0);
        btnC    : in  std_logic;
        hsync   : out std_logic;
        vsync   : out std_logic;
        rgb     : out std_logic_vector(11 downto 0)
    );
end top;

architecture Behavioral of top is
    component vga_sync
        port (clk, reset : in std_logic;
              hsync, vsync, video_on, p_tick : out std_logic;
              x, y : out std_logic_vector(9 downto 0));
    end component;

    component board
        port (clk, reset : in std_logic;
              sw : in std_logic_vector(8 downto 0);
              btnC : in std_logic;
              pixel_x, pixel_y : in std_logic_vector(9 downto 0);
              video_on : in std_logic;
              rgb_out : out std_logic_vector(11 downto 0));
    end component;

    signal video_on, p_tick : std_logic;
    signal pixel_x, pixel_y : std_logic_vector(9 downto 0);

begin
    vga: vga_sync port map (
        clk=>clk, reset=>reset,
        hsync=>hsync, vsync=>vsync,
        video_on=>video_on, p_tick=>p_tick,
        x=>pixel_x, y=>pixel_y
    );

    spelbord: board port map (
        clk=>clk, reset=>reset,
        sw=>sw, btnC=>btnC,
        pixel_x=>pixel_x, pixel_y=>pixel_y,
        video_on=>video_on,
        rgb_out=>rgb
    );

end Behavioral;
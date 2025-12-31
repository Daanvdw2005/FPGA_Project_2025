library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           rgb : out STD_LOGIC_VECTOR(11 downto 0) );
end top;

architecture Behavioral of top is
    component vga_sync
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               hsync : out STD_LOGIC;
               vsync : out STD_LOGIC;
               video_on : out STD_LOGIC;
               p_tick : out STD_LOGIC;
               x : out STD_LOGIC_VECTOR(9 downto 0);
               y : out STD_LOGIC_VECTOR(9 downto 0) );
    end component;

    signal video_on, p_tick : STD_LOGIC;
    signal x, y : STD_LOGIC_VECTOR(9 downto 0);

begin
    vga_inst: vga_sync port map (clk => clk, reset => reset, hsync => hsync, vsync => vsync, video_on => video_on, p_tick => p_tick, x => x, y => y);

    process(video_on)
    begin
        if video_on = '1' then
            rgb <= "111100000000";  -- Vast rood
        else
            rgb <= (others => '0');
        end if;
    end process;
end Behavioral;
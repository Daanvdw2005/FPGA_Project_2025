library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           hsync  : out STD_LOGIC;
           vsync  : out STD_LOGIC;
           rgb    : out STD_LOGIC_VECTOR(11 downto 0) );
end top;

architecture Behavioral of top is
    component vga_sync
        Port ( clk       : in  STD_LOGIC;
               reset     : in  STD_LOGIC;
               hsync     : out STD_LOGIC;
               vsync     : out STD_LOGIC;
               video_on  : out STD_LOGIC;
               p_tick    : out STD_LOGIC;
               x         : out STD_LOGIC_VECTOR(9 downto 0);
               y         : out STD_LOGIC_VECTOR(9 downto 0) );
    end component;

    signal video_on, p_tick : STD_LOGIC;
    signal x, y             : STD_LOGIC_VECTOR(9 downto 0);

    -- === SCHERM FORMAAT: borders ===
    constant hBorder : integer := 100;  -- 100 px links/rechts
    constant vBorder : integer := 20;   -- 20 px boven/onder

begin
    vga_inst: vga_sync port map (
        clk => clk, reset => reset,
        hsync => hsync, vsync => vsync,
        video_on => video_on, p_tick => p_tick,
        x => x, y => y
    );

    -- === GRIJZE RAND + ZWART SPEELVELD ===
    process(video_on, x, y)
    begin
        if video_on = '1' then
            -- Binnen actief speelveld?
            if to_integer(unsigned(x)) > hBorder and
               to_integer(unsigned(x)) < 640 - hBorder and
               to_integer(unsigned(y)) > vBorder and
               to_integer(unsigned(y)) < 480 - vBorder then
                rgb <= "000000000000";  -- ZWART = speelveld (achtergrond)
            else
                rgb <= "011101110111";  -- GRIJS = border (50% helderheid)
            end if;
        else
            rgb <= (others => '0');     -- ZWART buiten video_on
        end if;
    end process;
end Behavioral;
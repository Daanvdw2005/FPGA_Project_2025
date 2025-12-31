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

    -- Scherm & raster
    constant hBorder    : integer := 100;
    constant vBorder    : integer := 20;
    constant lineWeight : integer := 2;
    constant hLinePos1  : integer := vBorder + 147;   -- y = 167
    constant hLinePos2  : integer := vBorder + 294;   -- y = 314
    constant vLinePos1  : integer := hBorder + 147;   -- x = 247
    constant vLinePos2  : integer := hBorder + 294;   -- x = 394

    -- Kruisje in cel 1 (statisch, puur voor demonstratie)
    constant sqBorder       : integer := 30;   -- weinig zwarte rand rondom
    constant crossThickness : integer := 22;   -- dikte van de X (±22 = 44 px dik)

begin

    vga_inst: vga_sync port map (
        clk => clk, reset => reset,
        hsync => hsync, vsync => vsync,
        video_on => video_on, p_tick => p_tick,
        x => x, y => y
    );

    process(video_on, x, y)
        variable x_int, y_int : integer;
        variable draw_line    : boolean := false;
        variable draw_x       : boolean := false;
    begin
        x_int := to_integer(unsigned(x));
        y_int := to_integer(unsigned(y));

        draw_line := false;
        draw_x    := false;

        if video_on = '1' then
            if x_int > hBorder and x_int < 640-hBorder and
               y_int > vBorder and y_int < 480-vBorder then

                -- 1. Rasterlijnen (hoogste prioriteit)
                if  (y_int >= hLinePos1 - lineWeight and y_int <= hLinePos1 + lineWeight) or
                    (y_int >= hLinePos2 - lineWeight and y_int <= hLinePos2 + lineWeight) or
                    (x_int >= vLinePos1 - lineWeight and x_int <= vLinePos1 + lineWeight) or
                    (x_int >= vLinePos2 - lineWeight and x_int <= vLinePos2 + lineWeight) then
                    draw_line := true;

                -- 2. KRUISJE in cel 1
                elsif x_int > hBorder + sqBorder and x_int < vLinePos1 - sqBorder and
                      y_int > vBorder + sqBorder and y_int < hLinePos1 - sqBorder then

                    -- Diagonaal 1: linksboven ? rechtsonder
                    if abs( (x_int - (hBorder + sqBorder)) - (y_int - (vBorder + sqBorder)) ) < crossThickness then
                        draw_x := true;
                    -- Diagonaal 2: rechtsboven ? linksonder
                    elsif abs( (x_int - (hBorder + sqBorder)) + (y_int - (vBorder + sqBorder))
                               - (hLinePos1 - sqBorder - (vBorder + sqBorder)) ) < crossThickness then
                        draw_x := true;
                    end if;
                end if;

                -- UITVOER
                if draw_line then
                    rgb <= "111111111111";          -- wit raster
                elsif draw_x then
                    rgb <= "111100000000";          -- rood kruisje
                else
                    rgb <= "000000000000";          -- zwart achtergrond
                end if;

            else
                rgb <= "011101110111";              -- grijze rand
            end if;
        else
            rgb <= (others => '0');
        end if;
    end process;

end Behavioral;
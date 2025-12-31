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

    -- SCHERM FORMAAT
    constant hBorder : integer := 100;
    constant vBorder : integer := 20;

    -- RASTERLIJNEN
    constant lineWeight : integer := 2;
    constant hLinePos1  : integer := vBorder + 147;   -- y = 167
    constant hLinePos2  : integer := vBorder + 294;   -- y = 314
    constant vLinePos1  : integer := hBorder + 147;   -- x = 247
    constant vLinePos2  : integer := hBorder + 294;   -- x = 394

    -- VIERKANT IN CEL 1 (linker-boven)
    constant sqBorder   : integer := 30;  -- Belangrijk: ruimte tot rasterlijn!

begin

    vga_inst: vga_sync port map (
        clk      => clk,
        reset    => reset,
        hsync    => hsync,
        vsync    => vsync,
        video_on => video_on,
        p_tick   => p_tick,
        x        => x,
        y        => y
    );

    -- RGB PROCESS
    process(video_on, x, y)
        variable x_int, y_int : integer;
        variable draw_line    : boolean := false;
        variable draw_square  : boolean := false;
    begin
        x_int := to_integer(unsigned(x));
        y_int := to_integer(unsigned(y));

        draw_line   := false;
        draw_square := false;

        if video_on = '1' then

            -- Binnen het speelveld?
            if x_int > hBorder and x_int < 640 - hBorder and
               y_int > vBorder and y_int < 480 - vBorder then

                -- 1. RASTERLIJNEN (hoogste prioriteit)
                if  (y_int >= hLinePos1 - lineWeight and y_int <= hLinePos1 + lineWeight) or
                    (y_int >= hLinePos2 - lineWeight and y_int <= hLinePos2 + lineWeight) or
                    (x_int >= vLinePos1 - lineWeight and x_int <= vLinePos1 + lineWeight) or
                    (x_int >= vLinePos2 - lineWeight and x_int <= vLinePos2 + lineWeight) then
                    draw_line := true;

                -- 2. ROOD VIERKANT IN CEL 1 (met sqBorder = 55 ? zwarte rand rondom)
                elsif x_int > hBorder + sqBorder and x_int < vLinePos1 - sqBorder and
                      y_int > vBorder + sqBorder and y_int < hLinePos1 - sqBorder then
                    draw_square := true;
                end if;

                -- UITVOER
                if draw_line then
                    rgb <= "111111111111";          -- WIT = rasterlijnen (winnen altijd)
                elsif draw_square then
                    rgb <= "111100000000";          -- ROOD = vierkant cel 1
                else
                    rgb <= "000000000000";          -- ZWART = achtergrond
                end if;

            else
                rgb <= "011101110111";              -- GRIJS = buitenrand
            end if;

        else
            rgb <= (others => '0');                 -- ZWART buiten video_on
        end if;
    end process;

end Behavioral;
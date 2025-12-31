-- board.vhd - DEFINITIEF, FOUTVRIJ en met jouw stijl 100 % terug
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity board is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        sw        : in  std_logic_vector(8 downto 0);
        btnC      : in  std_logic;

        pixel_x   : in  std_logic_vector(9 downto 0);
        pixel_y   : in  std_logic_vector(9 downto 0);
        video_on  : in  std_logic;

        rgb_out   : out std_logic_vector(11 downto 0)
    );
end board;

architecture Behavioral of board is

    -- Jouw rasterconstants
    constant hBorder    : integer := 100;
    constant vBorder    : integer := 20;
    constant CELL_SIZE  : integer := 147;
    constant lineWeight : integer := 2;

    -- 9 aparte rgb-signalen van de cellen
    type rgb_array is array (0 to 8) of std_logic_vector(11 downto 0);
    signal cell_rgb : rgb_array;

    -- Rasterlijnen
    signal grid_rgb : std_logic_vector(11 downto 0) := (others=>'0');

begin

    -- 1. 9 CELLEN INSTANTIËREN - elk met eigen rgb_out
    gen_cells: for i in 0 to 8 generate
        constant row : integer := i / 3;
        constant col : integer := i mod 3;
        constant pos_x : integer := hBorder + col * CELL_SIZE;
        constant pos_y : integer := vBorder + row * CELL_SIZE;
    begin
        cell_i: entity work.cell
            generic map (POS_X => pos_x, POS_Y => pos_y)
            port map (
                clk       => clk,
                reset     => reset,
                sel       => sw(i),
                turn      => '0',
                confirm   => btnC,
                pixel_x   => pixel_x,
                pixel_y   => pixel_y,
                video_on  => video_on,
                rgb_out   => cell_rgb(i),   -- elke cel heeft zijn eigen draad!
                state_out => open
            );
    end generate;

    -- 2. RASTERLIJNEN
    process(video_on, pixel_x, pixel_y)
        variable x_int, y_int : integer;
    begin
        grid_rgb <= "000000000000";
        x_int := to_integer(unsigned(pixel_x));
        y_int := to_integer(unsigned(pixel_y));

        if video_on = '1' then
            if (y_int >= vBorder + 147 - lineWeight and y_int <= vBorder + 147 + lineWeight) or
               (y_int >= vBorder + 294 - lineWeight and y_int <= vBorder + 294 + lineWeight) or
               (x_int >= hBorder + 147 - lineWeight and x_int <= hBorder + 147 + lineWeight) or
               (x_int >= hBorder + 294 - lineWeight and x_int <= hBorder + 294 + lineWeight) then
                grid_rgb <= "111111111111";
            end if;
        end if;
    end process;

    -- 3. ALLES SAMENVOEGEN - prioriteit: raster > cel > achtergrond
    process(video_on, pixel_x, pixel_y, grid_rgb, cell_rgb)
        variable x_int, y_int : integer;
        variable temp_rgb : std_logic_vector(11 downto 0);
    begin
        x_int := to_integer(unsigned(pixel_x));
        y_int := to_integer(unsigned(pixel_y));

        -- Achtergrond: grijze rand + zwart speelveld
        if video_on = '1' then
            if x_int > hBorder and x_int < 640-hBorder and
               y_int > vBorder and y_int < 480-vBorder then
                temp_rgb := "000000000000";  -- zwart
            else
                temp_rgb := "111111111111";  -- grijs
            end if;
        else
            temp_rgb := "000000000000";
        end if;

        -- Rasterlijnen winnen van alles
        if grid_rgb /= "000000000000" then
            temp_rgb := grid_rgb;
        end if;

        -- Cel-symbolen winnen van achtergrond (maar niet van raster)
        for i in 0 to 8 loop
            if cell_rgb(i) /= "000000000000" then
                temp_rgb := cell_rgb(i);
            end if;
        end loop;

        rgb_out <= temp_rgb;
    end process;

end Behavioral;
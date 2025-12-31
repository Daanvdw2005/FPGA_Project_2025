library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity board is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        sw          : in  std_logic_vector(8 downto 0);
        turn        : in  std_logic;
        confirm     : in  std_logic;
        pixel_x     : in  std_logic_vector(9 downto 0);
        pixel_y     : in  std_logic_vector(9 downto 0);
        video_on    : in  std_logic;
        rgb_out     : out std_logic_vector(11 downto 0);
        cells_state : out std_logic_vector(17 downto 0)
    );
end board;

architecture Behavioral of board is
    constant hBorder    : integer := 100;
    constant vBorder    : integer := 20;
    constant CELL_SIZE  : integer := 147;
    constant lineWeight : integer := 2;

    type rgb_array is array (0 to 8) of std_logic_vector(11 downto 0);
    signal cell_rgb : rgb_array;
    signal grid_rgb : std_logic_vector(11 downto 0) := (others=>'0');

begin

    gen_cells: for i in 0 to 8 generate
        constant row : integer := i / 3;
        constant col : integer := i mod 3;
        constant pos_x : integer := hBorder + col * CELL_SIZE;
        constant pos_y : integer := vBorder + row * CELL_SIZE;
    begin
        cell_i: entity work.cell
            generic map (POS_X => pos_x, POS_Y => pos_y)
            port map (
                clk => clk,
                reset => reset,
                sel => sw(i),
                turn => turn,
                confirm => confirm,
                pixel_x => pixel_x,
                pixel_y => pixel_y,
                video_on => video_on,
                rgb_out => cell_rgb(i),
                state_out => cells_state(2*(i+1)-1 downto 2*i)
            );
    end generate;

    -- Grid lijnen tekenen
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

    -- Combineer outputs
    process(video_on, pixel_x, pixel_y, grid_rgb, cell_rgb)
        variable x_int, y_int : integer;
    begin
        x_int := to_integer(unsigned(pixel_x));
        y_int := to_integer(unsigned(pixel_y));

        if video_on = '1' then
            if x_int > hBorder and x_int < 640-hBorder and
               y_int > vBorder and y_int < 480-vBorder then
                rgb_out <= "000000000000"; -- Binnen speelveld zwart
            else
                rgb_out <= "011101110111"; -- Buiten speelveld grijs
            end if;
        else
            rgb_out <= (others=>'0');
        end if;

        if grid_rgb /= "000000000000" then
            rgb_out <= grid_rgb;
        end if;

        for i in 0 to 8 loop
            if cell_rgb(i) /= "000000000000" then
                rgb_out <= cell_rgb(i);
            end if;
        end loop;
    end process;

end Behavioral;
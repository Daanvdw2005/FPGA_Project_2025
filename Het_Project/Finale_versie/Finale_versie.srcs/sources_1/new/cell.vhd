--------------------------------------------------------------------------------
-- Project      : 3-op-een-rij
-- Bestandsnaam : cell.vhd
-- Auteur       : Daan Van der Weken
--
-- Beschrijving :
-- Dit component vertegenwoordigt één enkel vakje op het speelbord.
-- Het heeft twee taken:
-- 1. Logica: Onthouden of het vakje Leeg, X of O is. Het verandert alleen
--    als het geselecteerd is (sel='1'), bevestigd wordt (confirm='1') én leeg is.
-- 2. Visualisatie: Berekent op basis van de pixel-coördinaten of er een
--    Rood Kruis (X) of een Cyaan Blok (O) getekend moet worden.
--
-- Generics     : POS_X, POS_Y (De positie van dit specifieke vakje op het scherm)
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cell is
    generic (
        POS_X : integer := 0;
        POS_Y : integer := 0
    );
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        sel       : in  std_logic;
        turn      : in  std_logic;
        confirm   : in  std_logic;
        pixel_x   : in  std_logic_vector(9 downto 0);
        pixel_y   : in  std_logic_vector(9 downto 0);
        video_on  : in  std_logic;
        rgb_out   : out std_logic_vector(11 downto 0);
        state_out : out std_logic_vector(1 downto 0) := "00"
    );
end cell;

architecture Behavioral of cell is
    constant CELL_SIZE      : integer := 147;
    constant sqBorder       : integer := 30;
    constant crossThickness : integer := 22;
    constant plsBorder      : integer := 10;

    type state_type is (EMPTY, X, O);
    signal state, next_state : state_type := EMPTY;

    function border_sel(filled : boolean; margin : integer) return integer is
    begin
        if filled then return 0; else return margin; end if;
    end function;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= EMPTY;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, sel, confirm, turn)
    begin
        next_state <= state;
        if sel = '1' and confirm = '1' and state = EMPTY then
            if turn = '0' then
                next_state <= X;
            else
                next_state <= O;
            end if;
        end if;
    end process;

    state_out <= "00" when state = EMPTY else
                 "01" when state = X else
                 "10";

    process(video_on, pixel_x, pixel_y, state)
        variable x_int, y_int, x_rel, y_rel : integer;
    begin
        rgb_out <= "000000000000";

        x_int := to_integer(unsigned(pixel_x));
        y_int := to_integer(unsigned(pixel_y));
        x_rel := x_int - POS_X;
        y_rel := y_int - POS_Y;

        if video_on = '1' and
           x_int >= POS_X and x_int < POS_X + CELL_SIZE and
           y_int >= POS_Y and y_int < POS_Y + CELL_SIZE then

            if x_rel > sqBorder + border_sel(state /= EMPTY, plsBorder) and
               x_rel < CELL_SIZE - sqBorder - border_sel(state /= EMPTY, plsBorder) and
               y_rel > sqBorder + border_sel(state /= EMPTY, plsBorder) and
               y_rel < CELL_SIZE - sqBorder - border_sel(state /= EMPTY, plsBorder) then

                if state = X then
                    if abs(x_rel - y_rel) < crossThickness or
                       abs(x_rel + y_rel - (CELL_SIZE-1)) < crossThickness then
                        rgb_out <= "111100000000";  -- rood
                    end if;
                elsif state = O then
                    rgb_out <= "000011111111";  -- cyaan
                end if;
            end if;
        end if;
    end process;

end Behavioral;
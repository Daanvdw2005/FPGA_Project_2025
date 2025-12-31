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

    -- LIJN TONEN
    constant lineWeight : integer := 2;                     -- Dikte = 4 px (2 boven + 2 onder)
    constant hLinePos1  : integer := vBorder + 147;         -- y = 20 + 147 = 167

begin
    vga_inst: vga_sync port map (
        clk => clk, reset => reset,
        hsync => hsync, vsync => vsync,
        video_on => video_on, p_tick => p_tick,
        x => x, y => y
    );

    -- RGB PROCESS MET LIJN
    process(video_on, x, y)
        variable y_int : integer;
        variable x_int : integer;
    begin
        y_int := to_integer(unsigned(y));
        x_int := to_integer(unsigned(x));

        if video_on = '1' then
            -- Binnen speelveld?
            if x_int > hBorder and x_int < 640 - hBorder and
               y_int > vBorder and y_int < 480 - vBorder then

                -- HORZONTALE LIJN TONEN
                if y_int >= hLinePos1 - lineWeight and
                   y_int <= hLinePos1 + lineWeight then
                    rgb <= "111111111111";  -- WIT = lijn
                else
                    rgb <= "000000000000";  -- ZWART = achtergrond
                end if;

            else
                rgb <= "011101110111";  -- GRIJS = border
            end if;
        else
            rgb <= (others => '0');
        end if;
    end process;

end Behavioral;
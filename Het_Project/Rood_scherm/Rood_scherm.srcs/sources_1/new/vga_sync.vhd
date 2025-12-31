library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        hsync    : out std_logic;
        vsync    : out std_logic;
        video_on : out std_logic;
        p_tick   : out std_logic;
        x        : out std_logic_vector(9 downto 0);
        y        : out std_logic_vector(9 downto 0)
    );
end vga_sync;

architecture Behavioral of vga_sync is
    -- VGA constants (640x480 @ 60Hz, 25MHz pixel clock from 100MHz clk / 4)
    constant H_DISPLAY : integer := 640;
    constant H_L_BORDER : integer := 16;
    constant H_R_BORDER : integer := 48;
    constant H_RETRACE : integer := 96;
    constant H_MAX : integer := H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
    constant START_H_RETRACE : integer := H_DISPLAY + H_R_BORDER;
    constant END_H_RETRACE : integer := H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

    constant V_DISPLAY : integer := 480;
    constant V_T_BORDER : integer := 10;
    constant V_B_BORDER : integer := 33;
    constant V_RETRACE : integer := 2;
    constant V_MAX : integer := V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
    constant START_V_RETRACE : integer := V_DISPLAY + V_B_BORDER;
    constant END_V_RETRACE : integer := V_DISPLAY + V_B_BORDER + V_RETRACE - 1;

    signal pixel_reg : unsigned(1 downto 0) := (others => '0');
    signal pixel_tick : std_logic := '0';
    signal h_count_reg, h_count_next : unsigned(9 downto 0) := (others => '0');
    signal v_count_reg, v_count_next : unsigned(9 downto 0) := (others => '0');
    signal hsync_reg, vsync_reg : std_logic := '0';
    signal hsync_next, vsync_next : std_logic;

begin
    -- Pixel tick (clk / 4 = 25MHz)
    process(clk, reset)
    begin
        if reset = '1' then
            pixel_reg <= (others => '0');
        elsif rising_edge(clk) then
            pixel_reg <= pixel_reg + 1;
        end if;
    end process;
    pixel_tick <= '1' when pixel_reg = "00" else '0';
    p_tick <= pixel_tick;

    -- Counters
    process(clk, reset)
    begin
        if reset = '1' then
            h_count_reg <= (others => '0');
            v_count_reg <= (others => '0');
            hsync_reg <= '0';
            vsync_reg <= '0';
        elsif rising_edge(clk) then
            h_count_reg <= h_count_next;
            v_count_reg <= v_count_next;
            hsync_reg <= hsync_next;
            vsync_reg <= vsync_next;
        end if;
    end process;

    -- Next-state
    h_count_next <= (others => '0') when pixel_tick = '1' and h_count_reg = to_unsigned(H_MAX, 10) else
                    h_count_reg + 1 when pixel_tick = '1' else h_count_reg;
    v_count_next <= (others => '0') when pixel_tick = '1' and h_count_reg = to_unsigned(H_MAX, 10) and v_count_reg = to_unsigned(V_MAX, 10) else
                    v_count_reg + 1 when pixel_tick = '1' and h_count_reg = to_unsigned(H_MAX, 10) else v_count_reg;

    -- Sync signals (active low)
    hsync_next <= '0' when h_count_reg >= to_unsigned(START_H_RETRACE, 10) and h_count_reg <= to_unsigned(END_H_RETRACE, 10) else '1';
    vsync_next <= '0' when v_count_reg >= to_unsigned(START_V_RETRACE, 10) and v_count_reg <= to_unsigned(END_V_RETRACE, 10) else '1';

    -- Outputs
    video_on <= '1' when (h_count_reg < to_unsigned(H_DISPLAY, 10)) and (v_count_reg < to_unsigned(V_DISPLAY, 10)) else '0';
    hsync <= hsync_reg;
    vsync <= vsync_reg;
    x <= std_logic_vector(h_count_reg);
    y <= std_logic_vector(v_count_reg);
end Behavioral;
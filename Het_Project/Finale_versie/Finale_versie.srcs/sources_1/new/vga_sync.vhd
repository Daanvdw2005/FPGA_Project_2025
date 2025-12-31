library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    port (
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
    -- VGA 640x480 @ 60Hz parameters
    constant HD : integer := 640;
    constant HF : integer := 16;
    constant HB : integer := 48;
    constant HR : integer := 96;
    constant VD : integer := 480;
    constant VF : integer := 10;
    constant VB : integer := 33;
    constant VR : integer := 2;

    signal mod4_reg : unsigned(1 downto 0) := "00";
    signal pixel_tick : std_logic;
    signal h_count_reg, h_count_next : unsigned(9 downto 0) := (others => '0');
    signal v_count_reg, v_count_next : unsigned(9 downto 0) := (others => '0');
    signal h_sync_reg, v_sync_reg : std_logic := '0';
    signal h_sync_next, v_sync_next : std_logic;

begin
    -- 25 MHz pixel tick (100 MHz / 4)
    process(clk, reset)
    begin
        if reset = '1' then
            mod4_reg <= "00";
        elsif rising_edge(clk) then
            mod4_reg <= mod4_reg + 1;
        end if;
    end process;
    pixel_tick <= '1' when mod4_reg = "00" else '0';
    p_tick <= pixel_tick;

    -- Counters en Sync generatie
    process(clk, reset)
    begin
        if reset = '1' then
            h_count_reg <= (others => '0');
            v_count_reg <= (others => '0');
            h_sync_reg  <= '0';
            v_sync_reg  <= '0';
        elsif rising_edge(clk) then
            if pixel_tick = '1' then
                h_count_reg <= h_count_next;
                v_count_reg <= v_count_next;
                h_sync_reg  <= h_sync_next;
                v_sync_reg  <= v_sync_next;
            end if;
        end if;
    end process;

    process(h_count_reg, v_count_reg)
    begin
        h_count_next <= h_count_reg;
        v_count_next <= v_count_reg;
        
        if h_count_reg = (HD+HF+HB+HR - 1) then
            h_count_next <= (others => '0');
            if v_count_reg = (VD+VF+VB+VR - 1) then
                v_count_next <= (others => '0');
            else
                v_count_next <= v_count_reg + 1;
            end if;
        else
            h_count_next <= h_count_reg + 1;
        end if;
    end process;

    h_sync_next <= '0' when (h_count_reg >= (HD+HF)) and (h_count_reg <= (HD+HF+HR-1)) else '1';
    v_sync_next <= '0' when (v_count_reg >= (VD+VF)) and (v_count_reg <= (VD+VF+VR-1)) else '1';

    hsync <= h_sync_reg;
    vsync <= v_sync_reg;
    x <= std_logic_vector(h_count_reg);
    y <= std_logic_vector(v_count_reg);
    video_on <= '1' when (h_count_reg < HD) and (v_count_reg < VD) else '0';

end Behavioral;
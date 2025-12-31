library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        btnU    : in  std_logic;
        sw      : in  std_logic_vector(8 downto 0);
        btnC    : in  std_logic;
        
        hsync   : out std_logic;
        vsync   : out std_logic;
        rgb     : out std_logic_vector(11 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        an      : out std_logic_vector(3 downto 0)
    );
end top;

architecture Behavioral of top is

    component vga_sync
        port (clk, reset : in std_logic; hsync, vsync, video_on, p_tick : out std_logic; x, y : out std_logic_vector(9 downto 0));
    end component;

    component game_logic
        port (clk : in std_logic; reset_hard, reset_soft : in std_logic;
              sw : in std_logic_vector(8 downto 0); btnC : in std_logic; 
              turn_out, confirm_out : out std_logic; 
              cells_state : in std_logic_vector(17 downto 0); 
              win : out std_logic; winner : out std_logic_vector(1 downto 0);
              score_x_out, score_o_out : out std_logic_vector(3 downto 0);
              is_intro, ultimate_win, error_out : out std_logic); -- error_out toegevoegd
    end component;

    component board
        port (clk, reset : in std_logic; sw : in std_logic_vector(8 downto 0);
              turn, confirm : in std_logic; pixel_x, pixel_y : in std_logic_vector(9 downto 0); 
              video_on : in std_logic; rgb_out : out std_logic_vector(11 downto 0); 
              cells_state : out std_logic_vector(17 downto 0));
    end component;
    
    component text_display
        port (pixel_x, pixel_y : in std_logic_vector(9 downto 0); 
              video_on, win : in std_logic; winner : in std_logic_vector(1 downto 0); 
              is_intro, ultimate_win, is_error : in std_logic; -- is_error toegevoegd
              rgb_out : out std_logic_vector(11 downto 0));
    end component;
    
    component seg7_display
        port (clk, reset : in std_logic; score_x, score_o : in std_logic_vector(3 downto 0);
              seg : out std_logic_vector(6 downto 0); an : out std_logic_vector(3 downto 0));
    end component;

    signal video_on, p_tick : std_logic;
    signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
    signal turn, confirm, win : std_logic;
    signal cells_state : std_logic_vector(17 downto 0);
    signal board_rgb, text_rgb : std_logic_vector(11 downto 0);
    signal winner : std_logic_vector(1 downto 0);
    signal score_x, score_o : std_logic_vector(3 downto 0);
    signal board_reset : std_logic;
    signal is_intro, ultimate_win, error_sig : std_logic; -- error_sig

begin
    board_reset <= reset or btnU;

    vga: vga_sync port map (
        clk => clk, reset => reset, hsync => hsync, vsync => vsync, video_on => video_on, p_tick => p_tick, x => pixel_x, y => pixel_y
    );

    logic: game_logic port map (
        clk => clk, reset_hard => reset, reset_soft => btnU,
        sw => sw, btnC => btnC,
        turn_out => turn, confirm_out => confirm, cells_state => cells_state,
        win => win, winner => winner,
        score_x_out => score_x, score_o_out => score_o,
        is_intro => is_intro, ultimate_win => ultimate_win,
        error_out => error_sig -- Verbinding
    );

    bord: board port map (
        clk => clk, reset => board_reset, sw => sw, turn => turn, confirm => confirm,
        pixel_x => pixel_x, pixel_y => pixel_y, video_on => video_on,
        rgb_out => board_rgb, cells_state => cells_state
    );
    
    text: text_display port map (
        pixel_x => pixel_x, pixel_y => pixel_y, video_on => video_on,
        win => win, winner => winner,
        is_intro => is_intro, ultimate_win => ultimate_win,
        is_error => error_sig, -- Verbinding
        rgb_out => text_rgb
    );
    
    seg7: seg7_display port map (
        clk => clk, reset => reset, score_x => score_x, score_o => score_o,
        seg => seg, an => an
    );

    process(text_rgb, board_rgb, is_intro)
    begin
        if text_rgb /= "000000000000" then 
            rgb <= text_rgb;
        else
            if is_intro = '1' then rgb <= "000000000000"; else rgb <= board_rgb; end if;
        end if;
    end process;
end Behavioral;
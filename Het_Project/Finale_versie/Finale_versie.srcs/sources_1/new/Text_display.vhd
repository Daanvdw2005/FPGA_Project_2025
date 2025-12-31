--------------------------------------------------------------------------------
-- Project      : 3-op-een-rij
-- Bestandsnaam : text_display.vhd
-- Auteur       : Daan Van der Weken
--
-- Beschrijving :
-- Deze module verzorgt alle tekstweergave op het scherm.
-- Het bevat een interne 'bitmap font' (8x8 pixels per letter) en logica om
-- verschillende berichten te tonen afhankelijk van de spelstatus:
-- 1. Intro scherm (Project info, instructies)
-- 2. Error melding (Foutieve zet)
-- 3. Winnaar scherm (Wie heeft gewonnen)
-- 4. Kampioen scherm (Ultimate win)
--
-- Ingangen     : pixel_x, pixel_y, game states (win, intro, error, etc.)
-- Uitgangen    : rgb_out (pixelkleur voor de tekst-overlay)
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity text_display is
    port (
        pixel_x     : in  std_logic_vector(9 downto 0);
        pixel_y     : in  std_logic_vector(9 downto 0);
        video_on    : in  std_logic;
        
        win         : in  std_logic;
        winner      : in  std_logic_vector(1 downto 0);
        is_intro    : in  std_logic;
        ultimate_win: in  std_logic;
        
        is_error    : in  std_logic;
        
        rgb_out     : out std_logic_vector(11 downto 0)
    );
end text_display;

architecture Behavioral of text_display is
    constant ZOOM : integer := 2; 
    constant T_START_X : integer := 20; 
    constant T_START_Y : integer := 140;
    constant BOX_W     : integer := 600;
    constant BOX_H     : integer := 200; 

    type font_row is array (0 to 7) of std_logic_vector(7 downto 0);
    
    -- ALFABET
    constant F_SP : font_row := (others=>"00000000");
    constant F_A  : font_row := ("00111100","01000010","10000001","10000001","11111111","10000001","10000001","10000001");
    constant F_B  : font_row := ("11111100","10000010","10000010","11111100","10000010","10000010","10000010","11111100");
    constant F_C  : font_row := ("00111100","01000010","10000000","10000000","10000000","10000000","01000010","00111100");
    constant F_D  : font_row := ("11111100","10000010","10000010","10000010","10000010","10000010","10000010","11111100");
    constant F_E  : font_row := ("11111111","10000000","10000000","11111100","10000000","10000000","10000000","11111111");
    constant F_F  : font_row := ("11111111","10000000","10000000","11111100","10000000","10000000","10000000","10000000"); 
    constant F_G  : font_row := ("00111100","01000010","10000000","10000000","10011100","10000010","01000010","00111100");
    constant F_H  : font_row := ("10000001","10000001","10000001","11111111","10000001","10000001","10000001","10000001");
    constant F_I  : font_row := ("00111100","00011000","00011000","00011000","00011000","00011000","00011000","00111100");
    constant F_J  : font_row := ("00000011","00000001","00000001","00000001","00000001","10000001","01111110","00000000");
    constant F_K  : font_row := ("10000010","10000100","10001000","10010000","10010000","10001000","10000100","10000010");
    constant F_L  : font_row := ("10000000","10000000","10000000","10000000","10000000","10000000","10000000","11111111");
    constant F_M  : font_row := ("10000001","11000011","10100101","10011001","10000001","10000001","10000001","10000001");
    constant F_N  : font_row := ("10000001","11000001","10100001","10010001","10001001","10000101","10000011","10000001");
    constant F_O  : font_row := ("00111100","01000010","10000001","10000001","10000001","10000001","01000010","00111100");
    constant F_P  : font_row := ("11111100","10000010","10000010","11111100","10000000","10000000","10000000","10000000");
    constant F_R  : font_row := ("11111100","10000010","10000010","11111100","10010000","10001000","10000100","10000010");
    constant F_S  : font_row := ("01111110","10000000","10000000","01111110","00000001","00000001","00000001","01111110");
    constant F_T  : font_row := ("11111111","00011000","00011000","00011000","00011000","00011000","00011000","00011000");
    constant F_U  : font_row := ("10000001","10000001","10000001","10000001","10000001","10000001","01000010","00111100");
    constant F_V  : font_row := ("10000001","10000001","10000001","10000001","10000001","01000010","00100100","00011000");
    constant F_W  : font_row := ("10000001","10000001","10000001","10011001","10100101","10100101","01000010","00000000");
    constant F_X  : font_row := ("10000001","01000010","00100100","00011000","00011000","00100100","01000010","10000001");
    constant F_Z  : font_row := ("11111111","00000010","00000100","00001000","00010000","00100000","01000000","11111111");
    
    -- NIEUWE TEKENS
    constant F_Eq : font_row := ("00000000","00000000","01111110","00000000","01111110","00000000","00000000","00000000");
    constant F_1  : font_row := ("00001000","00011000","00101000","00001000","00001000","00001000","00001000","00111110");
    constant F_Exc: font_row := ("00011000","00011000","00011000","00011000","00011000","00000000","00011000","00000000");
    -- VIERKANTJE (Square)
    constant F_Sq : font_row := ("11111111","10000001","10000001","10000001","10000001","10000001","10000001","11111111");

    type message_type is array (0 to 31) of font_row;
    
    signal line1, line2, line3, line4, line5 : message_type; 
    signal text_color : std_logic_vector(11 downto 0);
    signal show_text  : std_logic := '0';

begin

    process(is_intro, win, winner, ultimate_win, is_error)
    begin
        line1 <= (others => F_SP); line2 <= (others => F_SP);
        line3 <= (others => F_SP); line4 <= (others => F_SP); line5 <= (others => F_SP);
        text_color <= "111111111111";
        show_text <= '0';

        if is_error = '1' then
            show_text <= '1';
            text_color <= "111100000000"; -- ROOD voor error
            
            -- "FOUT !!"
            line2(0)<=F_F; line2(1)<=F_O; line2(2)<=F_U; line2(3)<=F_T; line2(5)<=F_Exc; line2(6)<=F_Exc;
            
            -- "KIES 1 VAKJE"
            line3(0)<=F_K; line3(1)<=F_I; line3(2)<=F_E; line3(3)<=F_S;
            line3(5)<=F_1; 
            line3(7)<=F_V; line3(8)<=F_A; line3(9)<=F_K; line3(10)<=F_J; line3(11)<=F_E;

        elsif is_intro = '1' then
            show_text <= '1';
            text_color <= "111111111111"; -- Wit
            
            line1(0)<=F_P; line1(1)<=F_R; line1(2)<=F_O; line1(3)<=F_J; line1(4)<=F_E; line1(5)<=F_C; line1(6)<=F_T;
            line1(8)<=F_V; line1(9)<=F_O; line1(10)<=F_O; line1(11)<=F_R;
            line1(13)<=F_D; line1(14)<=F_S; line1(15)<=F_D;

            line2(0)<=F_D; line2(1)<=F_A; line2(2)<=F_A; line2(3)<=F_N;
            line2(5)<=F_V; line2(6)<=F_A; line2(7)<=F_N;
            line2(9)<=F_D; line2(10)<=F_E; line2(11)<=F_R;
            line2(13)<=F_W; line2(14)<=F_E; line2(15)<=F_K; line2(16)<=F_E; line2(17)<=F_N;

            line3(0)<=F_S; line3(1)<=F_W; line3(2)<=F_Eq; line3(3)<=F_K; line3(4)<=F_I; line3(5)<=F_E; line3(6)<=F_S;
            line3(9)<=F_C; line3(10)<=F_Eq; line3(11)<=F_Z; line3(12)<=F_E; line3(13)<=F_T;

            line4(0)<=F_U; line4(1)<=F_Eq; line4(2)<=F_N; line4(3)<=F_I; line4(4)<=F_E; line4(5)<=F_U; line4(6)<=F_W;
            line4(9)<=F_D; line4(10)<=F_Eq; line4(11)<=F_R; line4(12)<=F_E; line4(13)<=F_S; line4(14)<=F_E; line4(15)<=F_T;

            line5(0)<=F_D; line5(1)<=F_R; line5(2)<=F_U; line5(3)<=F_K; 
            line5(5)<=F_C; 
            line5(7)<=F_S; line5(8)<=F_T; line5(9)<=F_A; line5(10)<=F_R; line5(11)<=F_T;

        elsif ultimate_win = '1' then
            show_text <= '1';
            line2(0)<=F_K; line2(1)<=F_A; line2(2)<=F_M; line2(3)<=F_P; 
            line2(4)<=F_I; line2(5)<=F_O; line2(6)<=F_E; line2(7)<=F_N;
            
            if winner = "01" then 
                 text_color <= "111100000000"; line3(0)<=F_X; 
            else
                 text_color <= "000011111111"; line3(0)<=F_Sq;
            end if;
            line3(2)<=F_W; line3(3)<=F_I; line3(4)<=F_N; line3(5)<=F_T;

        elsif win = '1' then
            show_text <= '1';
            line2(0)<=F_W; line2(1)<=F_I; line2(2)<=F_N; line2(3)<=F_N;
            line2(4)<=F_A; line2(5)<=F_A; line2(6)<=F_R;
            if winner = "01" then
                line2(8)<=F_X; text_color <= "111100000000";
            else
                line2(8)<=F_Sq; text_color <= "000011111111";
            end if;
        end if;
    end process;

    process(video_on, pixel_x, pixel_y, show_text, text_color)
        variable x_int, y_int, x_rel, y_rel : integer;
        variable char_idx, bit_idx, line_select : integer; 
    begin
        rgb_out <= "000000000000"; 
        
        if show_text = '1' and video_on = '1' then
            x_int := to_integer(unsigned(pixel_x)); y_int := to_integer(unsigned(pixel_y));
            if x_int >= T_START_X and x_int < T_START_X + BOX_W and y_int >= T_START_Y and y_int < T_START_Y + BOX_H then
                rgb_out <= "000100010001";
                x_rel := (x_int - T_START_X) / ZOOM; y_rel := (y_int - T_START_Y) / ZOOM;
                
                if y_rel >= 0 and y_rel < 8 then line_select := 1;
                elsif y_rel >= 12 and y_rel < 20 then line_select := 2; y_rel := y_rel - 12;
                elsif y_rel >= 24 and y_rel < 32 then line_select := 3; y_rel := y_rel - 24;
                elsif y_rel >= 36 and y_rel < 44 then line_select := 4; y_rel := y_rel - 36;
                elsif y_rel >= 48 and y_rel < 56 then line_select := 5; y_rel := y_rel - 48;
                else line_select := 0; end if;
                
                if line_select > 0 then
                    char_idx := x_rel / 8; bit_idx  := 7 - (x_rel mod 8);
                    if char_idx <= 31 then
                        if line_select = 1 then if line1(char_idx)(y_rel)(bit_idx) = '1' then rgb_out <= text_color; end if;
                        elsif line_select = 2 then if line2(char_idx)(y_rel)(bit_idx) = '1' then rgb_out <= text_color; end if;
                        elsif line_select = 3 then if line3(char_idx)(y_rel)(bit_idx) = '1' then rgb_out <= text_color; end if;
                        elsif line_select = 4 then if line4(char_idx)(y_rel)(bit_idx) = '1' then rgb_out <= text_color; end if;
                        elsif line_select = 5 then if line5(char_idx)(y_rel)(bit_idx) = '1' then rgb_out <= text_color; end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
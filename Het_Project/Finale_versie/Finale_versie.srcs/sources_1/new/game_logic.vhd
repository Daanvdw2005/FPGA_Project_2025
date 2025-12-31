--------------------------------------------------------------------------------
-- Project      : 3-op-een-rij
-- Bestandsnaam : game_logic.vhd
-- Auteur       : Daan Van der Weken
--
-- Beschrijving :
-- Dit is het 'brein' van het spel. Deze module bevat de Finite State Machine (FSM)
-- die het spelverloop regelt (Intro -> Spelen -> Winnaar -> Reset).
-- Het controleert ook:
-- 1. Of een zet geldig is (vakje leeg + slechts 1 switch aan).
-- 2. Of iemand gewonnen heeft (horizontaal, verticaal, diagonaal).
-- 3. De scorestand en wiens beurt het is.
--
-- Ingangen     : clk, resets, sw (keuze), btnC (bevestig), cells_state (bord info)
-- Uitgangen    : Spelstatus (win, turn, score), scherm-aansturing (intro/win)
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_logic is
    port (
        clk         : in  std_logic;
        reset_hard  : in  std_logic; -- Reset knop 
        reset_soft  : in  std_logic; -- Nieuw potje
        
        sw          : in  std_logic_vector(8 downto 0);
        btnC        : in  std_logic; -- Bevestig knop
        
        -- Outputs naar bord/cellen
        turn_out    : out std_logic;
        confirm_out : out std_logic;
        
        -- status van alle vakjes
        cells_state : in  std_logic_vector(17 downto 0);
        
        -- Game status outputs
        win         : out std_logic;
        winner      : out std_logic_vector(1 downto 0);
        score_x_out : out std_logic_vector(3 downto 0);
        score_o_out : out std_logic_vector(3 downto 0);
        
        is_intro    : out std_logic;
        ultimate_win: out std_logic;
        error_out   : out std_logic
    );
end game_logic;

architecture Behavioral of game_logic is

    type game_state_type is (INTRO, PLAYING, UPDATE_BOARD, GAME_OVER, WINNER_SCREEN);
    signal current_state : game_state_type := INTRO;

    signal turn_i       : std_logic := '0'; -- 0 = Speler X, 1 = Speler O
    signal winner_i     : std_logic_vector(1 downto 0) := "00";
    signal win_detected : std_logic := '0';
    
    signal score_x, score_o : integer range 0 to 9 := 0;
    
    -- Signalen voor knop-detectie (Debouncing / Edge Detection)
    signal btnC_prev        : std_logic := '0';
    signal btnC_pressed     : std_logic := '0';
    
    -- NIEUW: Edge detection voor de Reset knop (btnU)
    signal btnU_prev        : std_logic := '0';
    signal btnU_pressed     : std_logic := '0';

    signal sw_valid     : std_logic_vector(8 downto 0);
    signal sw_count     : integer range 0 to 9;

begin

    -- 1. Smart Switch Validatie
    process(sw, cells_state)
        variable count : integer;
    begin
        count := 0;
        for i in 0 to 8 loop
            if cells_state(2*i+1 downto 2*i) = "00" then
                -- Vakje is leeg, switch telt mee
                sw_valid(i) <= sw(i);
                if sw(i) = '1' then count := count + 1; end if;
            else
                -- Vakje is bezet, switch negeren
                sw_valid(i) <= '0';
            end if;
        end loop;
        sw_count <= count;
    end process;

    error_out <= '1' when sw_count > 1 else '0';

    turn_out <= turn_i;
    score_x_out <= std_logic_vector(to_unsigned(score_x, 4));
    score_o_out <= std_logic_vector(to_unsigned(score_o, 4));
    winner <= winner_i;
    win <= win_detected;

    -- 2. Button Edge Detection
    process(clk)
    begin
        if rising_edge(clk) then
            -- Detecteer rising edge voor Confirm (btnC)
            btnC_pressed <= '0';
            if btnC = '1' and btnC_prev = '0' then
                btnC_pressed <= '1';
            end if;
            btnC_prev <= btnC;
            
            -- Detecteer rising edge voor Reset (btnU)
            btnU_pressed <= '0';
            if reset_soft = '1' and btnU_prev = '0' then
                btnU_pressed <= '1';
            end if;
            btnU_prev <= reset_soft;
        end if;
    end process;

    -- 3. Win Detectie
    process(cells_state)
        type board_grid is array(0 to 8) of std_logic_vector(1 downto 0);
        variable grid : board_grid;
        variable w : std_logic_vector(1 downto 0);
    begin
        for i in 0 to 8 loop grid(i) := cells_state(2*i+1 downto 2*i); end loop;
        w := "00";
        -- Rijen
        if grid(0)/="00" and grid(0)=grid(1) and grid(1)=grid(2) then w := grid(0); end if;
        if grid(3)/="00" and grid(3)=grid(4) and grid(4)=grid(5) then w := grid(3); end if;
        if grid(6)/="00" and grid(6)=grid(7) and grid(7)=grid(8) then w := grid(6); end if;
        -- Kolommen
        if grid(0)/="00" and grid(0)=grid(3) and grid(3)=grid(6) then w := grid(0); end if;
        if grid(1)/="00" and grid(1)=grid(4) and grid(4)=grid(7) then w := grid(1); end if;
        if grid(2)/="00" and grid(2)=grid(5) and grid(5)=grid(8) then w := grid(2); end if;
        -- Diagonalen
        if grid(0)/="00" and grid(0)=grid(4) and grid(4)=grid(8) then w := grid(0); end if;
        if grid(2)/="00" and grid(2)=grid(4) and grid(4)=grid(6) then w := grid(2); end if;

        if w /= "00" then win_detected <= '1'; winner_i <= w;
        else win_detected <= '0'; winner_i <= "00"; end if;
    end process;

    -- 4. State Machine
    process(clk, reset_hard)
    begin
        if reset_hard = '1' then
            current_state <= INTRO;
            score_x <= 0; score_o <= 0;
            turn_i <= '0';
            is_intro <= '1'; ultimate_win <= '0'; confirm_out <= '0';
            
        elsif rising_edge(clk) then
            
            confirm_out <= '0'; -- Default uit
            
            -- GLOBALE RESET CHECK
            -- Als op btnU gedrukt wordt, reset het spel direct.
            if btnU_pressed = '1' and current_state /= INTRO then
                current_state <= PLAYING;
                turn_i <= '0';
                -- Scores behouden we (tenzij we in winner screen zitten, zie onder)
            else

                case current_state is
                    when INTRO =>
                        is_intro <= '1';
                        if btnC_pressed = '1' then -- Start spel
                            current_state <= PLAYING;
                            is_intro <= '0';
                        end if;

                    when PLAYING =>
                        is_intro <= '0';
                        if win_detected = '1' then
                            -- Update Score
                            if winner_i = "01" then 
                                if score_x < 9 then score_x <= score_x + 1; end if;
                            elsif winner_i = "10" then 
                                if score_o < 9 then score_o <= score_o + 1; end if;
                            end if;
                            current_state <= GAME_OVER;
                        else
                            -- Check op geldige zet
                            if btnC_pressed = '1' and sw_count = 1 then
                                confirm_out <= '1';
                                current_state <= UPDATE_BOARD;
                            end if;
                        end if;

                    when UPDATE_BOARD =>
                        -- Wacht 1 kloktik zodat bord update, dan wissel beurt
                        turn_i <= not turn_i; 
                        current_state <= PLAYING;

                    when GAME_OVER =>
                        if score_x >= 9 or score_o >= 9 then
                            current_state <= WINNER_SCREEN;
                        -- btnU (reset_soft) wordt nu afgehandeld door de globale check bovenaan
                        end if;

                    when WINNER_SCREEN =>
                        ultimate_win <= '1';
                        if btnU_pressed = '1' then -- Speciale reset voor Winner screen
                            score_x <= 0; score_o <= 0;
                            turn_i <= '0';
                            current_state <= PLAYING;
                            ultimate_win <= '0';
                        end if;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
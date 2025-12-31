library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_game_logic is
-- Een testbench heeft geen poorten nodig, het is een gesloten wereld
end tb_game_logic;

architecture Behavioral of tb_game_logic is

    -- 1. Component Declaratie (De module die we gaan testen)
    component game_logic
        port (
            clk         : in std_logic;
            reset_hard  : in std_logic;
            reset_soft  : in std_logic;
            sw          : in std_logic_vector(8 downto 0);
            btnC        : in std_logic;
            turn_out    : out std_logic;
            confirm_out : out std_logic;
            cells_state : in std_logic_vector(17 downto 0);
            win         : out std_logic;
            winner      : out std_logic_vector(1 downto 0);
            score_x_out : out std_logic_vector(3 downto 0);
            score_o_out : out std_logic_vector(3 downto 0);
            is_intro    : out std_logic;
            ultimate_win: out std_logic;
            error_out   : out std_logic
        );
    end component;

    -- 2. Signalen om de poorten aan te sturen
    signal clk          : std_logic := '0';
    signal reset_hard   : std_logic := '0';
    signal reset_soft   : std_logic := '0';
    signal sw           : std_logic_vector(8 downto 0) := (others => '0');
    signal btnC         : std_logic := '0';
    
    -- Inputs vanuit het "bord" (moeten we faken)
    signal cells_state  : std_logic_vector(17 downto 0) := (others => '0');

    -- Outputs om te bekijken
    signal turn_out     : std_logic;
    signal confirm_out  : std_logic;
    signal win          : std_logic;
    signal winner       : std_logic_vector(1 downto 0);
    signal score_x_out  : std_logic_vector(3 downto 0);
    signal score_o_out  : std_logic_vector(3 downto 0);
    signal is_intro     : std_logic;
    signal ultimate_win : std_logic;
    signal error_out    : std_logic;

    -- Klok periode (100 MHz = 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- 3. Unit Under Test (UUT) aanmaken
    uut: game_logic port map (
        clk => clk,
        reset_hard => reset_hard,
        reset_soft => reset_soft,
        sw => sw,
        btnC => btnC,
        turn_out => turn_out,
        confirm_out => confirm_out,
        cells_state => cells_state,
        win => win,
        winner => winner,
        score_x_out => score_x_out,
        score_o_out => score_o_out,
        is_intro => is_intro,
        ultimate_win => ultimate_win,
        error_out => error_out
    );

    -- 4. Klok Proces (Tikt oneindig door)
    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- 5. Stimulus Proces (Hier spelen we het spel)
    stim_proc: process
    begin
        -- A. Reset het systeem
        reset_hard <= '1';
        wait for 20 ns;
        reset_hard <= '0';
        wait for 20 ns;

        -- B. Start het spel vanuit INTRO (Druk op BtnC)
        -- We moeten cells_state leeg houden in het begin
        cells_state <= (others => '0'); 
        
        btnC <= '1'; wait for 20 ns; -- Druk in
        btnC <= '0'; wait for 20 ns; -- Laat los
        
        -- Nu zou is_intro '0' moeten zijn.

        -- C. ZET 1: Speler X kiest Vakje 0 (Links Boven)
        sw <= "000000001"; -- Switch 0 aan
        wait for 20 ns;
        btnC <= '1'; wait for 20 ns; -- Bevestig
        btnC <= '0'; wait for 20 ns;
        
        -- Nu moeten we SIMULEREN dat het bord geupdate is.
        -- In het echt doet board.vhd dit, hier moeten wij het handmatig doen.
        cells_state(1 downto 0) <= "01"; -- Vakje 0 is nu X
        wait for 20 ns;

        -- D. ZET 2: Speler O kiest Vakje 3 (Midden Links)
        sw <= "000001000"; -- Switch 3 aan
        wait for 20 ns;
        btnC <= '1'; wait for 20 ns;
        btnC <= '0'; wait for 20 ns;

        cells_state(7 downto 6) <= "10"; -- Vakje 3 is nu O
        wait for 20 ns;

        -- E. ZET 3: Speler X kiest Vakje 1 (Midden Boven)
        sw <= "000000010"; -- Switch 1 aan
        wait for 20 ns;
        btnC <= '1'; wait for 20 ns;
        btnC <= '0'; wait for 20 ns;

        cells_state(3 downto 2) <= "01"; -- Vakje 1 is nu X
        wait for 20 ns;

        -- F. ZET 4: Speler O kiest Vakje 4 (Midden)
        sw <= "000010000"; -- Switch 4 aan
        wait for 20 ns;
        btnC <= '1'; wait for 20 ns;
        btnC <= '0'; wait for 20 ns;

        cells_state(9 downto 8) <= "10"; -- Vakje 4 is nu O
        wait for 20 ns;

        -- G. ZET 5 (WINNENDE ZET): Speler X kiest Vakje 2 (Rechts Boven)
        -- X heeft nu vakje 0, 1 en 2 -> Rij 1 vol!
        sw <= "000000100"; -- Switch 2 aan
        wait for 20 ns;
        btnC <= '1'; wait for 20 ns;
        btnC <= '0'; wait for 20 ns;
        
        cells_state(5 downto 4) <= "01"; -- Vakje 2 is nu X
        
        -- H. Wacht even en kijk of WIN signaal hoog wordt
        wait for 50 ns;
        
        -- Stop simulatie
        assert false report "Simulatie klaar: Kijk of WIN hoog is!" severity failure;
        wait;
    end process;

end Behavioral;
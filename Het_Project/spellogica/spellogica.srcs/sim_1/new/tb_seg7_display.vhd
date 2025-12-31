library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_seg7_display is
end tb_seg7_display;

architecture Behavioral of tb_seg7_display is

    component seg7_display
        port (
            clk     : in std_logic;
            reset   : in std_logic;
            score_x : in std_logic_vector(3 downto 0);
            score_o : in std_logic_vector(3 downto 0);
            seg     : out std_logic_vector(6 downto 0);
            an      : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal score_x : std_logic_vector(3 downto 0) := "0000";
    signal score_o : std_logic_vector(3 downto 0) := "0000";
    signal seg     : std_logic_vector(6 downto 0);
    signal an      : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns; 

begin

    uut: seg7_display port map (
        clk => clk, reset => reset, score_x => score_x, score_o => score_o,
        seg => seg, an => an
    );

    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- 1. Reset (kort)
        reset <= '1'; wait for 20 ns;
        reset <= '0'; wait for 20 ns;

        -- 2. Zet scores: X=3, O=5
        score_x <= "0011"; -- 3
        score_o <= "0101"; -- 5

        -- 3. Wacht gewoon 200 ns. 
        -- Omdat we nu bits(1 downto 0) gebruiken, zal de 'an' 
        -- elke 40-50 ns van waarde veranderen.
        -- Je zult binnen 200ns alle 4 de displays voorbij zien komen.
        wait for 200 ns; 
        
        -- Stop
        assert false report "Simulatie klaar" severity failure;
        wait;
    end process;

end Behavioral;
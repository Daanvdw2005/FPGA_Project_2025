--------------------------------------------------------------------------------
-- Project      : 3-op-een-rij
-- Bestandsnaam : seg7_display.vhd
-- Auteur       : Daan Van der Weken
--
-- Beschrijving :
-- Deze module stuurt het 4-cijferige 7-segment display op het FPGA-bord aan.
-- Het toont de score van Speler X op het linker display en Speler O op het
-- rechter display. De middelste twee displays blijven uit.
--
-- Werking:
-- Er wordt gebruik gemaakt van Time Division Multiplexing (TDM). Een teller
-- wisselt op hoge snelheid welk display (Anode) actief is, zodat het voor het
-- menselijk oog lijkt alsof ze allemaal tegelijk aan staan.
--
-- Ingangen     : clk, reset, score_x, score_o
-- Uitgangen    : seg (segmenten A-G), an (anodes 0-3)
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7_display is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        score_x  : in  std_logic_vector(3 downto 0);
        score_o  : in  std_logic_vector(3 downto 0);
        seg      : out std_logic_vector(6 downto 0);
        an       : out std_logic_vector(3 downto 0)
    );
end seg7_display;

architecture Behavioral of seg7_display is
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal active_digit    : std_logic_vector(1 downto 0);
    signal hex_val         : std_logic_vector(3 downto 0);
begin

    -- Vertraging voor het switchen van displays (multiplexing)
    process(clk, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    -- Gebruik de bovenste 2 bits om te kiezen welk scherm aan staat (snel genoeg voor het oog)
    active_digit <= std_logic_vector(refresh_counter(19 downto 18));

    process(active_digit, score_x, score_o)
    begin
        case active_digit is
            when "00" => 
                an <= "1110"; -- Rechts (Speler O)
                hex_val <= score_o;
            when "01" => 
                an <= "1101"; -- Midden-Rechts (niets)
                hex_val <= "1111"; -- F = uit (zie hieronder)
            when "10" => 
                an <= "1011"; -- Midden-Links (niets)
                hex_val <= "1111"; 
            when "11" => 
                an <= "0111"; -- Links (Speler X)
                hex_val <= score_x;
            when others =>
                an <= "1111";
                hex_val <= "0000";
        end case;
    end process;

    -- Decoder: Hex naar 7-segment (gfedcba)
    -- 0 is aan, 1 is uit (active low)
    process(hex_val)
    begin
        case hex_val is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Alles uit (voor lege displays)
        end case;
    end process;

end Behavioral;
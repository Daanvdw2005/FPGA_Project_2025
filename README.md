# 🎮 Tic-Tac-Toe (3-op-een-rij) op FPGA

![VHDL](https://img.shields.io/badge/Language-VHDL-blue)
![Platform](https://img.shields.io/badge/Platform-Digilent_Basys_3-orange)
![Tool](https://img.shields.io/badge/Vivado-2023.2-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

> **Digital Systems Development Project** > Een volledige hardware-implementatie van het spel 3-op-een-rij, geschreven in VHDL zonder gebruik van een soft-core processor.

---

##  Over dit Project
Dit project is ontwikkeld voor het vak *Digital Systems Development*. Het doel was om een volledig functionerend digitaal systeem te ontwerpen dat een VGA-monitor aanstuurt en input verwerkt via hardware switches.

Het spel bevat geavanceerde logica zoals **Smart Switch Validatie** (om valsspelen te voorkomen), een **State Machine** voor beurtwisselingen, en real-time **Win-detectie**.

### ✨ Belangrijkste Features
* **VGA Output:** Genereert een stabiel 640x480 @ 60Hz signaal.
* **Visuele Feedback:** Speelveld van 440x440px met duidelijke X (Speler 1) en Vierkant (Speler 2) symbolen.
* **Scorebord:** Huidige score wordt bijgehouden op het 7-segment display (via Time Multiplexing).
* **Input Beveiliging:** Voorkomt dat spelers bezette vakjes kiezen of meerdere switches tegelijk gebruiken.
* **Winnaar Scherm:** Custom bitmapped tekstweergave toont "X WINT" of "VIERKANT WINT".

---

##  Hardware & Benodigdheden

| Onderdeel | Beschrijving |
| :--- | :--- |
| **FPGA Board** | Digilent Basys 3 (Artix-7) |
| **Scherm** | VGA Monitor (640x480 ondersteuning) |
| **Kabel** | VGA kabel |
| **Software** | AMD Xilinx Vivado (Versie 2023.2 of nieuwer) |

---

##  Besturing (Controls)

Het spel wordt bestuurd met de switches en knoppen op het Basys 3 bord.

| Input | Functie |
| :--- | :--- |
| **Switch 0 t/m 8** | Selecteer een vakje op het bord (overeenkomstig met de positie). |
| **Button Center (btnC)** | **Bevestig** je keuze (Plaatst symbool). |
| **Button Up (btnU)** | **Reset** het bord (Start een nieuwe ronde). |
| **Button Down (btnD)** | **Reset** het spel (alles RESET). |

> **Let op:** Dankzij de ingebouwde 'Smart Switch Logica' worden switches die fysiek nog aan staan van een vorige beurt genegeerd als het vakje al bezet is.

---

##  Project Structuur

Het project is **modulair** opgebouwd om debuggen en uitbreiden eenvoudig te maken:

* `top.vhd`: De hoofdmodule die alle onderdelen verbindt.
* `vga_sync.vhd`: Genereert de H-sync en V-sync signalen.
* `game_logic.vhd`: Het 'brein'. Bevat de State Machine, win-detectie en spelregels.
* `board.vhd`: Tekent het raster en de achtergrond.
* `cell.vhd`: Tekent de symbolen (X of Vierkant) per vakje.
* `seg7_display.vhd`: Stuurt het 7-segment display aan voor de score.
* `text_display.vhd`: Bevat de bitmaps voor het "GAME OVER" scherm.

---

##  Installatie & Gebruik

1.  **Clone de repository:**
    ```bash
    git clone [https://github.com/JOUW_GEBRUIKERSNAAM/JOUW_REPO_NAAM.git](https://github.com/JOUW_GEBRUIKERSNAAM/JOUW_REPO_NAAM.git)
    ```
2.  **Open in Vivado:**
    * Start Vivado 2019.2.
    * Open het `.xpr` projectbestand OF maak een nieuw project aan en importeer de VHDL bestanden uit de `src` map en de constraints (`.xdc`) file.
3.  **Generate Bitstream:**
    * Run Synthesis & Implementation.
    * Klik op *Generate Bitstream*.
4.  **Programmeer:**
    * Verbind de Basys 3 via USB.
    * Open *Hardware Manager* en programmeer het device.

---

##  Screenshots & schema's

Alle screenshots & schema's kan u terug vinden in de [/assets map](./Het_Project/assets)


---

##  Auteur
**Daan Van der Weken** Student IT-Electronics | Academiejaar 2025-2026  
*AP Hogeschool Antwerpen*

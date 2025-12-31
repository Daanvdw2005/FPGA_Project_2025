# File saved with Nlview 7.0.21  2019-05-29 bk=1.5064 VDI=41 GEI=36 GUI=JA:9.0 non-TLS-threadsafe
# 
# non-default properties - (restore without -noprops)
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 15
property maxzoom 6.25
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #ff6666
property objecthighlight4 #0000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlapcolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 8
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 15
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 4
property timelimit 1
#
module new top work:top:NOFILE -nosplit
load symbol RTL_OR work OR pin I0 input pin I1 input pin O output fillcolor 1
load symbol board work:board:NOFILE HIERBOX pin clk input.left pin confirm input.left pin reset input.left pin turn input.left pin video_on input.left pinBus cells_state output.right [17:0] pinBus pixel_x input.left [9:0] pinBus pixel_y input.left [9:0] pinBus rgb_out output.right [11:0] pinBus sw input.left [8:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol game_logic work:game_logic:NOFILE HIERBOX pin btnC input.left pin clk input.left pin confirm_out output.right pin error_out output.right pin is_intro output.right pin reset_hard input.left pin reset_soft input.left pin turn_out output.right pin ultimate_win output.right pin win output.right pinBus cells_state input.left [17:0] pinBus score_o_out output.right [3:0] pinBus score_x_out output.right [3:0] pinBus sw input.left [8:0] pinBus winner output.right [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol RTL_NEQ15 work RTL(!=) pin O output.right pinBus I0 input.left [11:0] pinBus I1 input.left [11:0] fillcolor 1
load symbol RTL_MUX64 work MUX pin S input.bot pinBus I0 input.left [11:0] pinBus I1 input.left [11:0] pinBus O output.right [11:0] fillcolor 1
load symbol seg7_display work:seg7_display:NOFILE HIERBOX pin clk input.left pin reset input.left pinBus an output.right [3:0] pinBus score_o input.left [3:0] pinBus score_x input.left [3:0] pinBus seg output.right [6:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol text_display work:text_display:NOFILE HIERBOX pin is_error input.left pin is_intro input.left pin ultimate_win input.left pin video_on input.left pin win input.left pinBus pixel_x input.left [9:0] pinBus pixel_y input.left [9:0] pinBus rgb_out output.right [11:0] pinBus winner input.left [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol vga_sync work:vga_sync:NOFILE HIERBOX pin clk input.left pin hsync output.right pin p_tick output.right pin reset input.left pin video_on output.right pin vsync output.right pinBus x output.right [9:0] pinBus y output.right [9:0] boxcolor 1 fillcolor 2 minwidth 13%
load port btnC input -pg 1 -lvl 0 -x 0 -y 80
load port btnU input -pg 1 -lvl 0 -x 0 -y 300
load port clk input -pg 1 -lvl 0 -x 0 -y 440
load port hsync output -pg 1 -lvl 7 -x 2060 -y 500
load port reset input -pg 1 -lvl 0 -x 0 -y 470
load port vsync output -pg 1 -lvl 7 -x 2060 -y 540
load portBus an output [3:0] -attr @name an[3:0] -pg 1 -lvl 7 -x 2060 -y 420
load portBus rgb output [11:0] -attr @name rgb[11:0] -pg 1 -lvl 7 -x 2060 -y 140
load portBus seg output [6:0] -attr @name seg[6:0] -pg 1 -lvl 7 -x 2060 -y 450
load portBus sw input [8:0] -attr @name sw[8:0] -pg 1 -lvl 0 -x 0 -y 400
load inst board_reset_i RTL_OR work -attr @cell(#000000) RTL_OR -pg 1 -lvl 1 -x 120 -y 350
load inst bord board work:board:NOFILE -autohide -attr @cell(#000000) board -pinBusAttr cells_state @name cells_state[17:0] -pinBusAttr pixel_x @name pixel_x[9:0] -pinBusAttr pixel_y @name pixel_y[9:0] -pinBusAttr rgb_out @name rgb_out[11:0] -pinBusAttr sw @name sw[8:0] -pg 1 -lvl 2 -x 510 -y 130
load inst logic game_logic work:game_logic:NOFILE -autohide -attr @cell(#000000) game_logic -pinBusAttr cells_state @name cells_state[17:0] -pinBusAttr score_o_out @name score_o_out[3:0] -pinBusAttr score_x_out @name score_x_out[3:0] -pinBusAttr sw @name sw[8:0] -pinBusAttr winner @name winner[1:0] -pg 1 -lvl 3 -x 910 -y 150
load inst rgb1_i RTL_NEQ15 work -attr @cell(#000000) RTL_NEQ -pinBusAttr I0 @name I0[11:0] -pinBusAttr I1 @name I1[11:0] -pg 1 -lvl 5 -x 1630 -y 200
load inst rgb_i RTL_MUX64 work -attr @cell(#000000) RTL_MUX -pinBusAttr I0 @name I0[11:0] -pinBusAttr I0 @attr S=1'b1 -pinBusAttr I1 @name I1[11:0] -pinBusAttr I1 @attr S=default -pinBusAttr O @name O[11:0] -pg 1 -lvl 5 -x 1630 -y 60
load inst rgb_i__0 RTL_MUX64 work -attr @cell(#000000) RTL_MUX -pinBusAttr I0 @name I0[11:0] -pinBusAttr I0 @attr S=1'b1 -pinBusAttr I1 @name I1[11:0] -pinBusAttr I1 @attr S=default -pinBusAttr O @name O[11:0] -pg 1 -lvl 6 -x 1900 -y 140
load inst seg7 seg7_display work:seg7_display:NOFILE -autohide -attr @cell(#000000) seg7_display -pinBusAttr an @name an[3:0] -pinBusAttr score_o @name score_o[3:0] -pinBusAttr score_x @name score_x[3:0] -pinBusAttr seg @name seg[6:0] -pg 1 -lvl 6 -x 1900 -y 390
load inst text text_display work:text_display:NOFILE -autohide -attr @cell(#000000) text_display -pinBusAttr pixel_x @name pixel_x[9:0] -pinBusAttr pixel_y @name pixel_y[9:0] -pinBusAttr rgb_out @name rgb_out[11:0] -pinBusAttr winner @name winner[1:0] -pg 1 -lvl 4 -x 1310 -y 170
load inst vga vga_sync work:vga_sync:NOFILE -autohide -attr @cell(#000000) vga_sync -pinAttr p_tick @attr n/c -pinBusAttr x @name x[9:0] -pinBusAttr y @name y[9:0] -pg 1 -lvl 1 -x 120 -y 490
load net <const0> -ground -pin rgb1_i I1[11] -pin rgb1_i I1[10] -pin rgb1_i I1[9] -pin rgb1_i I1[8] -pin rgb1_i I1[7] -pin rgb1_i I1[6] -pin rgb1_i I1[5] -pin rgb1_i I1[4] -pin rgb1_i I1[3] -pin rgb1_i I1[2] -pin rgb1_i I1[1] -pin rgb1_i I1[0] -pin rgb_i I0[11] -pin rgb_i I0[10] -pin rgb_i I0[9] -pin rgb_i I0[8] -pin rgb_i I0[7] -pin rgb_i I0[6] -pin rgb_i I0[5] -pin rgb_i I0[4] -pin rgb_i I0[3] -pin rgb_i I0[2] -pin rgb_i I0[1] -pin rgb_i I0[0]
load net an[0] -attr @rip an[0] -port an[0] -pin seg7 an[0]
load net an[1] -attr @rip an[1] -port an[1] -pin seg7 an[1]
load net an[2] -attr @rip an[2] -port an[2] -pin seg7 an[2]
load net an[3] -attr @rip an[3] -port an[3] -pin seg7 an[3]
load net btnC -port btnC -pin logic btnC
netloc btnC 1 0 3 NJ 80 NJ 80 690J
load net btnU -pin board_reset_i I1 -port btnU -pin logic reset_soft
netloc btnU 1 0 3 60 300 350J 400 710
load net cells_state[0] -attr @rip cells_state[0] -pin bord cells_state[0] -pin logic cells_state[0]
load net cells_state[10] -attr @rip cells_state[10] -pin bord cells_state[10] -pin logic cells_state[10]
load net cells_state[11] -attr @rip cells_state[11] -pin bord cells_state[11] -pin logic cells_state[11]
load net cells_state[12] -attr @rip cells_state[12] -pin bord cells_state[12] -pin logic cells_state[12]
load net cells_state[13] -attr @rip cells_state[13] -pin bord cells_state[13] -pin logic cells_state[13]
load net cells_state[14] -attr @rip cells_state[14] -pin bord cells_state[14] -pin logic cells_state[14]
load net cells_state[15] -attr @rip cells_state[15] -pin bord cells_state[15] -pin logic cells_state[15]
load net cells_state[16] -attr @rip cells_state[16] -pin bord cells_state[16] -pin logic cells_state[16]
load net cells_state[17] -attr @rip cells_state[17] -pin bord cells_state[17] -pin logic cells_state[17]
load net cells_state[1] -attr @rip cells_state[1] -pin bord cells_state[1] -pin logic cells_state[1]
load net cells_state[2] -attr @rip cells_state[2] -pin bord cells_state[2] -pin logic cells_state[2]
load net cells_state[3] -attr @rip cells_state[3] -pin bord cells_state[3] -pin logic cells_state[3]
load net cells_state[4] -attr @rip cells_state[4] -pin bord cells_state[4] -pin logic cells_state[4]
load net cells_state[5] -attr @rip cells_state[5] -pin bord cells_state[5] -pin logic cells_state[5]
load net cells_state[6] -attr @rip cells_state[6] -pin bord cells_state[6] -pin logic cells_state[6]
load net cells_state[7] -attr @rip cells_state[7] -pin bord cells_state[7] -pin logic cells_state[7]
load net cells_state[8] -attr @rip cells_state[8] -pin bord cells_state[8] -pin logic cells_state[8]
load net cells_state[9] -attr @rip cells_state[9] -pin bord cells_state[9] -pin logic cells_state[9]
load net clk -pin bord clk -port clk -pin logic clk -pin seg7 clk -pin vga clk
netloc clk 1 0 6 20 440 270 320 750 400 NJ 400 NJ 400 NJ
load net confirm -pin bord confirm -pin logic confirm_out
netloc confirm 1 1 3 410 60 710J 90 1110
load net error_sig -pin logic error_out -pin text is_error
netloc error_sig 1 3 1 N 180
load net hsync -port hsync -pin vga hsync
netloc hsync 1 1 6 NJ 500 NJ 500 NJ 500 NJ 500 NJ 500 NJ
load net is_intro -pin logic is_intro -pin rgb_i S -pin text is_intro
netloc is_intro 1 3 2 1210 120 NJ
load net pixel_x[0] -attr @rip x[0] -pin bord pixel_x[0] -pin text pixel_x[0] -pin vga x[0]
load net pixel_x[1] -attr @rip x[1] -pin bord pixel_x[1] -pin text pixel_x[1] -pin vga x[1]
load net pixel_x[2] -attr @rip x[2] -pin bord pixel_x[2] -pin text pixel_x[2] -pin vga x[2]
load net pixel_x[3] -attr @rip x[3] -pin bord pixel_x[3] -pin text pixel_x[3] -pin vga x[3]
load net pixel_x[4] -attr @rip x[4] -pin bord pixel_x[4] -pin text pixel_x[4] -pin vga x[4]
load net pixel_x[5] -attr @rip x[5] -pin bord pixel_x[5] -pin text pixel_x[5] -pin vga x[5]
load net pixel_x[6] -attr @rip x[6] -pin bord pixel_x[6] -pin text pixel_x[6] -pin vga x[6]
load net pixel_x[7] -attr @rip x[7] -pin bord pixel_x[7] -pin text pixel_x[7] -pin vga x[7]
load net pixel_x[8] -attr @rip x[8] -pin bord pixel_x[8] -pin text pixel_x[8] -pin vga x[8]
load net pixel_x[9] -attr @rip x[9] -pin bord pixel_x[9] -pin text pixel_x[9] -pin vga x[9]
load net pixel_y[0] -attr @rip y[0] -pin bord pixel_y[0] -pin text pixel_y[0] -pin vga y[0]
load net pixel_y[1] -attr @rip y[1] -pin bord pixel_y[1] -pin text pixel_y[1] -pin vga y[1]
load net pixel_y[2] -attr @rip y[2] -pin bord pixel_y[2] -pin text pixel_y[2] -pin vga y[2]
load net pixel_y[3] -attr @rip y[3] -pin bord pixel_y[3] -pin text pixel_y[3] -pin vga y[3]
load net pixel_y[4] -attr @rip y[4] -pin bord pixel_y[4] -pin text pixel_y[4] -pin vga y[4]
load net pixel_y[5] -attr @rip y[5] -pin bord pixel_y[5] -pin text pixel_y[5] -pin vga y[5]
load net pixel_y[6] -attr @rip y[6] -pin bord pixel_y[6] -pin text pixel_y[6] -pin vga y[6]
load net pixel_y[7] -attr @rip y[7] -pin bord pixel_y[7] -pin text pixel_y[7] -pin vga y[7]
load net pixel_y[8] -attr @rip y[8] -pin bord pixel_y[8] -pin text pixel_y[8] -pin vga y[8]
load net pixel_y[9] -attr @rip y[9] -pin bord pixel_y[9] -pin text pixel_y[9] -pin vga y[9]
load net reset -pin board_reset_i I0 -pin logic reset_hard -port reset -pin seg7 reset -pin vga reset
netloc reset 1 0 6 40 420 NJ 420 770 420 NJ 420 NJ 420 NJ
load net reset0_out -pin board_reset_i O -pin bord reset
netloc reset0_out 1 1 1 290 220n
load net rgb1 -pin rgb1_i O -pin rgb_i__0 S
netloc rgb1 1 5 1 N 200
load net rgb[0] -attr @rip O[0] -port rgb[0] -pin rgb_i__0 O[0]
load net rgb[10] -attr @rip O[10] -port rgb[10] -pin rgb_i__0 O[10]
load net rgb[11] -attr @rip O[11] -port rgb[11] -pin rgb_i__0 O[11]
load net rgb[1] -attr @rip O[1] -port rgb[1] -pin rgb_i__0 O[1]
load net rgb[2] -attr @rip O[2] -port rgb[2] -pin rgb_i__0 O[2]
load net rgb[3] -attr @rip O[3] -port rgb[3] -pin rgb_i__0 O[3]
load net rgb[4] -attr @rip O[4] -port rgb[4] -pin rgb_i__0 O[4]
load net rgb[5] -attr @rip O[5] -port rgb[5] -pin rgb_i__0 O[5]
load net rgb[6] -attr @rip O[6] -port rgb[6] -pin rgb_i__0 O[6]
load net rgb[7] -attr @rip O[7] -port rgb[7] -pin rgb_i__0 O[7]
load net rgb[8] -attr @rip O[8] -port rgb[8] -pin rgb_i__0 O[8]
load net rgb[9] -attr @rip O[9] -port rgb[9] -pin rgb_i__0 O[9]
load net rgb_i_n_0 -attr @rip O[11] -pin rgb_i O[11] -pin rgb_i__0 I1[11]
load net rgb_i_n_1 -attr @rip O[10] -pin rgb_i O[10] -pin rgb_i__0 I1[10]
load net rgb_i_n_10 -attr @rip O[1] -pin rgb_i O[1] -pin rgb_i__0 I1[1]
load net rgb_i_n_11 -attr @rip O[0] -pin rgb_i O[0] -pin rgb_i__0 I1[0]
load net rgb_i_n_2 -attr @rip O[9] -pin rgb_i O[9] -pin rgb_i__0 I1[9]
load net rgb_i_n_3 -attr @rip O[8] -pin rgb_i O[8] -pin rgb_i__0 I1[8]
load net rgb_i_n_4 -attr @rip O[7] -pin rgb_i O[7] -pin rgb_i__0 I1[7]
load net rgb_i_n_5 -attr @rip O[6] -pin rgb_i O[6] -pin rgb_i__0 I1[6]
load net rgb_i_n_6 -attr @rip O[5] -pin rgb_i O[5] -pin rgb_i__0 I1[5]
load net rgb_i_n_7 -attr @rip O[4] -pin rgb_i O[4] -pin rgb_i__0 I1[4]
load net rgb_i_n_8 -attr @rip O[3] -pin rgb_i O[3] -pin rgb_i__0 I1[3]
load net rgb_i_n_9 -attr @rip O[2] -pin rgb_i O[2] -pin rgb_i__0 I1[2]
load net rgb_out[0] -attr @rip rgb_out[0] -pin bord rgb_out[0] -pin rgb_i I1[0]
load net rgb_out[10] -attr @rip rgb_out[10] -pin bord rgb_out[10] -pin rgb_i I1[10]
load net rgb_out[11] -attr @rip rgb_out[11] -pin bord rgb_out[11] -pin rgb_i I1[11]
load net rgb_out[1] -attr @rip rgb_out[1] -pin bord rgb_out[1] -pin rgb_i I1[1]
load net rgb_out[2] -attr @rip rgb_out[2] -pin bord rgb_out[2] -pin rgb_i I1[2]
load net rgb_out[3] -attr @rip rgb_out[3] -pin bord rgb_out[3] -pin rgb_i I1[3]
load net rgb_out[4] -attr @rip rgb_out[4] -pin bord rgb_out[4] -pin rgb_i I1[4]
load net rgb_out[5] -attr @rip rgb_out[5] -pin bord rgb_out[5] -pin rgb_i I1[5]
load net rgb_out[6] -attr @rip rgb_out[6] -pin bord rgb_out[6] -pin rgb_i I1[6]
load net rgb_out[7] -attr @rip rgb_out[7] -pin bord rgb_out[7] -pin rgb_i I1[7]
load net rgb_out[8] -attr @rip rgb_out[8] -pin bord rgb_out[8] -pin rgb_i I1[8]
load net rgb_out[9] -attr @rip rgb_out[9] -pin bord rgb_out[9] -pin rgb_i I1[9]
load net score_o[0] -attr @rip score_o_out[0] -pin logic score_o_out[0] -pin seg7 score_o[0]
load net score_o[1] -attr @rip score_o_out[1] -pin logic score_o_out[1] -pin seg7 score_o[1]
load net score_o[2] -attr @rip score_o_out[2] -pin logic score_o_out[2] -pin seg7 score_o[2]
load net score_o[3] -attr @rip score_o_out[3] -pin logic score_o_out[3] -pin seg7 score_o[3]
load net score_x[0] -attr @rip score_x_out[0] -pin logic score_x_out[0] -pin seg7 score_x[0]
load net score_x[1] -attr @rip score_x_out[1] -pin logic score_x_out[1] -pin seg7 score_x[1]
load net score_x[2] -attr @rip score_x_out[2] -pin logic score_x_out[2] -pin seg7 score_x[2]
load net score_x[3] -attr @rip score_x_out[3] -pin logic score_x_out[3] -pin seg7 score_x[3]
load net seg[0] -attr @rip seg[0] -port seg[0] -pin seg7 seg[0]
load net seg[1] -attr @rip seg[1] -port seg[1] -pin seg7 seg[1]
load net seg[2] -attr @rip seg[2] -port seg[2] -pin seg7 seg[2]
load net seg[3] -attr @rip seg[3] -port seg[3] -pin seg7 seg[3]
load net seg[4] -attr @rip seg[4] -port seg[4] -pin seg7 seg[4]
load net seg[5] -attr @rip seg[5] -port seg[5] -pin seg7 seg[5]
load net seg[6] -attr @rip seg[6] -port seg[6] -pin seg7 seg[6]
load net sw[0] -attr @rip sw[0] -pin bord sw[0] -pin logic sw[0] -port sw[0]
load net sw[1] -attr @rip sw[1] -pin bord sw[1] -pin logic sw[1] -port sw[1]
load net sw[2] -attr @rip sw[2] -pin bord sw[2] -pin logic sw[2] -port sw[2]
load net sw[3] -attr @rip sw[3] -pin bord sw[3] -pin logic sw[3] -port sw[3]
load net sw[4] -attr @rip sw[4] -pin bord sw[4] -pin logic sw[4] -port sw[4]
load net sw[5] -attr @rip sw[5] -pin bord sw[5] -pin logic sw[5] -port sw[5]
load net sw[6] -attr @rip sw[6] -pin bord sw[6] -pin logic sw[6] -port sw[6]
load net sw[7] -attr @rip sw[7] -pin bord sw[7] -pin logic sw[7] -port sw[7]
load net sw[8] -attr @rip sw[8] -pin bord sw[8] -pin logic sw[8] -port sw[8]
load net text_rgb[0] -attr @rip rgb_out[0] -pin rgb1_i I0[0] -pin rgb_i__0 I0[0] -pin text rgb_out[0]
load net text_rgb[10] -attr @rip rgb_out[10] -pin rgb1_i I0[10] -pin rgb_i__0 I0[10] -pin text rgb_out[10]
load net text_rgb[11] -attr @rip rgb_out[11] -pin rgb1_i I0[11] -pin rgb_i__0 I0[11] -pin text rgb_out[11]
load net text_rgb[1] -attr @rip rgb_out[1] -pin rgb1_i I0[1] -pin rgb_i__0 I0[1] -pin text rgb_out[1]
load net text_rgb[2] -attr @rip rgb_out[2] -pin rgb1_i I0[2] -pin rgb_i__0 I0[2] -pin text rgb_out[2]
load net text_rgb[3] -attr @rip rgb_out[3] -pin rgb1_i I0[3] -pin rgb_i__0 I0[3] -pin text rgb_out[3]
load net text_rgb[4] -attr @rip rgb_out[4] -pin rgb1_i I0[4] -pin rgb_i__0 I0[4] -pin text rgb_out[4]
load net text_rgb[5] -attr @rip rgb_out[5] -pin rgb1_i I0[5] -pin rgb_i__0 I0[5] -pin text rgb_out[5]
load net text_rgb[6] -attr @rip rgb_out[6] -pin rgb1_i I0[6] -pin rgb_i__0 I0[6] -pin text rgb_out[6]
load net text_rgb[7] -attr @rip rgb_out[7] -pin rgb1_i I0[7] -pin rgb_i__0 I0[7] -pin text rgb_out[7]
load net text_rgb[8] -attr @rip rgb_out[8] -pin rgb1_i I0[8] -pin rgb_i__0 I0[8] -pin text rgb_out[8]
load net text_rgb[9] -attr @rip rgb_out[9] -pin rgb1_i I0[9] -pin rgb_i__0 I0[9] -pin text rgb_out[9]
load net turn -pin bord turn -pin logic turn_out
netloc turn 1 1 3 410 360 NJ 360 1090
load net ultimate_win -pin logic ultimate_win -pin text ultimate_win
netloc ultimate_win 1 3 1 1170 260n
load net video_on -pin bord video_on -pin text video_on -pin vga video_on
netloc video_on 1 1 3 390 520 NJ 520 1210
load net vsync -pin vga vsync -port vsync
netloc vsync 1 1 6 NJ 540 NJ 540 NJ 540 NJ 540 NJ 540 NJ
load net win -pin logic win -pin text win
netloc win 1 3 1 N 300
load net winner[0] -attr @rip winner[0] -pin logic winner[0] -pin text winner[0]
load net winner[1] -attr @rip winner[1] -pin logic winner[1] -pin text winner[1]
load netBundle @sw 9 sw[8] sw[7] sw[6] sw[5] sw[4] sw[3] sw[2] sw[1] sw[0] -autobundled
netbloc @sw 1 0 3 NJ 400 330 340 790J
load netBundle @an 4 an[3] an[2] an[1] an[0] -autobundled
netbloc @an 1 6 1 NJ 420
load netBundle @rgb 12 rgb[11] rgb[10] rgb[9] rgb[8] rgb[7] rgb[6] rgb[5] rgb[4] rgb[3] rgb[2] rgb[1] rgb[0] -autobundled
netbloc @rgb 1 6 1 NJ 140
load netBundle @seg 7 seg[6] seg[5] seg[4] seg[3] seg[2] seg[1] seg[0] -autobundled
netbloc @seg 1 6 1 2040J 440n
load netBundle @cells_state 18 cells_state[17] cells_state[16] cells_state[15] cells_state[14] cells_state[13] cells_state[12] cells_state[11] cells_state[10] cells_state[9] cells_state[8] cells_state[7] cells_state[6] cells_state[5] cells_state[4] cells_state[3] cells_state[2] cells_state[1] cells_state[0] -autobundled
netbloc @cells_state 1 2 1 N 200
load netBundle @rgb_out 12 rgb_out[11] rgb_out[10] rgb_out[9] rgb_out[8] rgb_out[7] rgb_out[6] rgb_out[5] rgb_out[4] rgb_out[3] rgb_out[2] rgb_out[1] rgb_out[0] -autobundled
netbloc @rgb_out 1 2 3 730 70 NJ 70 NJ
load netBundle @score_o 4 score_o[3] score_o[2] score_o[1] score_o[0] -autobundled
netbloc @score_o 1 3 3 1110J 360 NJ 360 1770
load netBundle @score_x 4 score_x[3] score_x[2] score_x[1] score_x[0] -autobundled
netbloc @score_x 1 3 3 1150J 380 NJ 380 1750
load netBundle @winner 2 winner[1] winner[0] -autobundled
netbloc @winner 1 3 1 N 320
load netBundle @rgb_i_n_ 12 rgb_i_n_0 rgb_i_n_1 rgb_i_n_2 rgb_i_n_3 rgb_i_n_4 rgb_i_n_5 rgb_i_n_6 rgb_i_n_7 rgb_i_n_8 rgb_i_n_9 rgb_i_n_10 rgb_i_n_11 -autobundled
netbloc @rgb_i_n_ 1 5 1 1770 60n
load netBundle @text_rgb 12 text_rgb[11] text_rgb[10] text_rgb[9] text_rgb[8] text_rgb[7] text_rgb[6] text_rgb[5] text_rgb[4] text_rgb[3] text_rgb[2] text_rgb[1] text_rgb[0] -autobundled
netbloc @text_rgb 1 4 2 1480 150 1750
load netBundle @pixel_x 10 pixel_x[9] pixel_x[8] pixel_x[7] pixel_x[6] pixel_x[5] pixel_x[4] pixel_x[3] pixel_x[2] pixel_x[1] pixel_x[0] -autobundled
netbloc @pixel_x 1 1 3 310 380 NJ 380 1130J
load netBundle @pixel_y 10 pixel_y[9] pixel_y[8] pixel_y[7] pixel_y[6] pixel_y[5] pixel_y[4] pixel_y[3] pixel_y[2] pixel_y[1] pixel_y[0] -autobundled
netbloc @pixel_y 1 1 3 370 560 NJ 560 1190
levelinfo -pg 1 0 120 510 910 1310 1630 1900 2060
pagesize -pg 1 -db -bbox -sgen -100 0 2170 620
show
fullfit
#
# initialize ictrl to current module top work:top:NOFILE
ictrl init topinfo |

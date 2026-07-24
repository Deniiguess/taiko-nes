.proc song_sel
	; clear the draw memory address
	; so it doesnt write random tiles when a slight change is made
  LDX #$00 ; load $00 to X
  TXA ; and A (its like LDA #$00)
  clear_draw:
  STA draw, X ; store A ($00) from draw+0 to draw+79
  INX ; increase X
  BPL clear_draw ; if X is below $80, repeat

  ; run some input subroutines
  JSR update_START
  JSR update_B
  JSR update_SEL

  ; update the cursor positions and selections and stuff
  JSR update_cursor_position

  ; update the song selection song preview
  JSR update_song_select_value

  ; update the pause when you fully select a song
  JSR update_pauses

  ; update the Y scroll
  JSR update_Y_scroll

  ; despite its name, update all sprites and their Y positions
  JSR update_controller_highlight

  ; update the color palette of Drum
  JSR update_donchan_color

  ; load the proper difficulty select stats (charter, stars, etc.)
  JSR update_diff_sel_loading

  ; switches between the 2 top score screens
  JSR update_top_scores

  ; update the control type internally
  ; so the main game controls match the selected control type
  ; without you entering the settings
  JSR update_controls

  JMP stay_here
.endproc

.proc update_pauses
  LDA ts_ss_timer+1 ; load ts_ss_timer+1 to A
  BNE :+
  RTS ; dont do anything if ts_ss_timer+1 is $00

  :

  INC ts_ss_timer+1 ; increase ts_ss_timer+1
  CMP #20 ; check if A is $20
  BNE :+

  ; if yes, play the voice sample
  LDA #$02
  JSR famistudio_sfx_sample_play
  ; and continue with the subroutine
  :
  CMP #182 ; check if A is 182
  BNE dont_load_main_game ; if not, leave the subroutine

  ; load the correct chart
  LDX song_sel_position ; load the song select position to X
  LDY diff_sel_position, X ; load the difficulty position + X (the difficulty position of the correct song)
  CPX #$00 ; check if X is $00, without it it would check Y instead
  BEQ :+ ; if yes, skip some code to save cycles (no need to do addition)
  LDA #$00 ; load $00 to A
  CLC ; clear carry (for upcoming ADC, CPX sets the carry)
  add_to_chart_start:
  ADC #$04 ; add 4 to A based on the song select position
  DEX ; decrease X
  BNE add_to_chart_start ; repeat until X is 0

  TAX ; transfer result in A to X
  :

  CPY #$00 ; check if Y is $00, without it it would check X instead
  BEQ :+ ; if yes, skip some code to save cycles (no need to do incrementing)
  add_to_chart_diff:
  INX ; increase X
  DEY ; decrease Y
  BNE add_to_chart_diff ; repeat until Y is 0
  :

  STX drum_bank_position_chart_backup ; store the result in X to drum_bank_position_chart_backup
  																		; this is for a proper song reload

  ; restore stack (because JSR adds onto the stack and were not using it anymore)
  PLA
  PLA

  JMP load_main_game ; load the main game
  dont_load_main_game:

  ; return
  RTS
.endproc

.proc update_START
  LDA ts_ss_timer+1 ; load ts_ss_timer+1 to A
  BNE start_game ; if it isnt $00, jump to start_game

  LDA song_sel_entry+1 ; load song_sel_entry+1 to A
  BNE :++ ; leave subroutine if it isnt $00

  LDA BTN_Press ; load a button press to A
  AND #%10010000 ; only check for A and START
  BEQ :++ ; if neither of them are pressed, leave subroutine

  ; play DON sample
  LDA #$03
  JSR famistudio_sfx_sample_play

  INC song_sel_entry ; increase song_sel_entry
  LDA song_sel_entry ; then load it to A
  CMP #$01 ; if its $01 (or $02 from the next CMP), jump to scroll_up
  BEQ scroll_up
  CMP #$02
  BNE start_game ; otherwise jump to start_game

  scroll_up:
  LDA #$07
  STA song_sel_entry+1 ; load #$07 to song_sel_entry+1

  LDA song_sel_entry ; load song_sel_entry to A
  CMP #$01 ; check if A is $01
  BNE :+ ; if not, run other code
  LDA BTN_Press ; load a button press to A
  AND #BTN_A ; check for A
  BEQ :+ ; if it isnt pressed, run other code

  ; load $00 to song_sel_entry and song_sel_entry+1
  LDA #$00
  STA song_sel_entry+1
  STA song_sel_entry

  ; return
  RTS

  :
  LDX #$00 ; load #$00 to in_color_set
  STX in_color_set ; so you dont keep selecting a color after you leave settings

  CMP #$02 ; check if A is $02
  BNE :+ ; if not, leave subroutine

  ; change PPU banks to difficulty select
  LDA #$E0
  STA $D000
  LDA #$0A
  STA $B800

  LDA #$03 ; load #$03 to diff_sel_load_timer
  STA diff_sel_load_timer ; for proper stat loading later on
  LDA #240 ; load #240 to frame_timer_score_draw
  STA frame_timer_score_draw ; to setup the high scores that change
  :
  RTS

  start_game:
  CMP #$03 ; check if A is $03
  BNE :++ ; if not, leave subroutine

  LDA ts_ss_timer+1 ; load ts_ss_timer+1 to A
  BNE :+ ; if its not 0, dont run setup code (only run once please)

  ; load and prepare the voice sample PRG-ROM bank
  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  ; play DON sample
  LDA #$03
  JSR famistudio_sfx_sample_play
  :

  INC ts_ss_timer+1 ; increase ts_ss_timer+1

  ; load #121 to ts_ss_timer to prevent the song from playing
  ; if you select a song too quickly
  LDA #121
  STA ts_ss_timer

  ; make song_sel_position+2 minus to prevent the song from playing
  ; if you select a song too quickly
  LDA #$80
  STA song_sel_position+2
  :
  RTS
.endproc

update_B:
  LDA song_sel_entry ; check if song_sel_entry is $02
  CMP #$02 ; (difficulty select)
  BNE :+ ; if its not, leave subroutine

  LDA BTN_Press ; load a button press to A
  AND #BTN_B ; check for B
  BEQ :+ ; if it isnt pressed, leave subroutine

  down:

  LDA song_sel_entry+1 ; if song_sel_entry+1 isnt 0
  BNE :+ ; leave subroutine

  LDA #$87 ; load $87 to A
  STA song_sel_entry+1 ; and store it in song_sel_entry+1

  DEC song_sel_entry ; decrease song_sel_entry

  ; play DON sample
  LDA #$03
  JSR famistudio_sfx_sample_play
  :
  RTS

update_SEL:
  LDA song_sel_entry ; check if song_sel_entry is $01
  CMP #$01 ; (song select)
  BNE :- ; if its not, leave subroutine

  LDA BTN_Press ; load a button press to A
  AND #BTN_SELECT ; check for SELECT
  BEQ :- ; if it isnt pressed, leave subroutine

  ; change PPU banks to settings
  LDA #$E1
  STA $D000
  LDA #$0B
  STA $B800

  JMP down ; jump to down (run scroll down setup code)

.proc update_song_select_value
  LDA ts_ss_timer ; check if ts_ss_timer is 100 (or higher)
  CMP #100 ; if it is, continue
  BCS :+ ; in other words, wait 100 frames before running this code

  INC ts_ss_timer ; increase ts_ss_timer
  RTS ; and then leave subroutine

  :

  BNE :+++ ; then check if its exactly 100
  ; if not, skip some code

  LDA song_sel_position+2 ; load song_sel_position+2 to A
  AND #$7F ; get rid of bit 7
  BEQ :+ ; if the result is 0, run other code
  DEC song_sel_position+2 ; decrease song_sel_position+2
  RTS ; and then leave subroutine
  : ; if it isnt 0, run this

  LDA song_sel_position ; load song_sel_position to A
  CMP song_sel_position+1 ; and compare it with the value in song_sel_position+1
  BEQ :++ ; if they are the same, skip some code

  ; load the proper CPU banks for the song previews
  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song

  LDA #20 ; load $20 to A
  STA song_sel_position+2 ; and store it in song_sel_position+2

  JSR famistudio_music_stop ; stop the music

  LDA song_sel_position+1 ; check if song_sel_position+1 is $FF
  CMP #$FF ; (or first song select launch)
  BEQ :+ ; if it is $FF, skip some location transfer
  :

  LDA song_sel_position ; load song_sel_position to A
  STA song_sel_position+1 ; then store it in song_sel_position+1
  : ; basically transfering the value from song_sel_position to song_sel_position+1

  LDA song_sel_position+2 ; if song_sel_position+2 is
  BNE :+ ; not $00 or
  BMI :+ ; above $80, skip some code
  ORA #$80 ; set bit 7 to 1
  STA song_sel_position+2 ; store the result in song_sel_position+2
  LDA song_sel_position ; play the proper song preview
  JSR famistudio_music_play
  :
  RTS ; leave subroutine
.endproc

.proc update_Y_scroll
  LDA song_sel_entry+1 ; load song_sel_entry+1 to A
  AND #$7F ; get rid of bit 7
  TAX ; copy the result to X

  LDA Y_scroll_table, X ; load the proper value of how many pixels to scroll to A
  PHA ; push A to stack
  LDA song_sel_entry+1 ; load song_sel_entry+1 to A
  AND #$80 ; get rid of every bit except bit 7
  BNE :+ ; if its not 0, skip some code
  PLA ; pull A from stack
  EOR #$FF ; flip all bits
  PHA ; push A to stack (to prevent SP issues from the following PLA)
  :
  PLA ; pull A from stack
  STA PPUSCROLL_Y_speed ; store A to PPUSCROLL_Y_speed
  BEQ :+ ; if its 0, dont decrease song_sel_entry+1
  DEC song_sel_entry+1 ; decrease song_sel_entry+1
  :

  LDA song_sel_entry+1 ; load song_sel_entry+1 to A
  CMP #$80 ; check if A is $80
  BNE :+
  ASL ; if yes, get rid of bit 7 by shifting A to the left
  STA song_sel_entry+1 ; store the result to song_sel_entry+1 (result is always $00)
  :

  LDA PPUSCROLL_Y_speed ; load PPUSCROLL_Y_speed to A
  BPL :+ ; if its below $80
  INC PPUSCROLL_Y_speed ; increase it
  : ; otherwise dont
  RTS ; leave subroutine
.endproc

.proc update_cursor_position
  LDA PPUSCROLL_Y ; load PPUSCROLL_Y to A
  BEQ :+
  RTS ; if its not $00, leave subroutine
  :

  ; jumptable stuff
  LDX song_sel_entry ; load song_sel_entry to X
  LDA cursor_code_lo, X ; load cursor_code_lo + X to A
  STA address_table ; and store it to address_table
  LDA cursor_code_hi, X ; load cursor_code_hi + X to A
  STA address_table+1 ; and store it to address_table+1
  JMP (address_table) ; and finally, indirectly jump to the proper location

  cursor_code_lo:
  .lobytes options_cursor, song_cursor, diff_cursor, nothing
  cursor_code_hi:
  .hibytes options_cursor, song_cursor, diff_cursor, nothing

  nothing:
  RTS
.endproc

.proc options_cursor
	LDX #$00 ; load $00 to X (prepare loop)
	load_controller_t_sprites:
	LDA controller_type_sprite_data, X ; load controller_type_sprite_data + X to A
	STA $25D, X ; store A in $25D + X (load sprite data of controller type circles)
	INX ; increase X
	CPX #23 ; repeat 23 times
	BNE load_controller_t_sprites

	LDA #$3B ; load $3B to A
	STA controller_t_Y ; then store it to controller_t_Y (this sets the base Y position)

	; updates the controller type circles and bg attributes
	JSR update_controller_type

	; make the bg a priority in vblank and not the palette
	LDA #$01
  STA draw_bg_over_palette

  ; prepare PPU locations for the mods
  ; i dont feel like commenting this
  LDA #$04
  STA draw
  STA draw+1
  LDA #$2A
  STA draw+2
  LDA #$F0
  STA draw+3
  LDA #$F6
  STA draw+4
  STA draw+5
  STA draw+6
  STA draw+7

  LDX #$00 ; load $00 to X (prepare loop)
  LDA mods ; load mods to A

  check_mods:
  BIT byte_01 ; check if bit 0 is 1
  BEQ :+ ; if not, dont draw a checked box

  TAY ; transfer A to Y (preserve A without stack)
  LDA #$F7 ; load $F7 (the checked box tile) to A
  STA draw+4, X ; store A to draw+4 (the nametable writing subroutine)
  TYA ; restore A

  :
  ROR ; rotate bits right
  INX ; increase X
  CPX #$04 ; repeat 4 times
  BNE check_mods

  ; load the 4 square sprites for color drum picker
  LDX #$00 ; load $00 to X (prepare loop)
  load_squares:
  LDA color_square_sprite_data, X ; load color_square_sprite_data + X to A
  STA $24D, X ; store A to $24D + X (load sprite data of the squares)
  INX ; increase X
  CPX #15 ; repeat 15 times
  BNE load_squares

  LDA #$9F ; load $9F to A
  STA color_sqr_Y ; then store it to color_sqr_Y (this sets the base Y position)

  LDA in_color_set ; if in_color_set is 1
  BNE return_up ; dont read input code

  LDA BTN_Press ; load a button press to A
  AND #BTN_RIGHT ; check for RIGHT
  BEQ return_right ; if it isnt pressed, dont run code for right input

  JSR move_cursor_right

  return_right:

  LDA BTN_Press ; load a button press to A
  AND #BTN_LEFT ; check for LEFT
  BEQ return_left ; if it isnt pressed, dont run code for left input

  JSR move_cursor_left

  return_left:

  LDA BTN_Press ; load a button press to A
  AND #BTN_DOWN ; check for DOWN
  BEQ return_down ; if it isnt pressed, dont run code for down input

  ; play KAT sample
  LDA #$04
  JSR famistudio_sfx_sample_play
  INC options_position ; increase options_position
  LDA options_position ; load options_position to A
  CMP #$06 ; if its 6
  BEQ set_op_pos_to_0 ; set the position to 0
  CMP #$09 ; if its 9
  BCS set_op_pos_to_6 ; set the position to 6
  ; to prevent accessing unmapped values, leading to a crash (restart)

  return_down:

  LDA BTN_Press ; load a button press to A
  AND #BTN_UP ; check for UP
  BEQ return_up ; if it isnt pressed, dont run code for up input

  ; play KAT sample
  LDA #$04
  JSR famistudio_sfx_sample_play
  DEC options_position ; decrease options_position
  LDA options_position ; load options_position to A
  BMI set_op_pos_to_5 ; if its above $80 (to $FF), set the position to 6
  CMP #$05 ; if its 5
  BEQ set_op_pos_to_8 ; set the position to 8
  CMP #$08 ; if its 8
  BEQ set_op_pos_to_7 ; set the position to 7

  return_up:

  ; jumptable stuff
  LDX options_position ; load options_position to X
  LDA opt_position_lo, X ; load opt_position_lo + X to A
  STA address_table ; and store it to address_table
  LDA opt_position_hi, X ; load opt_position_hi + X to A
  STA address_table+1 ; and store it to address_table+1
  JMP (address_table) ; and finally, indirectly jump to the proper location

  ; set the options_position to $00 (TYPE-A)
  set_op_pos_to_0:
  LDA #$00
  STA options_position
  BEQ return_down

  ; set the options_position to $00 (FLIPPED DRUMS [ ])
  set_op_pos_to_5:
  LDA #$05
  STA options_position
  BNE return_up

  ; set the options_position to $06 (TYPE-B)
  set_op_pos_to_6:
  LDA #$06
  STA options_position
  RTS

  move_cursor_right:
  LDA options_position ; load options_position to A
  CMP #$02 ; if its smaller than $02 ($00 or $01)
  BCC add_6_to_opt_pos ; jump to add_6_to_opt_pos
  CMP #$08 ; if its $08
  BEQ inc_opt_pos ; jumo to inc_opt_pos
  CMP #$06 ; if its equal or higher than $06
  BCS :+ ; leave subroutine (dont do anything)
  ; otherwise
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  LDA #$08 ; load $08 to A
  STA options_position ; and store it to A
  :
  RTS

  ; add 6 to options_position
  ; CLC is not needed because you cant access this with carry flag at 1
  add_6_to_opt_pos:
  ADC #$06
  STA options_position

  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  RTS

  ; increases the options_position by 1
  inc_opt_pos:
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  INC options_position
  RTS

  ; sets options_position to $07 (TYPE-D)
  set_op_pos_to_7:
  LDA #$07
  STA options_position
  RTS

  ; sets options_position to $08 (left color picker)
  set_op_pos_to_8:
  LDA #$08
  STA options_position
  RTS

  move_cursor_left:
  LDA options_position ; load options_position to A
  CMP #$06 ; if its $06
  BEQ set_op_pos_to_0_alt ; jump to set_op_pos_to_0_alt
  CMP #$07 ; if its $07
  BEQ set_op_pos_to_1 ; jump to set_op_pos_to_1
  CMP #$08 ; if its $08
  BEQ set_op_pos_to_2 ; jump to set_op_pos_to_2
  CMP #$09 ; if its $09
  BNE :+ ; leave subroutine
  ; otherwise
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  DEC options_position ; decrease options_position
  :
  RTS

  ; sets options_position to $02 (AUTOPLAY [ ])
  set_op_pos_to_2:
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  LDA #$02
  STA options_position
  RTS

  ; sets options_position to $01 (TYPE-B)
  set_op_pos_to_1:
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  LDA #$01
  STA options_position
  RTS

  ; sets options_position to $00 (TYPE-A)
  ; only difference is this one plays a KAT sample upon selection
  set_op_pos_to_0_alt:
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  LDA #$00
  STA options_position
  RTS

  opt_position_lo:
  .lobytes opt_position_1, opt_position_2, opt_position_3, opt_position_4, opt_position_5
  .lobytes opt_position_6, opt_position_7, opt_position_8, opt_position_9, opt_position_10

  opt_position_hi:
  .hibytes opt_position_1, opt_position_2, opt_position_3, opt_position_4, opt_position_5
  .hibytes opt_position_6, opt_position_7, opt_position_8, opt_position_9, opt_position_10

  opt_position_1: ; TYPE-A
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$36
  STA $247 ; set X to $36
  LDA #$77
  STA cursor_sett_Y ; set Y to $77

  LDA #$00 ; set attribute to $00
  STA $246
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+
  LDA #$00 ; ; set controller to $00
  STA controller
  :
  RTS

  opt_position_2: ; TYPE-C
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$36
  STA $247 ; set X to $36
  LDA #$87
  STA cursor_sett_Y ; set Y to $87

  LDA #$00 ; set attribute to $00
  STA $246
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+
  LDA #$02 ; ; set controller to $02
  STA controller
  :
  RTS

  opt_position_3: ; AUTOPLAY [ ]
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$88
  STA $247 ; set X to $88
  LDA #$B6
  STA cursor_sett_Y ; set Y to $B6

  LDA #$40
  STA $246 ; flip arrow horizontally (arrow pointing right)

  LDA #$00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+

  ; flip bit 0 in mods
  LDA mods
  EOR #%00000001
  STA mods
  :
  RTS

  opt_position_4: ; INVISIBLE [ ]
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$88
  STA $247 ; set X to $88
  LDA #$BE
  STA cursor_sett_Y ; set Y to $BE

  LDA #$40
  STA $246 ; flip arrow horizontally (arrow pointing right)

  LDA #$00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+

  ; flip bit 1 in mods
  LDA mods
  EOR #%00000010
  STA mods
  :
  RTS

  opt_position_5: ; FLIPPED DRUMS [ ]
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$88
  STA $247 ; set X to $88
  LDA #$C6
  STA cursor_sett_Y ; set Y to $C6

  LDA #$40
  STA $246 ; flip arrow horizontally (arrow pointing right)

  LDA #$00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+

  ; flip bit 2 in mods
  LDA mods
  EOR #%00000100
  STA mods
  :
  RTS

  opt_position_6: ; FLIPPED SPEED [ ]
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$88
  STA $247 ; set X to $88
  LDA #$CE
  STA cursor_sett_Y ; set Y to $CE

  LDA #$40
  STA $246 ; flip arrow horizontally (arrow pointing right)

  LDA #$00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+

  ; flip bit 3 in mods
  LDA mods
  EOR #%00001000
  STA mods
  :
  RTS

  opt_position_7: ; TYPE-B
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$86
  STA $247 ; set X to $86
  LDA #$77
  STA cursor_sett_Y ; set Y to $77

  LDA #$00
  STA $246 ; set attribute to $00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+
  LDA #$01
  STA controller ; set controller to $01
  :
  RTS

  opt_position_8: ; TYPE-D
  LDA #$64
	STA $245 ; set the tile to $64 (arrow pointing left)

  LDA #$86
  STA $247 ; set X to $86
  LDA #$87
  STA cursor_sett_Y ; set Y to $97

  LDA #$00
  STA $246 ; set attribute to $00
  STA $249 ; set 2nd tile to $00 (blank)

  JSR press_A ; upon pressing A
  BEQ :+
  LDA #$03
  STA controller ; set controller to $03
  :
  RTS

  opt_position_9: ; color picker left
  LDA #$00 ; make the palette a priority instead of the bg in vblank
  STA draw_bg_over_palette

  LDA #$AC
  STA $247 ; set X to tile 1
  STA $24B ; and tile 2 to $AC
  LDA #$AF
  STA cursor_sett_Y ; set Y to $AF

  LDA #$6C
  STA $245 ; set tile 1 and tile 2
  STA $249 ; to $6C (arrow pointing down)

  LDA #$80
  STA $24A ; vertically flip tile 2 (arrow pointing up)

  JSR press_A ; upon pressing A
  BEQ :+

  ; flip bit 0 in in_color_set
  ; so the player can choose their drum color
  LDA in_color_set
  EOR #$01
  STA in_color_set
  :

  LDA in_color_set ; if in_color_set is $00
  BEQ skip_color_ud ; dont run the color setting code

  LDA BTN_Press ; load a button press to A
  AND #BTN_UP ; check for UP
  BEQ :+ ; if it isnt pressed, dont change the color
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  INC don_color_pos ; increase don_color_pos
  LDA don_color_pos ; load don_color_pos to A
  CMP #$34 ; if its higher than $33
  BCC :+
  LDA #$00 ; set don_color_pos to $00
  STA don_color_pos ; to prevent setting unintentional color values
  :

  LDA BTN_Press ; load a button press to A
  AND #BTN_DOWN ; check for DOWN
  BEQ :+ ; if it isnt pressed, dont change the color
  LDA #$04 ; play KAT sample
  JSR famistudio_sfx_sample_play
  DEC don_color_pos ; decrease don_color_pos
  LDA don_color_pos ; load don_color_pos to A
  BPL :+ ; if its below $80
  LDA #$33 ; set don_color_pos to $33
  STA don_color_pos ; to prevent setting unintentional color values
  :

  skip_color_ud:

  LDA in_color_set ; if in_color_set is $00
  BEQ :+ ; leave subroutine
  LDA beat_anim_frame ; and if beat_anim_frame is $00
  BEQ :+ ; also leave subroutine
  LDA #$00 ; blank both tile 1 and tile 2 so it flashes
  STA $245
  STA $249
  :
  RTS

  opt_position_10:
  LDA #$00 ; make the palette a priority instead of the bg in vblank
  STA draw_bg_over_palette

  LDA #$CC
  STA $247 ; set X to tile 1
  STA $24B ; and tile 2 to $CC
  LDA #$AF
  STA cursor_sett_Y ; set Y to $AF

  LDA #$6C
  STA $245 ; set tile 1 and tile 2
  STA $249 ; to $6C (arrow pointing down)

  LDA #$80
  STA $24A ; vertically flip tile 2 (arrow pointing up)

  ; basically same code as in opt_position_9
  JSR press_A
  BEQ :+
  LDA in_color_set
  EOR #$01
  STA in_color_set
  :

  LDA in_color_set
  BEQ skip_color_ud2

  LDA BTN_Press
  AND #BTN_UP
  BEQ :+
  LDA #$04
  JSR famistudio_sfx_sample_play
  INC don_color_pos+1
  LDA don_color_pos+1
  CMP #$34
  BCC :+
  LDA #$00
  STA don_color_pos+1
  :

  LDA BTN_Press
  AND #BTN_DOWN
  BEQ :+
  LDA #$04
  JSR famistudio_sfx_sample_play
  DEC don_color_pos+1
  LDA don_color_pos+1
  BPL :+
  LDA #$33
  STA don_color_pos+1
  :

  skip_color_ud2:

  LDA in_color_set
  BEQ :+
  LDA beat_anim_frame
  BEQ :+
  LDA #$00
  STA $245
  STA $249
  :
  RTS

  press_A:
  LDA BTN_Press
  AND #BTN_A
  RTS

  update_controller_type:
  ; prepare PPU locations for the controller TYPE text attributes
  LDA #$02
  STA draw+8
  STA draw+9
  STA draw+13
  STA draw+16
  STA draw+17
  STA draw+21
  LDA #$27
  STA draw+10
  STA draw+18
  LDA #$DA
  STA draw+11
  LDA #$E2
  STA draw+19
  LDA #$AA
  STA draw+12
  STA draw+15
  STA draw+20
  STA draw+23

  LDA #$03
  STA draw+14
  STA draw+22



  LDA controller ; load controller to A
  BEQ type_a ; if its $00, jump to type_a
  CMP #$01 ; if its $01
  BEQ type_b ; jump to type_b
  CMP #$02 ; if its $02
  BEQ type_c ; jump to type_c
  ; otherwise
  ; type_d

  LDA #$A5 ; set draw+23 to $A5
  STA draw+23 ; (proper attributes)

  ; set specific sprites to use red circles instead of blue
  LDA #$74
  STA $26D ; B
  STA $271 ; A
  RTS

  type_a:
  LDA #$5A ; set draw+23 to $5A
  STA draw+12 ; (proper attributes)

  ; set specific sprites to use red circles instead of blue
  LDA #$74
  STA $25D ; UP
  STA $265 ; RIGHT
  STA $26D ; B
  RTS

  type_b:
  LDA #$5A ; set draw+23 to $5A
  STA draw+15 ; (proper attributes)

  ; set specific sprites to use red circles instead of blue
  LDA #$74
  STA $261 ; LEFT
  STA $269 ; DOWN
  STA $271 ; A
  RTS

  type_c:
  LDA #$A5 ; set draw+23 to $A5
  STA draw+20 ; (proper attributes)

  ; set specific sprites to use red circles instead of blue
  LDA #$74
  STA $25D ; UP
  STA $261 ; LEFT
  STA $265 ; RIGHT
  STA $269 ; DOWN
  RTS
.endproc

byte_01:
.byte $01

MAX_SONG_COUNT = $05

.proc song_cursor
  LDA song_sel_cursor_time ; load song_sel_cursor_time to A
  CMP #19 ; check if its 19
  BNE :+ ; if it isnt, skip song initialize code

  ; set up PRG-ROM banks
  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song
  LDA #$02 ; play DON sample
  JSR famistudio_sfx_sample_play
  :

  LDA BTN_Hold ; load a button hold to A
  AND #%00000011 ; check for LEFT and RIGHT
  BNE :+
  LDA #$00 ; if neither are being held
  STA song_sel_cursor_time ; set song_sel_cursor_time to $00
  :

  LDA BTN_Hold ; load a button hold to A
  AND #BTN_LEFT ; check for LEFT
  BEQ :++ ; if its being held, skip some code
  LDA song_sel_cursor_time ; load song_sel_cursor_time to A
  BNE :+ ; if its not $00, skip some code

  LDA #20
  STA song_sel_cursor_time ; set song_sel_cursor_time and
  STA song_sel_position+2 ; song_sel_position+2 to $20

  DEC song_sel_position ; decrease song_sel_position
  LDA song_sel_position ; load song_sel_position to A
  CMP #$FF ; check if its $FF
  BNE :+ ; if its not, skip some code
  LDA #MAX_SONG_COUNT ; set song_sel_position to MAX_SONG_COUNT ($05)
  STA song_sel_position ; to prevent underflow (not BPL so there can be potentially more songs ig)
  :
  DEC song_sel_cursor_time ; decrease song_sel_cursor_time
  JMP update_cursor_sprite ; jump to update_cursor_sprite

  :
  LDA BTN_Hold ; load a button hold to A
  AND #BTN_RIGHT ; check for RIGHT
  BNE :+ ; if its not being held
  JMP update_cursor_sprite ; jump to update_cursor_sprite

  :
  LDA song_sel_cursor_time ; load song_sel_cursor_time to A
  BNE :+ ; if its not $00, skip some code

  LDA #20
  STA song_sel_cursor_time ; set song_sel_cursor_time and
  STA song_sel_position+2 ; song_sel_position+2 to $20

  INC song_sel_position ; increase song_sel_position
  LDA song_sel_position ; load song_sel_position to A
  CMP #MAX_SONG_COUNT+1 ; compare with MAX_SONG_COUNT+1
  BCC :+ ; if its lower, skip some code
  LDA #$00 ; set song_sel_position to $00
  STA song_sel_position ; to prevent overflow
  :
  DEC song_sel_cursor_time ; decrease song_sel_cursor_time

  update_cursor_sprite:
  LDA #$6C
  STA $205 ; set tile to $6C (arrow pointing down)
  LDA #$00
  STA $206 ; potentially clear leftover attributes

  LDA #BASE_CURSOR_X_POSITION_SONG_SEL ; load BASE_CURSOR_X_POSITION_SONG_SEL ($28) to A
  LDX song_sel_position ; load song_sel_position to X
  CLC ; clear carry just in case

  loop_ucs:
  BEQ leave_lucs ; if X is $00, leave loop
  ADC #$20 ; add $20 to A
  DEX ; decrease X
  BNE loop_ucs ; repeat, unless its $00

  leave_lucs:
  STA $207 ; store result of A to $207 (X position)
  RTS

  BASE_CURSOR_X_POSITION_SONG_SEL = $28
.endproc

.proc diff_cursor
  LDA diff_sel_cursor_time ; load diff_sel_cursor_time to A
  CMP #19 ; check if its #19
  BNE :+ ; if its not $00, dont play sample

  ; play KAT sample
  LDA #$04
  JSR famistudio_sfx_sample_play
  :

  LDX song_sel_position ; load song_sel_position to X
  ; for offsets because each song has its own difficulty select

  LDA BTN_Hold ; load a button hold to A
  AND #%00000011 ; check for LEFT and RIGHT
  BNE :+ ; if neither of them are held
  LDA #$00 ; set diff_sel_cursor_time to $00
  STA diff_sel_cursor_time
  :

  LDA BTN_Hold ; load a button hold to A
  AND #BTN_LEFT ; check for LEFT
  BEQ :++ ; if its not being held, skip some code
  LDA diff_sel_cursor_time ; load diff_sel_cursor_time to A
  BNE :+ ; if its not $00, skip some code

  LDA #20
  STA diff_sel_cursor_time ; set diff_sel_cursor_time to $20

  DEC diff_sel_position, X ; decrease diff_sel_position + X
  LDA diff_sel_position, X ; decrease diff_sel_position + X
  BPL :+ ; check if A is below $80 (BPL and not CMP #$FF because why 254 difficulties)
  LDA #03 ; if it isnt
  STA diff_sel_position, X ; set diff_sel_position + X to 3
  :
  DEC diff_sel_cursor_time ; decrease diff_sel_cursor_tim

  ; updates the sram location for saving high scores
  JSR update_sram_loc

  LDA frame_timer_score_draw ; load frame_timer_score_draw to A
  CMP #121 ; if its smaller than #121
  BCC draw_godr_1 ; jump to draw_godr_1

  LDA #$01 ; make the bg a priority in vblank and not the palette
  STA draw_bg_over_palette

  ; loads the proper high score tiles
  JSR load_score_combo
  JMP escape_lsc_1 ; jump to escape_lsc_1
  draw_godr_1:

  ; loads the seconds part of the proper high score tiles
  JSR load_score_inputs
  escape_lsc_1:
  LDX song_sel_position ; load song_sel_position to X

  JMP update_cursor_sprite ; jump to update_cursor_sprite

  :
  LDA BTN_Hold ; load a button hold to A
  AND #BTN_RIGHT ; check for RIGHT
  BNE :+ ; if its not being held
  ; jump to update_cursor_sprite
  JMP update_cursor_sprite

  :

  LDA diff_sel_cursor_time ; load diff_sel_cursor_time to A
  BNE :+ ; if its not $00, skip some code

  LDA #20
  STA diff_sel_cursor_time ; set diff_sel_cursor_time to $20

  INC diff_sel_position, X ; increase diff_sel_position + X
  LDA diff_sel_position, X ; load diff_sel_position + X to A
  CMP #04 ; check if its smaller than 4
  BCC :+ ; if it isnt
  LDA #$00 ; set diff_sel_position + X to $00
  STA diff_sel_position, X ; to prevent overflow
  :
  DEC diff_sel_cursor_time ; decrease diff_sel_cursor_time

  ; updates the sram location for saving high scores
  JSR update_sram_loc

  LDA frame_timer_score_draw ; load frame_timer_score_draw to A
  CMP #121 ; if its smaller than #121
  BCC draw_godr_2 ; jump to draw_godr_2

  LDA #$01 ; make the bg a priority in vblank and not the palette
  STA draw_bg_over_palette

  ; loads the seconds part of the proper high score tiles
  JSR load_score_combo
  JMP escape_lsc_2 ; jump to escape_lsc_2
  draw_godr_2:

  ; loads the seconds part of the proper high score tiles
  JSR load_score_inputs
  escape_lsc_2:
  LDX song_sel_position ; load song_sel_position to X

  update_cursor_sprite:
  LDA #$6C
  STA $241 ; set tile to $6C (arrow pointing down)

  LDA #BASE_CURSOR_X_POSITION_DIFF_SEL ; load BASE_CURSOR_X_POSITION_DIFF_SEL ($40) to A
  LDY diff_sel_position, X ; load diff_sel_position + X to Y
  CLC ; clear carry just in case

  loop_ucs:
  BEQ leave_lucs ; if Y is $00, leave loop
  ADC #$28 ; add $28 to A
  DEY ; decrease Y
  BNE loop_ucs ; repeat, unless its $00

  leave_lucs:
  STA $243 ; store result of A to $243 (X position)
  RTS

  BASE_CURSOR_X_POSITION_DIFF_SEL = $40
.endproc

	c_h_base_sprite = $208
	drum_sel_base_sprite = $218
	diff_icon_base_sprtie = $220

.proc update_controller_highlight ; and that donchan icon and the cursors
; future deni here: basiaclly almost every sprite
  LDA PPUSCROLL_Y_speed ; load PPUSCROLL_Y_speed to A
  BPL :+ ; if its above $80
  DEC PPUSCROLL_Y_speed ; decrease PPUSCROLL_Y_speed
  :

  ; load the controller button highlight
  LDX #$00 ; load $00 to X (prepare loop)
  load_c_h_sprites:
  LDA controller_highlight_sprite_data, X ; load controller_highlight_sprite_data + X to A
  STA c_h_base_sprite, X ; store A to c_h_base_sprite + X ($208 + X), basically loading sprite data
  INX ; increase X
  CPX #$10 ; repeat 16 times
  BNE load_c_h_sprites

  ; switch the visibility of it every half a second
  INC frame_timer_controller ; increase frame_timer_controller
  LDA frame_timer_controller ; load frame_timer_controller to A
  CMP #30 ; if its 30
  BNE :+ ; skip some code
  LDA #0
  STA frame_timer_controller ; set frame_timer_controller 0
  LDA beat_anim_frame
  EOR #$01 ; bit flip beat_anim_frame
  STA beat_anim_frame
  :

  ; load the small drum graphic
  LDX #$00 ; load $00 to X (prepare loop)
  load_drum_sel_sprites:
  LDA drum_sel_sprite_data, X ; load drum_sel_sprite_data + X to A
  STA drum_sel_base_sprite+1, X ; store A to drum_sel_base_sprite+1 + X ($218+1 + X), again loading sprite data ill stop mentioning that
  INX ; increase X
  CPX #$06 ; repeat 6 times
  BNE load_drum_sel_sprites

  ; add $08 to drum_sel_base_sprite+3
  LDA drum_sel_base_sprite+3
  CLC
  ADC #$08
  STA drum_sel_base_sprite+7

  ; load the difficulty icons
  LDX #$00 ; load $00 to X (prepare loop)
  load_difficulty_icons:
  LDA diff_icon_sprite_data, X ; load diff_icon_sprite_data + X to A
  STA diff_icon_base_sprtie, X ; store A to diff_icon_base_sprtie + X ($220 + X)
  INX ; increase X
  CPX #$20 ; repeat $20 times
  BNE load_difficulty_icons

  ; hell yeah i dont have to comment this because i already did
  ; update cursor (song) sprite Y
  LDA cursor_song_Y
  ; set to $F0 if screen isnt 0
  LDX cursor_song_screen
  BEQ :+
  LDA #$F0
  :
  STA $204

  ; update cursor (difficulty) sprite Y
  LDA cursor_diff_Y
  ; set to $F0 if screen isnt 0
  LDX cursor_diff_screen
  DEX
  BEQ :+
  LDA #$F0
  :
  STA $240

  ; update cursor (settings) sprite Y
  LDA color_sqr_Y
  ; set to $F0 if screen isnt 0
  LDX color_sqr_screen
  INX
  BEQ :+
  LDA #$F0
  :
  STA $24C
  STA $250
  STA $254
  STA $258


  ; update cursor (settings) sprite Y
  LDA cursor_sett_Y
  ; set to $F0 if screen isnt 0
  LDX cursor_sett_screen
  INX
  BEQ :+
  LDA #$F0
  :
  STA $244
  CPX #$00
  BNE :+
  SBC #$20
  :
  STA $248

  ; update controller type sprites Y
  LDA controller_t_Y
  ; set to $F0 if screen isnt 0
  LDX controller_t_screen
  INX
  BEQ :+
  LDA #$F0
  :
  STA $25C
  ADC #12
  BCC :+
  LDA #$F0
  :
  STA $260
  STA $264
  CLC
  ADC #12
  BCC :+
  LDA #$F0
  :
  STA $268
  STA $26C
  STA $270

  ; update controller highlight sprites Y
  LDA controller_h_Y
  STA c_h_base_sprite
  STA c_h_base_sprite+4
  CLC
  ADC #$02
  ; set to $F0 if screen isnt 0
  LDX controller_h_screen
  BEQ :+
  LDA #$F0
  STA c_h_base_sprite
  STA c_h_base_sprite+4
  :
  STA c_h_base_sprite+8
  STA c_h_base_sprite+12

  ; update donchan icon sprite Y
  LDA drum_sel_Y
  ; set to $F0 if screen isnt 0
  LDX drum_sel_screen
  BEQ :+
  LDA #$F0
  :
  STA drum_sel_base_sprite
  STA drum_sel_base_sprite+4

  ; update difficulty icon sprite Y
  LDA diff_icon_Y
  LDX diff_icon_screen
  DEX
  BEQ :+
  LDA #$F0
  :

  LDX #$00
  update_diff_icon_Y:
  STA diff_icon_base_sprtie, X
  INX
  INX
  INX
  INX
  CPX #$20
  BNE update_diff_icon_Y

  ; hell yeah i commented this mess already too
  LDX #$00 ; set X to $00
  scroll_selection_sprites:
  ; prepare sprites for overflow/underflow
  ; for the value $F0
  LDA cursor_diff_Y, X ; load cursor_diff_Y + X to A
  CLC
  ADC #$10 ; add $10 to A
  STA cursor_diff_Y, X ; store A to cursor_diff_Y + X

  LDY #$00 ; set Y to $00
  LDA PPUSCROLL_Y_speed ; load Y scroll speed to A
  BEQ dont_change_screen ; if its 0, dont bother with underflow/overflow checking
  BMI :+ ; if its scrolling up, run other code

  ; code for if its scrolling down
  DEY ; decrease Y
  LDA cursor_diff_Y, X ; load cursor_diff_Y + X to A
  SEC
  SBC PPUSCROLL_Y_speed ; subtract Y scroll speed value from A
  STA cursor_diff_Y, X ; store A to cursor_diff_Y + X
  ; this is so the sprite moves when scrolling
  BCS dont_change_screen ; if it didnt underflow, dont run underflow code
  ADC #$F0 ; add $F0 to A (subtract $10)
  STA cursor_diff_Y, X ; store A to cursor_diff_Y + X
  JMP :++ ; jump to screen changing code

  ; code for if its scrolling up
  :
  DEC cursor_diff_Y, X ; decrease cursor_diff_Y, X
  INY ; increase Y
  LDA cursor_diff_Y, X ; load cursor_diff_Y + X to A
  SEC
  SBC PPUSCROLL_Y_speed ; subtract Y scroll speed value from A
  STA cursor_diff_Y, X ; store A to cursor_diff_Y + X
  BCC dont_change_screen ; if it didnt overflow, dont run overflow code

  SBC #$F0 ; subtract $F0 (add $10)
  STA cursor_diff_Y, X ; store A to cursor_diff_Y + X
  :

  ; code for screen value changing
  STY temp_screen ; store Y to a temporary address
  LDA cursor_diff_screen, X ; load cursor_diff_screen + X to A
  CLC ; add or subtract $01 to/from A
  ADC temp_screen ; depends if its scrolling up or down
  STA cursor_diff_screen, X ; store A to load cursor_diff_screen + X

  dont_change_screen:
  ; restore the actual sprite Y values
  LDA cursor_diff_Y, X ; load cursor_diff_Y + X to A
  CLC
  ADC #$F0 ; add $F0 to A (subtract $10)
  STA cursor_diff_Y, X ; store A to load cursor_diff_Y + X

  INX ; increase X
  CPX #$08 ; repeat
  BNE scroll_selection_sprites ; until X is 7

  LDA beat_anim_frame ; load beat_anim_frame to A
  BNE :+ ; if its not $00, skip some code
  LDX #$00 ; load $00 to X (prepare loop)
  LDA #$F0 ; load $F0 to A (sprites above $F0 are hidden)
  unload_c_h_sprites:
  STA c_h_base_sprite, X ; store $F0 to c_h_base_sprite + X
  INX
  INX
  INX
  INX ; increase X 4 times
  CPX #$10 ; repeat 4 times (16 if only 1 INX)
  BNE unload_c_h_sprites
  :

  LDA PPUSCROLL_Y_speed ; load PPUSCROLL_Y_speed to A
  BPL :+ ; if its above $80
  INC PPUSCROLL_Y_speed ; increase PPUSCROLL_Y_speed
  :

  RTS
.endproc

.proc update_donchan_color
	LDX don_color_pos ; load don_color_pos to X
  LDA color_table, X ; load color_table + X to A (choose a color from the color table)
  STA don_color ; store it to don_color for the palette

  ; do the same thing again for the 2nd color
  LDX don_color_pos+1
  LDA color_table, X
  STA don_color+1

  ; store the color values to the palette
  LDA don_color
  STA palette+30
  LDA don_color+1
  STA palette+29
  LDA #$20 ; white
  STA palette+31
  RTS
.endproc

.proc update_diff_sel_loading
  LDA diff_sel_load_timer ; load diff_sel_load_timer to A
  BNE :+ ; if its $00

  RTS ; leave subroutine
  :

  LDX #$01 ; make the bg a priority in vblank and not the palette
  STX draw_bg_over_palette

  DEC diff_sel_load_timer ; decrease diff_sel_load_timer

  CMP #$03 ; check if diff_sel_load_timer is $03
  BNE :+
  JMP load_names ; if it is, jump to load_names (not direct branch because its too far away)

  :
  CMP #$02 ; check if diff_sel_load_timer is $02
  BNE :+
  JMP load_scores; if it is, jump to load_scores (not direct branch because its too far away)

  :

  ; otherwise
  ; load_stars

  ; because pressing a direction + start loads the name data too and i dont know why
  ; and im just lazy to fix it properly too-
  LDX #$00 ; load $00 to X (prepare loop)
  LDA #$00 ; load $00 to A
  clear_draw_stars:
  STA draw, X ; store A to draw
  INX
  CPX #$30 ; up until draw+47
  BNE clear_draw_stars

  ; prepare locations for star drawing
  LDX #$00
  ; load song position * 4
  LDA song_sel_position
  ASL
  ASL
  TAY ; transfer result to Y

  ; prepare PPU high
  LDA #$29
  STA draw+2
  STA draw+10
  STA draw+18
  STA draw+26
  ; prepare PPU low
  LDA #$08
  STA draw+3
  LDA #$0D
  STA draw+11
  LDA #$12
  STA draw+19
  LDA #$17
  STA draw+27
  ; prepare attributes
  LDA #%00000110
  STA draw+1
  STA draw+9
  STA draw+17
  STA draw+25
  LDA #%00000111
  STA draw+6
  STA draw+14
  STA draw+22
  STA draw+30
  ; prepare tiles
  LDA #$D3
  STA draw+4
  STA draw+12
  STA draw+20
  STA draw+28
  LDA #$D2
  STA draw+7
  STA draw+15
  STA draw+23
  STA draw+31

  draw_stars:
  LDA song_stars, Y ; load song_stars + Y to A
  BNE :+ ; if its not $00, skip
  LDA #$CD
  STA draw+7, X ; set draw+7 + X to $CD (final tile)
  LDA #$01
  STA draw+5, X ; set draw+5 + X to $01 (bg tile)
  LDA #$0A ; load $0A to A
  BNE :+++ ; skip some code (branch because less bytes than JMP)
  :
  STA draw+5, X ; store song_stars + Y to draw + 5 + X
  CLC ; clear carry?
  SBC #$0A ; subtract $09 from A (not $0A because the carry flag is adding an extra 1)
  EOR #$FF ; flip all bits in A
  BNE :++ ; if its not $00, skip some code what even is happening i dont remember-
  LDA #$D2
  STA draw+7, X ; set draw+7 + X to $D2 (filled stars)
  LDA #$CA
  STA draw+4, X ; set draw+4 + X to $CA (bg tile)
  LDA #$0A
  STA draw+5, X ; set draw+5 + X and draw+3 + X
  LDA draw+3, X ; to $0A (uh idk..)
  EOR #$80 ; flip bit 7
  SEC ; now set carry finally
  SBC #$20 ; subtract $20 from A
  EOR #$80 ; flip bit 7 again ooooh overflow/underflow detection
  BVC :+
  DEC draw+2, X ; if it overflowed, decrease draw+2 + X
  :
  STA draw+3, X ; store the result in A to draw+3 + X
  LDA #$01 ; load $01 to A
  :
  STA draw+0, X ; store A to draw+0 + X i know thats length im writing this at 1:38AM
  INY ; increase Y
  TXA ; transfer X to A
  CLC
  ADC #$08 ; add $08 to A
  TAX ; transfer A to X oh basically add $08 to X i see
  CPX #$20 ; repeat 4 times
  BNE draw_stars ; this is what happens when you dont comment code as youre writing it, you forget stuff

  RTS ; leave subroutine, i dont wanna go through this code again just know that this draws the stars idk....

  load_names:
  LDX #$00 ; load $00 to X (prepare loop)
  LDA #$00 ; load $00 to A
  clear_draw:
  STA draw, X ; store $00 to draw + X
  INX ; increase X
  BPL clear_draw ; repeat 128 times

  ; prepare PPU high
  LDA #$2B
  STA draw+2
  STA draw+18
  ; prepare PPU low
  LDA #$0F
  STA draw+3
  ORA #$20
  STA draw+19
  ; prepare attributes
  LDA #$00
  STA draw+1
  STA draw+17
  ; prepare length
  LDA #12
  STA draw+0
  STA draw+16

  LDX song_sel_position ; load song_sel_position to X
  LDA #$F4 ; load $F4 to A
  LDY #$00 ; load $00 to Y
  :
  CLC ; clear carry due to overflow stuff
  ADC #12 ; add 12 to A
  DEX ; decrease X
  BPL :- ; repeat until X is above $00

  TAX ; transfer the result to X

  draw_names:
  LDA song_author_1, X ; load song_author_1 + X to A
  STA draw+4, Y ; store A to draw+4 + Y
  LDA song_chartr_1, X ; load song_chartr_1 + X to A
  STA draw+20, Y ; store A to draw+20 + Y
  INX ; increase X
  INY ; and Y
  CPY #12 ; repeat 12 times
  BNE draw_names

  RTS
.endproc

  update_sram_loc:
  LDA #$5F
  STA sram_location+1 ; set sram_location+1 to $5F (high byte)
  LDA #$80
  STA sram_location ; set sram_location to $80 (low byte)

  LDX song_sel_position ; load song_sel_position to X
  LDY diff_sel_position, X ; load diff_sel_position + X to Y

  LDA sram_location ; load sram_location to A
  set_sram_loc:
  CLC ; clear carry because overflow
  ADC #128 ; add #128 to A
  BCC :+
  INC sram_location+1 ; if it overflowed, increase sram_location+1
  :
  DEX ; decrease X
  BPL set_sram_loc ; repeat until X is $FF

  set_sram_loc_low:
  CLC ; clear carry because overflow
  ADC #32 ; add #32 to A
  BCC :+
  INC sram_location+1 ; if it overflowed, increase sram_location+1
  :
  DEY ; decrease Y
  BPL set_sram_loc_low ; repeat until Y is $FF
  STA sram_location ; store result in A to sram_location
  ; the starting sram location is actually $6020 and not $5F80

  LDY #$00 ; load $00 to Y (prepare loop)
  load_to_draw_score:
  LDA (sram_location), Y ; load the value + Y defined by sram_location to A
  STA score_to_draw, Y ; store A to score_to_draw + Y
  INY ; increase Y
  CPY #23 ; repeat 23 times
  BNE load_to_draw_score
  RTS ; leave subroutine

  load_scores:
  JSR update_sram_loc ; run the update_sram_loc subroutine

  LDA #240
  STA frame_timer_score_draw ; set frame_timer_score_draw to 240

  JMP load_score_combo ; jump to load_score_combo

  update_top_scores:
  LDA song_sel_entry ; load song_sel_entry to A
  CMP #$02 ; if its not $02
  BEQ :+
  RTS ; leave subroutine
  :

  DEC frame_timer_score_draw ; decrease frame_timer_score_draw
  LDA frame_timer_score_draw ; load frame_timer_score_draw to A
  BNE :+ ; if its $00
  LDA #240
  STA frame_timer_score_draw ; reset frame_timer_score_draw to 240
  :

  CMP #120 ; if its $120
  BNE :+
  JMP load_score_inputs ; jump to load_score_inputs
  :

  CMP #240 ; if its 240
  BEQ :+
  RTS ; leave subroutine
  :

  LDX #$01 ; make the bg a priority in vblank and not the palette
  STX draw_bg_over_palette

  load_score_combo:

  LDA #$02 ; load $02 to A
  LDY #$00 ; laod $00 to Y (prepare loop)
  draw_blank_tiles:
  STA draw+4, Y ; store A to draw+4 + Y
  STA draw+28, Y ; and draw+28 + Y
  INY ; increase Y
  CPY #20 ; repeat 20 times
  BNE draw_blank_tiles

  ; prepare PPU high
  LDA #$2A
  STA draw+2
  STA draw+26
  ; prepare PPU low
  LDA #$A6
  STA draw+3
  LDA #$C6
  STA draw+27
  ; prepare attributes
  LDA #$00
  STA draw+1
  STA draw+25
  ; prepare length
  LDA #20
  STA draw+0
  STA draw+24

  ; a lot of loops im too tired to comment this atp i just wanna be done im so sorry
  LDY #$00
  prepare_tiles_score_text:
  LDA score_text, Y
  STA draw+5, Y
  INY
  CPY #10
  BNE prepare_tiles_score_text

  LDY #$00
  prepare_tiles_combo_text:
  LDA combo_text, Y
  STA draw+29, Y
  INY
  CPY #10
  BNE prepare_tiles_combo_text

  LDY #$00
  draw_top_score:
  LDA score_to_draw, Y
  CLC
  ADC #$5A
  STA draw+15, Y
  INY
  CPY #06
  BNE draw_top_score

  LDY #$00
  draw_top_combo:
  LDA combo_to_draw, Y
  CLC
  ADC #$5A
  STA draw+39, Y
  INY
  CPY #04
  BNE draw_top_combo

  LDA #$5A
  STA draw+21
  RTS

  load_score_inputs:
  LDX #$01
  STX draw_bg_over_palette

  ; prepare PPU high
  LDA #$2A
  STA draw+2
  STA draw+26
  ; prepare PPU low
  LDA #$A6
  STA draw+3
  LDA #$C6
  STA draw+27
  ; prepare attributes
  LDA #$00
  STA draw+1
  STA draw+25
  ; prepare length
  LDA #20
  STA draw+0
  STA draw+24

  LDX #$00
  load_text_good_bad:
  LDA good_text, X
  STA draw+4, X
  LDA bad_text, X
  STA draw+28, X
  INX
  CPX #$05
  BNE load_text_good_bad

  LDX #$00
  load_score_good:
  LDA good_to_draw, X
  CLC
  ADC #$5A
  STA draw+9, X
  INX
  CPX #$04
  BNE load_score_good

  LDX #$00
  load_score_bad:
  LDA bad_to_draw, X
  CLC
  ADC #$5A
  STA draw+33, X
  INX
  CPX #$04
  BNE load_score_bad

  LDX #$00
  load_text_ok_roll:
  LDA ok_text, X
  STA draw+13, X
  LDA roll_text, X
  STA draw+37, X
  INX
  CPX #$07
  BNE load_text_ok_roll

  LDX #$00
  load_score_ok:
  LDA okay_to_draw, X
  CLC
  ADC #$5A
  STA draw+20, X
  INX
  CPX #$04
  BNE load_score_ok

  LDX #$00
  load_score_roll:
  LDA roll_to_draw, X
  CLC
  ADC #$5A
  STA draw+44, X
  INX
  CPX #$04
  BNE load_score_roll

  ; end of lotsa loops
  RTS

.proc update_controls
	LDA controller ; load controller to A
  BEQ type_a ; if its $00, jump to type_a
  CMP #$01 ; if its $01
  BEQ type_b ; jump to type_b
  CMP #$02 ; if its $02
  BEQ type_c ; jump to type_c
  ; otherwise
  ;type_d

  ; all of these below are just loading the proper buttons matching the controller type
  ; im not also gonna bother commenting this sorry

  LDA #%00000101
  STA don_inputs
  LDA #%00001010
  STA don_inputs+1

  LDA #%10000000
  STA kat_inputs
  LDA #%01000000
  STA kat_inputs+1
  RTS

  type_a:
  LDA #%10000000
  STA don_inputs
  LDA #%00000110
  STA don_inputs+1

  LDA #%01000000
  STA kat_inputs
  LDA #%00001001
  STA kat_inputs+1
  RTS

  type_b:
  LDA #%01000000
  STA don_inputs
  LDA #%00001001
  STA don_inputs+1

  LDA #%10000000
  STA kat_inputs
  LDA #%00000110
  STA kat_inputs+1
  RTS

  type_c:
  LDA #%10000000
  STA don_inputs
  LDA #%01000000
  STA don_inputs+1

  LDA #%00000101
  STA kat_inputs
  LDA #%00001010
  STA kat_inputs+1
  RTS
.endproc
; oke done finally
; its 2:07AM

  score_text: ; TOP SCORE:
  .byte $53, $4E, $4F, $02, $52, $42, $4E, $51, $44, $64

  combo_text: ; TOP COMBO:
  .byte $53, $4E, $4F, $02, $42, $4E, $4C, $41, $4E, $64

  good_text: ; GOOD:
  .byte $46, $4E, $4E, $43, $64

  ok_text: ; OK:
  .byte $02, $02, $02, $02, $4E, $4A, $64

  bad_text: ; BAD:
  .byte $02, $41, $40, $43, $64

  roll_text: ; ROLL:
  .byte $02, $02, $51, $4E, $4B, $4B, $64

  Y_scroll_table:
  .byte $FF, $01, $02, $0B, $11, $2F, $44, $5E

  controller_highlight_sprite_data:
  .byte $D9, $66, $00, $9E, $D9, $66, $00, $A5, $DB, $68, $00, $B4, $DB, $6A, $00, $C4

  drum_sel_sprite_data:
  .byte $10, $03, $74, $00, $12, $03

  diff_icon_sprite_data:
  .byte $2E, $94, $01, $3C, $2E, $94, $41, $44, $2E, $98, $02, $8C, $2E, $98, $42, $94
  .byte $2E, $96, $02, $64, $2E, $96, $42, $6C, $2E, $9A, $01, $B4, $2E, $9A, $41, $BC

  color_square_sprite_data:
  .byte $70, $03, $A8, $9F, $70, $03, $B0, $9F, $6E, $03, $C8, $9F, $6E, $03, $D0

  controller_type_sprite_data:
  .byte $72, $00, $3B, $48, $72, $00, $2E, $48, $72, $00, $48, $54, $72, $00, $3B
  .byte $54, $72, $00, $A0, $54, $72, $00, $C0

  color_table:
  .byte $0C, $1C, $2C, $3C ; cyan
  .byte $01, $11, $21, $31 ; azure
  .byte $02, $12, $22, $32 ; blue
  .byte $03, $13, $23, $33 ; violet
  .byte $04, $14, $24, $34 ; magenta
  .byte $05, $15, $25, $35 ; rose
  .byte $06, $16, $26, $36 ; red
  .byte $07, $17, $27, $37 ; orange
  .byte $08, $18, $28, $38 ; yellow
  .byte $09, $19, $29, $39 ; chartreuse
  .byte $0A, $1A, $2A, $3A ; green
  .byte $0B, $1B, $2B, $3B ; spring
  .byte $2D, $00, $10, $3D ; gray
  ; names from nesdev

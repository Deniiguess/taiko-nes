.include "../song_info.asm"

.proc song_sel
  LDX #$00
  clear_draw:
  LDA #$00
  STA draw, X
  INX
  BPL clear_draw

  JSR update_START
  JSR update_B
  JSR update_SEL

  JSR update_cursor_position

  JSR update_song_select_value

  JSR update_pauses

  JSR update_Y_scroll

  JSR update_controller_highlight

  JSR update_donchan_color

  JSR update_diff_sel_loading

  JSR update_top_scores

  JMP stay_here
.endproc

.proc update_pauses
  LDA ts_ss_timer+1
  BNE :+
  RTS

  :

  INC ts_ss_timer+1
  CMP #20
  BNE :+

  LDA #$02
  JSR famistudio_sfx_sample_play

  :
  CMP #182
  BNE dont_load_main_game

  LDX song_sel_position
  LDY diff_sel_position, X
  CPX #$00
  BEQ :+
  LDA #$00
  CLC
  add_to_chart_start:
  ADC #$04
  DEX
  BNE add_to_chart_start

  TAX
  :

  BEQ :+
  add_to_chart_diff:
  INX
  DEY
  BNE add_to_chart_diff
  :

  LDA song_address_start_lo, X
  STA drum_bank_positon

  LDA song_address_start_hi, X
  STA drum_bank_positon+1

  JMP load_main_game
  dont_load_main_game:

  RTS
.endproc

.proc update_START
  LDA ts_ss_timer+1
  BNE :+++

  LDA song_sel_entry+1
  BNE :++

  LDA BTN_Press
  AND #%10010000
  BEQ :+++

  LDA #$03
  JSR famistudio_sfx_sample_play

  INC song_sel_entry
  LDA song_sel_entry
  CMP #$01
  BEQ :+
  CMP #$02
  BNE :+++
  :
  LDA #$07
  STA song_sel_entry+1

  LDA song_sel_entry
  CMP #$02
  BNE :+
  LDA #$E0
  STA $D000
  LDA #$0A
  STA $B800

  LDA #$03
  STA diff_sel_load_timer
  LDA #240
  STA frame_timer_score_draw
  :

  RTS
  :
  CMP #$03
  BNE :++

  LDA ts_ss_timer+1
  BNE :+
  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  LDA #$03
  JSR famistudio_sfx_sample_play
  :

  INC ts_ss_timer+1

  LDA #121
  STA ts_ss_timer

  LDA #$80
  STA song_sel_position+2
  :
  RTS
.endproc

update_B:
  LDA song_sel_entry
  CMP #$02
  BNE :+

  LDA BTN_Press
  AND #BTN_B
  BEQ :+

  down:

  LDA song_sel_entry+1
  BNE :+

  LDA #$87
  STA song_sel_entry+1

  DEC song_sel_entry

  LDA #$03
  JSR famistudio_sfx_sample_play
  :
  RTS

update_SEL:
  LDA song_sel_entry
  CMP #$01
  BNE :+

  LDA BTN_Press
  AND #BTN_SELECT
  BEQ :+

  LDA #$E1
  STA $D000
  LDA #$0B
  STA $B800

  JMP down

  :
  RTS


.proc update_song_select_value
  LDA ts_ss_timer
  CMP #100
  BCS :+

  INC ts_ss_timer
  RTS

  :

  CMP #100
  BNE :+++

  LDA song_sel_position+2
  AND #$7F
  BEQ :+
  DEC song_sel_position+2
  RTS
  :

  LDA song_sel_position
  CMP song_sel_position+1
  BEQ :++

  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song

  LDA #20
  STA song_sel_position+2

  JSR famistudio_music_stop

  LDA song_sel_position+1
  CMP #$FF
  BEQ :+
  :

  LDA song_sel_position
  STA song_sel_position+1
  :

  LDA song_sel_position+2
  BNE :+
  BMI :+
  ORA #$80
  STA song_sel_position+2
  LDA song_sel_position
  JSR famistudio_music_play
  :
  RTS
.endproc

.proc update_Y_scroll
  LDA song_sel_entry+1
  AND #$7F
  TAX
  BEQ :+
  LDA song_sel_entry+1
  AND #$80
  BNE :+
  :

  LDA Y_scroll_table, X
  PHA
  LDA song_sel_entry+1
  AND #$80
  BNE :+
  PLA
  EOR #$FF
  PHA
  :
  PLA
  STA PPUSCROLL_Y_speed
  BEQ :+
  DEC song_sel_entry+1
  :

  LDA song_sel_entry+1
  CMP #$80
  BNE :+
  ASL
  STA song_sel_entry+1
  :

  LDA PPUSCROLL_Y_speed
  BPL :+
  INC PPUSCROLL_Y_speed
  :
  RTS
.endproc

.proc update_cursor_position
  LDA PPUSCROLL_Y
  BEQ :+
  RTS
  :

  LDX song_sel_entry
  LDA cursor_code_lo, X
  STA address_table
  LDA cursor_code_hi, X
  STA address_table+1
  JMP (address_table)

  cursor_code_lo:
  .lobytes options_cursor, song_cursor, diff_cursor, nothing
  cursor_code_hi:
  .hibytes options_cursor, song_cursor, diff_cursor, nothing

  nothing:
  RTS
.endproc

.proc options_cursor
  LDA #$01
  STA draw_bg_over_palette

  LDA #$04
  STA draw
  LDA #$04
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

  LDX #$00
  LDA mods

  check_mods:
  BIT byte_01
  BEQ :+

  TAY
  LDA #$F7
  STA draw+4, X
  TYA

  :
  ROR
  INX
  CPX #$04
  BNE check_mods

  ROL
  ROL
  ROL
  ROL

  RTS
.endproc

byte_01:
.byte $01

MAX_SONG_COUNT = $05

.proc song_cursor
  LDA song_sel_cursor_time
  CMP #19
  BNE :+

  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song
  LDA #$02
  JSR famistudio_sfx_sample_play
  :

  LDA BTN_Hold
  AND #%00000011
  BNE :+
  LDA #$00
  STA song_sel_cursor_time
  :

  LDA BTN_Hold
  AND #BTN_LEFT
  BEQ :++
  LDA song_sel_cursor_time
  BNE :+

  LDA #20
  STA song_sel_cursor_time
  LDA #20
  STA song_sel_position+2

  DEC song_sel_position
  LDA song_sel_position
  CMP #$FF
  BNE :+
  LDA #MAX_SONG_COUNT
  STA song_sel_position
  :
  DEC song_sel_cursor_time
  JMP update_cursor_sprite

  :
  LDA BTN_Hold
  AND #BTN_RIGHT
  BNE :+
  JMP update_cursor_sprite

  :
  LDA song_sel_cursor_time
  BNE :+

  LDA #20
  STA song_sel_cursor_time
  LDA #20
  STA song_sel_position+2

  INC song_sel_position
  LDA song_sel_position
  CMP #MAX_SONG_COUNT+1
  BCC :+
  LDA #$00
  STA song_sel_position
  :
  DEC song_sel_cursor_time

  update_cursor_sprite:
  LDA #$6C
  STA $205

  LDA #BASE_CURSOR_X_POSITION_SONG_SEL
  LDX song_sel_position
  CLC

  loop_ucs:
  BEQ leave_lucs
  ADC #$20
  DEX
  BNE loop_ucs

  leave_lucs:
  STA $207
  RTS

  BASE_CURSOR_X_POSITION_SONG_SEL = $28
.endproc

.proc diff_cursor
  LDA diff_sel_cursor_time
  CMP #19
  BNE :+

  LDA #$04
  JSR famistudio_sfx_sample_play
  :

  LDX song_sel_position

  LDA BTN_Hold
  AND #%00000011
  BNE :+
  LDA #$00
  STA diff_sel_cursor_time
  :

  LDA BTN_Hold
  AND #BTN_LEFT
  BEQ :++
  LDA diff_sel_cursor_time
  BNE :+

  LDA #20
  STA diff_sel_cursor_time

  DEC diff_sel_position, X
  LDA diff_sel_position, X
  CMP #$FF
  BNE :+
  LDA #03
  STA diff_sel_position, X
  :
  DEC diff_sel_cursor_time

  JSR update_sram_loc

  LDA frame_timer_score_draw
  CMP #121
  BCC draw_godr_1

  LDA #$01
  STA draw_bg_over_palette

  JSR load_score_combo
  JMP escape_lsc_1
  draw_godr_1:

  JSR load_score_inputs
  escape_lsc_1:
  LDX song_sel_position

  JMP update_cursor_sprite

  :
  LDA BTN_Hold
  AND #BTN_RIGHT
  BNE :+

  JMP update_cursor_sprite

  :

  LDA diff_sel_cursor_time
  BNE :+

  LDA #20
  STA diff_sel_cursor_time

  INC diff_sel_position, X
  LDA diff_sel_position, X
  CMP #04
  BCC :+
  LDA #$00
  STA diff_sel_position, X
  :
  DEC diff_sel_cursor_time

  JSR update_sram_loc

  LDA frame_timer_score_draw
  CMP #121
  BCC draw_godr_2

  LDA #$01
  STA draw_bg_over_palette

  JSR load_score_combo
  JMP escape_lsc_2
  draw_godr_2:

  JSR load_score_inputs
  escape_lsc_2:
  LDX song_sel_position

  update_cursor_sprite:
  LDA #$6C
  STA $241

  LDA #BASE_CURSOR_X_POSITION_DIFF_SEL
  LDY diff_sel_position, X
  CLC

  loop_ucs:
  BEQ leave_lucs
  ADC #$28
  DEY
  BNE loop_ucs

  leave_lucs:
  STA $243
  RTS

  BASE_CURSOR_X_POSITION_DIFF_SEL = $40
.endproc

	c_h_base_sprite = $208
	drum_sel_base_sprite = $218
	diff_icon_base_sprtie = $220

.proc update_controller_highlight ; and that donchan icon (not there yet) and the song sel cursor
  LDA PPUSCROLL_Y_speed
  BPL :+
  DEC PPUSCROLL_Y_speed
  :

  LDX #$00
  load_c_h_sprites:
  LDA controller_highlight_sprite_data, X
  STA c_h_base_sprite, X
  INX
  CPX #$10
  BNE load_c_h_sprites

  INC frame_timer_controller
  LDA frame_timer_controller
  CMP #30
  BNE :+
  LDA #0
  STA frame_timer_controller
  LDA beat_anim_frame
  EOR #$01
  STA beat_anim_frame
  :

  LDX #$00
  load_drum_sel_sprites:
  LDA drum_sel_sprite_data, X
  STA drum_sel_base_sprite+1, X
  INX
  CPX #$06
  BNE load_drum_sel_sprites

  LDA drum_sel_base_sprite+3
  CLC
  ADC #$08
  STA drum_sel_base_sprite+7

  LDX #$00
  load_difficulty_icons:
  LDA diff_icon_sprite_data, X
  STA diff_icon_base_sprtie, X
  INX
  CPX #$20
  BNE load_difficulty_icons

  ; update cursor (song) sprite Y
  LDA cursor_song_Y
  ; set to $F0 if screen isnt 0
  LDX cursor_song_screen
  BEQ :+
  LDA #$F0
  :
  STA $204

  ; update cursor (song) sprite Y
  LDA cursor_diff_Y
  ; set to $F0 if screen isnt 0
  LDX cursor_diff_screen
  DEX
  BEQ :+
  LDA #$F0
  :
  STA $240

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
  CPX #$06 ; repeat
  BNE scroll_selection_sprites ; until X is 6

  LDA beat_anim_frame
  BNE :+
  LDX #$00
  unload_c_h_sprites:
  LDA #$F0
  STA c_h_base_sprite, X
  INX
  INX
  INX
  INX
  CPX #$10
  BNE unload_c_h_sprites
  :

  LDA PPUSCROLL_Y_speed
  BPL :+
  INC PPUSCROLL_Y_speed
  :

  RTS
.endproc

.proc update_donchan_color
  LDA song_sel_entry
  BNE :+++

  LDA BTN_Press
  AND #BTN_LEFT
  BEQ :+
  DEC don_color
  :

  LDA BTN_Press
  AND #BTN_RIGHT
  BEQ :+
  INC don_color
  :

  :

  LDA don_color
  STA palette+30
  LDA don_color+1
  STA palette+29
  LDA #$20
  STA palette+31
  RTS
.endproc

.proc update_diff_sel_loading
  LDA diff_sel_load_timer
  BNE :+

  RTS
  :

  LDX #$01
  STX draw_bg_over_palette

  DEC diff_sel_load_timer

  CMP #$03
  BNE :+
  JMP load_names

  :
  CMP #$02
  BNE :+
  JMP load_scores

  :

  ; load_stars

  ; because pressing a direction + start loads the name data too and i dont know why
  ; and im just lazy to fix it properly too-
  LDX #$00
  clear_draw_stars:
  LDA #$00
  STA draw, X
  INX
  CPX #$30
  BNE clear_draw_stars

  ; prepare locations for star drawing
  LDX #$00
  ; load song position * 4
  LDA song_sel_position
  ASL
  ASL
  TAY

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
  LDA song_stars, Y
  BNE :+
  LDA #$CD
  STA draw+7, X
  LDA #$01
  STA draw+5, X
  LDA #$0A
  BNE :+++
  :
  STA draw+5, X
  CLC
  SBC #$0A
  EOR #$FF
  BNE :++
  LDA #$D2
  STA draw+7, X
  LDA #$CA
  STA draw+4, X
  LDA #$0A
  STA draw+5, X
  LDA draw+3, X
  EOR #$80
  SEC
  SBC #$20
  EOR #$80
  BVC :+
  DEC draw+2, X
  :
  STA draw+3, X
  LDA #$01
  :
  STA draw+0, X
  INY
  TXA
  CLC
  ADC #$08
  TAX
  CPX #$20
  BNE draw_stars

  RTS

  load_names:
  LDX #$00
  clear_draw:
  LDA #$00
  STA draw, X
  INX
  BPL clear_draw

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

  LDX song_sel_position
  LDA #$F4
  LDY #$00
  :
  CLC
  ADC #12
  DEX
  BPL :-

  TAX

  draw_names:
  LDA song_author_1, X
  STA draw+4, Y
  LDA song_chartr_1, X
  STA draw+20, Y
  INX
  INY
  CPY #12
  BNE draw_names

  RTS
.endproc

  update_sram_loc:
  LDA #$62
  STA sram_location+1
  LDA #96
  STA sram_location

  LDX song_sel_position
  LDY diff_sel_position, X

  LDA sram_location
  set_sram_loc:
  CLC
  ADC #128
  BCC :+
  INC sram_location+1
  :
  DEX
  BPL set_sram_loc

  set_sram_loc_low:
  CLC
  ADC #32
  BCC :+
  INC sram_location+1
  :
  DEY
  BPL set_sram_loc_low
  STA sram_location

  LDY #$00
  load_to_draw_score:
  LDA (sram_location), Y
  STA score_to_draw, Y
  INY
  CPY #23
  BNE load_to_draw_score
  RTS

  load_scores:
  JSR update_sram_loc

  LDA #240
  STA frame_timer_score_draw

  JMP load_score_combo

  update_top_scores:
  LDA song_sel_entry
  CMP #$02
  BEQ :+
  RTS
  :

  DEC frame_timer_score_draw
  LDA frame_timer_score_draw
  BNE :+
  LDA #240
  STA frame_timer_score_draw
  :

  CMP #120
  BNE :+
  JMP load_score_inputs
  :

  CMP #240
  BEQ :+
  RTS
  :

  LDX #$01
  STX draw_bg_over_palette

  load_score_combo:

  LDA #$02
  LDY #$00
  draw_blank_tiles:
  STA draw+4, Y
  STA draw+28, Y
  INY
  CPY #20
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

  RTS

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

  song_sel_pal:
  .byte $0F, $05, $15, $25
  .byte $0F, $0F, $16, $30
  .byte $0F, $16, $37, $20
  .byte $0F, $17, $27, $20

  .byte $0F, $30, $30, $30
  .byte $0F, $0F, $15, $20
  .byte $0F, $0F, $2A, $07
  .byte $0F, $0F, $0F, $0F

  controller_highlight_sprite_data:
  .byte $D9, $66, $00, $9E, $D9, $66, $00, $A5, $DB, $68, $00, $B4, $DB, $6A, $00, $C4

  drum_sel_sprite_data:
  .byte $10, $03, $74, $00, $12, $03

  diff_icon_sprite_data:
  .byte $2E, $94, $01, $3C, $2E, $94, $41, $44, $2E, $98, $02, $8C, $2E, $98, $42, $94
  .byte $2E, $96, $02, $64, $2E, $96, $42, $6C, $2E, $9A, $01, $B4, $2E, $9A, $41, $BC

.proc load_main_game
	SEI

	LDX drum_bank_position_chart_backup
	LDA song_address_start_lo, X
  STA drum_bank_positon

  LDA song_address_start_hi, X
  STA drum_bank_positon+1

  LDA drum_bank_list, X
  STA $E800

  LDA PPUMASK
  AND #%11100111
  STA PPUMASK

  LDA PPUCTRL
  AND #%01111000
  STA PPUCTRL

  :
  LDA misc
  AND #$80
  BNE :-

  ; load PRG banks
  LDA #MAING_BANK
  STA $E000

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$01
  STA $8800
  LDA #$02
  STA $A000
  LDA #$03
  STA $A800
  LDA #$04
  STA $B000
  LDA #$0E
  STA $9000
  LDA #$01
  STA $9800
  LDA #$E1
  STA $C800
  LDA #$19
  STA $D800
  LDA #$E0
  STA $C000
  LDA #$0D
  STA $D000

  ; put every sprite offscreen
  LDX #$00
  LDA #$00
  set_sprites_to_00:
  STA $200, X
  INX
  BNE set_sprites_to_00

  LDA #$F0
  put_sprites_offscreen:
  STA $200, X
  INX
  INX
  INX
  INX
  BNE put_sprites_offscreen

  ; load background for both nametables

  LDX #$00
  load_taiko_bg:
  LDA taiko_bg, X
  STA draw, X
  INX
  CPX #$BE
  BNE load_taiko_bg
  JSR draw_background
  LDA #$24
  STA draw+2
  JSR draw_background
  LDX #$00
  LDA #$00
  clear_draw:
  STA draw, X
  INX
  CPX #$E0
  BNE clear_draw

  ; reset necessary values
  LDX #$00
  LDA #$00
  :
  STA drum_hit_pool, X
  STA drum_hit_pool+68, X
  INX
  BNE :-

  reset_positions:
  STA position_8px, X
  INX
  CPX #$0E
  BNE reset_positions

  ; reset misc bit 2
  ; otherwise drum inputs will be offsynced by -8px
  LDA #$00
  STA misc

  LDA #10
  STA end_song_timer

  LDA PPUSTATUS
  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  ; reset palette
  LDX #$00
  loop_reset_palette:
  LDA main_g_pal, X
  STA palette, X
  STA PPUDATA
  INX
  CPX #$1C
  BNE loop_reset_palette

  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$1F
  STA PPUADDR
  LDA #$0F
  STA palette+31
  STA PPUDATA

  LDA #$FF
  STA drum_hit_pool_pos

  ; setup buttons
  LDA don_inputs+1
  ORA don_inputs
  STA don_inputs+2

  LDA kat_inputs+1
  ORA kat_inputs
  STA kat_inputs+2

  ; prepare the $00 tiles for drum dispawning
  LDA #$03
  STA draw+5
  STA draw+10
  STA draw+15
  LDA #%00000110
  STA draw+6
  STA draw+11
  STA draw+16

  ; prepare the drum spawn positions
  ; for spawning and dispawning
  LDA #$25
  STA drum_spawn_position+1
  STA drum_spawn_position+3
  LDA #$0E
  STA drum_spawn_position+2
  LDA #$03
  STA drum_spawn_position

  ; prepare the drum spawn palette attributes
  ; for spawning and dispawning
  LDA #$27
  STA bg_attr_position
  STA bg_attr_position+3
  LDA #$D1
  STA bg_attr_position+1
  LDA #$D2
  STA bg_attr_position+4

  ; set the X coordinate of the bars
  LDA #$28
  STA bar_x
  JSR update_bars

  ; set misc and metronome_v to 1
  ; misc to 1 to toggle sprite 0 hit execution
  ; metronome_v to start executing at beat 0 instead of beat 1
  LDA #$01
  STA metronome_v

  ; enable sprite flicker
  LDA sprite_flicker_toggle
  AND #$FE
  STA sprite_flicker_toggle

  LDX #$00
  TXA ; LDA #$00
  reset_stats:
  STA combo_current, X
  INX
  CPX #33
  BNE reset_stats

  TAX
  reset_clearbar:
  STA clear_bar, X
  INX
  CPX #18
  BNE reset_clearbar

  TAX
  reset_drum_sprites:
  STA slot_number, X
  INX
  CPX #47
  BNE reset_drum_sprites

  TAX

  ; set tempo
  LDA mods
  AND #$08
  TAY

  LDA (drum_bank_positon, X)
  CPY #$08
  BNE :+
  EOR #$40
  :
  STA tempo

  JSR increase_dbp

  CLC
  LDA (drum_bank_positon, X)
  BNE :+
  LDA clear_bar_check_if_0
  ORA #$01
  STA clear_bar_check_if_0
  LDA #$FF
  SEC
  :
  STA clear_bar_inputs+1
  ROR
  BNE :+
  LDA #$01
  :
  STA clear_bar_input_miss+1

  JSR increase_dbp

  CLC
  LDA (drum_bank_positon, X)
  BNE :+
  LDA clear_bar_check_if_0
  ORA #$02
  STA clear_bar_check_if_0
  LDA #$FF
  SEC
  :
  STA clear_bar_inputs_modulo+1
  ROR
  STA clear_bar_input_miss_modulo+1

  JSR increase_dbp

  LDA #$00
  STA scene
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_Y_speed
  STA pause
  STA tempo+1
  STA roll_time
  STA input_rate_timer
  STA drum_input_don_time
  STA drum_input_kat_time
  STA beat_anim_frame
  STA beat_animation
  STA results_transition_time
  STA results_transition_time+1
  STA jump_frame
  STA drum_spawn_position_kept_pos
  STA end_timer
  STA gogo_timer
  STA gogo_timer+1
  STA drum_inc
  STA clear_drum_check
  STA roll_active

  LDX #$00
  reset_roll_values:
  STA roll_length, X
  INX
  CPX #11
  BNE reset_roll_values

  LDA #$02
  STA beat_anim_frame+1

  ; spawn the sprites for drum hitting
  LDY base_sprite+2
  LDX #$00
  load_drum_input_sprites:
  LDA drum_input_sprites, X
  STA $22C, Y
  INY
  INX
  CPX #20
  BNE load_drum_input_sprites

  LDA #$20
  STA tiles_remaining

  LDA tempo
  AND #$40
  BNE :+++

  LDA PPUCTRL
  ORA #%00000100
  STA $2000

  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$55
  STA PPUADDR
  LDX #$00

  :
  LDA extra_tiles, X
  STA PPUDATA
  INX
  CPX #$06
  BNE :-

  LDA PPUSTATUS
  LDA #$24
  STA PPUADDR
  LDA #$55
  STA PPUADDR
  LDX #$00

  :
  LDA extra_tiles, X
  STA PPUDATA
  INX
  CPX #$06
  BNE :-

  LDA PPUCTRL
  STA $2000

  LDA #$00
  STA tiles_remaining

  :

  LDX song_sel_position ; load the song number to X

  LDA #<set_scroll_score_init
  STA irq_address
  LDA #>set_scroll_score_init
  STA irq_address+1

  LDA PPUMASK
  ORA #%00011000
  STA PPUMASK

  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUCTRL
  ORA #%10000000
  STA PPUCTRL_kept
  STA PPUCTRL
  STA $2000

  LDA frame_timer
  AND #$FE
  STA frame_timer

  LDA song_bank_numbers, X
  STA $F000
  JSR init_song

  LDA #$00 ; song number
  JSR famistudio_music_play ; play song

  JMP stay_here

  increase_dbp:
  LDA drum_bank_positon
  CMP #$FF
  BNE :+
  INC drum_bank_positon+1
  :

  INC drum_bank_positon
  RTS

  song_bank_numbers:
  .byte $06, $07, $08, $09, $0A, $0B

  extra_tiles:
  .byte $78, $77, $77, $76, $75, $74
.endproc

.segment "MAIN_GAME"
taiko_bg:
	.byte $40, $02, $20, $00, $01
	.byte $05, $03, $71
	.byte $01, $01, $78
	.byte $1A, $03, $71
	.byte $05, $03, $02
	.byte $01, $01, $77
	.byte $1A, $03, $02
	.byte $05, $03, $02
	.byte $01, $01, $77
	.byte $1A, $03, $02
	.byte $05, $03, $70
	.byte $01, $01, $76
	.byte $1A, $03, $70
	.byte $05, $03, $03
	.byte $01, $01, $75
	.byte $1A, $03, $03
	.byte $05, $03, $6F
	.byte $01, $01, $74
	.byte $1A, $03, $6F

	.byte $80, $03, $00
	.byte $40, $03, $01
	.byte $20, $03, $00
	.byte $45, $01, $00,$00,$60,$61,$62,$00,$06,$12,$10,$05,$12,$2A,$00,$16,$06,$12,$15,$08,$2A,$00,$00,$00,$80,$80,$80,$80,$80,$80,$90,$90,$00,$00

	.byte $00,$00,$63,$64,$65,$00,$20,$20,$20,$20,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$66,$67,$68
	.byte $3B, $03, $00
	.byte $20, $03, $6C
	.byte $40, $03, $03
	.byte $20, $03, $6D
	.byte $20, $03, $02

	.byte $40, $03, $02
	.byte $20, $03, $6E
	.byte $60, $03, $01

	.byte $10, $03, $AA
	.byte $08, $03, $00
	.byte $0A, $01, $40,$10,$00,$00,$00,$a0,$a0,$10,$f4,$f1
	.byte $06, $03, $F0
	.byte $10, $03, $FF
	.byte $08, $03, $0F

.segment "START"

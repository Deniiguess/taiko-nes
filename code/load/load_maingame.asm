.proc load_main_game
	LDX drum_bank_position_chart_backup
	LDA song_address_start_lo, X
  STA drum_bank_positon

  LDA song_address_start_hi, X
  STA drum_bank_positon+1

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
  LDA #DBANK1_BANK
  STA $E800

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
  LDA #$E1
  STA $C800
  STA $D800
  LDA #$E0
  STA $C000
  LDA #$0D
  STA $D000

  ; put every sprite offscreen
  LDX #$00
  put_sprites_offscreen:
  LDA #$F0
  STA $200, X
  INX
  INX
  INX
  INX
  BNE put_sprites_offscreen

  ; rest draw memory bytes
  LDA #$00
  reset_draw:
  STA draw, X
  INX
  BPL reset_draw

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

  ; set sprite 0 for scrolling
  LDA #$68
  STA $200
  LDA #$06
  STA $201
  LDA #%00100000
  STA $202
  LDA #$00
  STA $203

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
  LDA #$0B
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
  STA score, X
  INX
  CPX #26
  BNE reset_stats

  TAX
  reset_clearbar:
  STA clear_bar, X
  INX
  CPX #13
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

  LDA (drum_bank_positon, X)
  STA clear_bar_inputs+1
  STA clear_bar_input_miss+1

  JSR increase_dbp

  LDA #$00
  STA scene
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_Y_speed
  STA pause
  STA tempo+1
  STA roll_length
  STA roll_length+1
  STA roll_time
  STA input_rate_timer
  STA drum_input_don_time
  STA drum_input_kat_time

  ; spawn the sprites for drum hitting
  LDY base_sprite+2
  load_drum_input_sprites:
  LDA drum_input_sprites, X
  STA $22C, Y
  INY
  INX
  CPX #20
  BNE load_drum_input_sprites

  ; load background for both nametables

  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  LDY #$02

  load_taiko_bg:
  load_taiko_bg_1:
  LDA taiko_bg_1, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_1

  load_taiko_bg_2:
  LDA taiko_bg_2, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_2

  load_taiko_bg_3:
  LDA taiko_bg_3, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_3

  load_taiko_bg_4:
  LDA taiko_bg_4, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_4

  DEY
  BNE load_taiko_bg

  LDA tempo
  AND #$40
  BEQ :+++

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
  LDA blank_tiles, X
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
  LDA blank_tiles, X
  STA PPUDATA
  INX
  CPX #$06
  BNE :-

  LDA PPUCTRL
  STA $2000

  LDA #$20
  STA tiles_remaining

  :

  LDX song_sel_position ; load the song number to X

  LDA misc
  ORA #$01
  STA misc

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

  blank_tiles:
  .byte $71, $02, $02, $70, $03, $6F
.endproc

.segment "MAIN_GAME"
taiko_bg_1:
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $71,$71,$71,$71,$71,$78,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$78,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71
	.byte $02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $70,$70,$70,$70,$70,$76,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$76,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
	.byte $03,$03,$03,$03,$03,$75,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$75,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $6f,$6f,$6f,$6f,$6f,$74,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$74,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f

taiko_bg_2:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$60,$61,$62,$00,$06,$12,$10,$05,$12,$2A,$00,$16,$06,$12,$15,$08,$2A,$00,$00,$00,$80,$80,$80,$80,$80,$80,$90,$90,$00,$00

taiko_bg_3:
	.byte $00,$00,$63,$64,$65,$00,$20,$20,$20,$20,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$66,$67,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c
	.byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02

taiko_bg_4:
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $40,$10,$00,$00,$00,$a0,$a0,$10
	.byte $f4,$f1,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f

.byte $00, $00, $03, $06, $0D, $13, $19, $1F, $26, $2C, $32, $38, $3E, $44, $4A, $50
.byte $56, $5C, $62, $68, $6D, $73, $79, $7E, $84, $89, $8E, $93, $98, $9D, $A2, $A7
.byte $AC, $B1, $B5, $B9, $BE, $C2, $C6, $CA, $CE, $D1, $D5, $D8, $DC, $DF, $E2, $E5
.byte $E7, $EA, $ED, $EF, $F1, $F3, $F5, $F7, $F8, $FA, $FB, $FC, $FD, $FE, $FF, $FF

.segment "START"

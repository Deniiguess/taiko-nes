.proc load_results
  LDA PPUMASK
  AND #%11100111
  STA PPUMASK

  LDA PPUCTRL
  STA PPUCTRL_kept
  AND #%01111000
  STA PPUCTRL

  ; disable sprite 0 hit
  LDA misc
  AND #$FE
  STA misc

  ; unload all sprites
  LDX #$00
  unload_sprites:
  LDA #$F0
  STA $200, X
  INX
  INX
  INX
  INX
  BNE unload_sprites

  :
  LDA misc
  AND #$80
  BNE :-

  ; reset scrolling
  LDA #$00
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_X_speed
  STA PPUSCROLL_Y_speed

  ; load PRG banks (just in case)
  LDA #$01
  STA $E000

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$01
  STA $8800
  STA song_sel_entry
  LDA #$02
  STA $A000
  LDA #$08
  STA $A800
  LDA #$09
  STA $B000

  ; load nametable banks
  ; and load PPU nametables
  LDA #$E0
  STA $C800
  STA $D800
  LDA #$E1
  STA $D000
  LDA #$0D
  STA $C000

  LDA #$00
  STA fade_intensity

  LDX #$00
  STX ts_ss_timer
  STX ts_ss_timer+1
  loop_reset_palette:
  LDA song_sel_pal, X
  STA palette, X
  INX
  CPX #$20
  BNE loop_reset_palette

  ; load background
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00

;   load_results_bg:
;   load_results_1:
;   LDA results_1, X
;   STA PPUDATA
;   INX
;   BNE load_results_1
;
;   load_results_2:
;   LDA results_2, X
;   STA PPUDATA
;   INX
;   BNE load_results_2
;
;   load_results_3:
;   LDA results_3, X
;   STA PPUDATA
;   INX
;   BNE load_results_3
;
;   load_results_4:
;   LDA results_4, X
;   STA PPUDATA
;   INX
;   BNE load_results_4

  LDA #$03
  STA scene
  LDA #$00
  STA PPUSCROLL_X

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

  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  LDA #$01
  JSR famistudio_sfx_sample_play

  LDA #$FF
  STA song_sel_position+1

  LDA #$04
  STA fade_intensity

  LDA #$00
  STA fade_type

  LDA #$01
  STA fade_time

  JMP stay_here
.endproc

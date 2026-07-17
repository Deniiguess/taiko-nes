.proc load_song_sel
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

  ; rest draw memory bytes
  LDA #$00
  reset_draw:
  STA draw, X
  INX
  BPL reset_draw

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

  ; disable sprite flicker
  LDA sprite_flicker_toggle
  ORA #$01
  STA sprite_flicker_toggle

  ; load PRG banks (just in case)
  LDA #$01
  STA $E000

  ; load nametable banks
  ; load PPU nametables
  LDA #$E1
  STA $C800
  STA $D800
  LDA #$E0
  STA $D000
  STA $C000

  LDA #$00
  STA fade_intensity

  LDA #$1B
  STA cursor_diff_Y
  LDA #$1B
  STA cursor_song_Y
  LDA #$D9
  STA controller_h_Y
  LDA #$D1
  STA drum_sel_Y
  LDA #$2E
  STA diff_icon_Y

  LDX #$00
  STX ts_ss_timer
  STX ts_ss_timer+1
  loop_reset_palette:
  LDA song_sel_pal, X
  STA palette, X
  INX
  CPX #$1C
  BNE loop_reset_palette

  ; load difficulty select and settings
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00

  load_diff_sel_1:
  LDA diff_sel_1, X
  STA PPUDATA
  INX
  BNE load_diff_sel_1

  load_diff_sel_2:
  LDA diff_sel_2, X
  STA PPUDATA
  INX
  BNE load_diff_sel_2

  load_diff_sel_3:
  LDA diff_sel_3, X
  STA PPUDATA
  INX
  BNE load_diff_sel_3

  load_diff_sel_4:
  LDA diff_sel_4, X
  STA PPUDATA
  INX
  BNE load_diff_sel_4

  load_sett_sel_1:
  LDA sett_sel_1, X
  STA PPUDATA
  INX
  BNE load_sett_sel_1

  load_sett_sel_2:
  LDA sett_sel_2, X
  STA PPUDATA
  INX
  BNE load_sett_sel_2

  load_sett_sel_3:
  LDA sett_sel_3, X
  STA PPUDATA
  INX
  BNE load_sett_sel_3

  load_sett_sel_4:
  LDA sett_sel_4, X
  STA PPUDATA
  INX
  BNE load_sett_sel_4

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
  LDA #$0A
  STA $B800
  STA $9000

  LDA #$0D
  STA $C000

  LDA #$02
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

.segment "TITL_SCEN_SONG_SEL_RES"
diff_sel_1:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$c0,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c1,$c2,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c6,$c7,$c8,$c4,$c4,$c6,$c7,$c8,$c4,$c4,$c6,$c7,$c8,$c4,$c4,$c6,$c7,$c8,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00

diff_sel_2:
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00

diff_sel_3:
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c9,$ca,$cb,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$cc,$cd,$ce,$c4,$c4,$cc,$cd,$ce,$c4,$c4,$cc,$cd,$ce,$c4,$c4,$cc,$cd,$ce,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00

diff_sel_4:
	.byte $00,$00,$00,$c3,$c4,$4c,$54,$52,$48,$42,$c4,$41,$58,$64,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$c3,$c4,$42,$47,$40,$51,$53,$c4,$41,$58,$64,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c4,$c5,$00,$00,$00
	.byte $00,$00,$00,$cf,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d1,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

sett_sel_1:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$a0,$a1,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a2,$a3,$a4,$00,$00,$00
	.byte $00,$00,$00,$a5,$a6,$a7,$a8,$a9,$a9,$a9,$a9,$a9,$aa,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ac,$00,$00,$00
	.byte $00,$00,$00,$ad,$ae,$af,$b0,$a9,$a9,$a9,$a9,$a9,$a9,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$b1,$00,$00,$00
	.byte $00,$00,$00,$ad,$b2,$b3,$b4,$b5,$b6,$a9,$a9,$a9,$a9,$b7,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$b1,$00,$00,$00

sett_sel_2:
	.byte $00,$00,$00,$ad,$a9,$b8,$b9,$e0,$ba,$bb,$bc,$a9,$a9,$bd,$be,$be,$be,$be,$be,$bf,$c0,$c1,$be,$bf,$c2,$c1,$be,$c3,$b1,$00,$00,$00
	.byte $00,$00,$00,$ad,$a9,$c4,$e0,$e0,$e0,$e0,$c5,$a9,$a9,$a9,$a9,$a9,$a9,$a9,$a9,$c6,$c7,$c8,$a9,$c6,$c9,$c8,$a9,$a9,$b1,$00,$00,$00
	.byte $00,$00,$00,$ad,$a9,$ca,$cb,$e0,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$a9,$d6,$e0,$d7,$a9,$d6,$e0,$d7,$a9,$a9,$b1,$00,$00,$00
	.byte $00,$00,$00,$ad,$d8,$d8,$d9,$e0,$da,$d8,$d8,$db,$dc,$dd,$de,$df,$e1,$e2,$d8,$e3,$e0,$e4,$d8,$e3,$e0,$e4,$d8,$d8,$b1,$00,$00,$00
	.byte $00,$00,$00,$e5,$e6,$a9,$a9,$e7,$e8,$a9,$a9,$e9,$ea,$ea,$ea,$ea,$ea,$eb,$a9,$ec,$ed,$ee,$a9,$ec,$ed,$ee,$a9,$ef,$f0,$00,$00,$00
	.byte $00,$00,$00,$f1,$f2,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f3,$f4,$f5,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$17,$1c,$13,$08,$2c,$04,$00,$00,$00,$00,$17,$1c,$13,$08,$2c,$05,$00,$00,$00,$00,$00,$00,$00,$00

sett_sel_3:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$17,$1c,$13,$08,$2c,$06,$00,$00,$00,$00,$17,$1c,$13,$08,$2c,$07,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$04,$18,$17,$12,$13,$0f,$04,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

sett_sel_4:
	.byte $00,$00,$0c,$11,$19,$0c,$16,$0c,$05,$0f,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$09,$0f,$0c,$13,$13,$08,$07,$00,$07,$15,$18,$10,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$09,$0f,$0c,$13,$13,$08,$07,$00,$16,$13,$08,$08,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $55,$55,$55,$55,$55,$55,$55,$55
	.byte $55,$55,$55,$55,$55,$55,$55,$55
	.byte $55,$55,$55,$55,$55,$55,$55,$55

	song_sel_pal:
  .byte $0F, $05, $15, $25
  .byte $0F, $0F, $0F, $20
  .byte $0F, $16, $37, $00
  .byte $0F, $17, $27, $20

  .byte $0F, $30, $30, $30
  .byte $0F, $0F, $15, $20
  .byte $0F, $0F, $2A, $07
  .byte $0F, $0F, $0F, $0F

.segment "START"

.proc load_results
  ; unload all sprites
  LDX #$00
  LDA #$F0
  unload_sprites:
  STA $200, X
  INX
  BNE unload_sprites

  ; reset scrolling
  LDA #$00
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_X_speed
  STA PPUSCROLL_Y_speed

  ; load CHR banks
  LDA #$08
  STA $8800
  LDA #$02
  STA $A000
  LDA #$08
  STA $A800
  LDA #$18
  STA $B800

  ; load nametable banks
  ; and load PPU nametables
  LDA #$E0
  STA $C000
  STA $C800

	LDA #$03
	STA scene
	LDA #RESULTS_BANK
	STA $E800

	LDA #$00
	STA ran_results_setup
	STA results_position
	STA high_score
	STA results_jt_position
	STA ts_ss_timer
	STA ts_ss_timer+1

	RTS
.endproc

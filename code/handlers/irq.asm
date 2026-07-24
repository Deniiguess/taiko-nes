.proc irq_handler
	PHA
  TXA
  PHA
  TYA
  PHA

  LDA #$00
	STA $5800

	LDA #$00
	STA $2005
	STA $2005

	LDA PPUCTRL_kept_2 ; set the bottom half PPUCTRL to PPUCTRL_kept_2
  STA $2000

  LDA PPUMASK
  AND #%11100111
  STA $2001

  LDA #$3F
  STA PPUADDR
  LDA #$03
  STA PPUADDR

  LDA base_sprite_drum_hit
  STA $2003

  LDY #$00
  load_drum_input_sprites:
  LDA drum_input_sprites, Y
  STA $2004
  INY
  CPY #20
  BNE load_drum_input_sprites

  LDA #$31
  STA PPUADDR
  LDA #$A0
  STA PPUADDR

  LDA PPUMASK
  STA $2001

  :

	pla ; restore Y
  tay
  pla ; restore X
  tax
  pla ; restore A
	RTI
.endproc

base_sprite_pool:
.byte $00, $6C, $AC, $EC

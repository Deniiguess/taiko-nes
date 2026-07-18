.proc reset_handler
  SEI ; disable IRQ
  CLD ; clear decimal
  LDX #$40
  ;STX $4017
  LDX #$FF
  TXS ; set stack to $FF
  INX ; set X to 0
  STX $2000
  STX $2001
  STX $4010
  BIT $2002
vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait
vblankwait2:
  BIT $2002
  BPL vblankwait2

  JMP main
.endproc

.proc main
  LDX #$00 ; load $00 to X so theres no offest
  STX $4000
  LDA #$ff

  ; reset memory
  LDA #$00
  LDX #$00
  ; enable writing to $6000-$7FFF
  LDA #%01000000
  STA $F800
  LDA #$00

  loop_reset_memory:
  STA $000, X
  STA $100, X
  STA $200, X
  STA $300, X
  STA $400, X
  STA $500, X
  STA $600, X
  STA $700, X
  STA $6000, X
  STA $6100, X
  INX
  BNE loop_reset_memory

  ; set the read-write of PRG-ROM to PRGROM_buf
  LDA #%01000000
  STA PRGROM_buf

  vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait
  ; set PPUADDR to $3F00

  LDA #$40 ; setup sprite flickering
  STA base_sprite+1
  LDA #$80
  STA base_sprite+2
  LDA #$C0
  STA base_sprite+3

  ; define sfx
;   LDX #<sounds ; load low byte to X
;   LDY #>sounds ; load high byte to Y
;   JSR famistudio_sfx_init ; initialize sfx

  ; set palette as black
  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  :
  LDA #$0F
  STA PPUDATA
  INX
  CPX #$20
  BNE :-

  ; set donchan colors for first boot
  LDA don_color+2
  BNE :+
  LDA #$19
  STA don_color_pos
  LDA #$06
  STA don_color_pos+1
  LDA #$01
  STA don_color+2
  :

  JSR load_title_screen

  LDA #%10110000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  STA PPUCTRL_kept
  STA PPUCTRL_kept_2
  STA $2000 ; PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK
  ; the scene jump table is below
.endproc

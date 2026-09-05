.proc title_screen
  INC PPUSCROLL_X

  JSR update_title_screen_palette

  JSR update_ts_frame_timer

  LDA ts_ss_timer
  CMP #38
  BCC :+

  LDA ts_ss_timer+1
  AND #$80
  BNE :+

  LDA BTN_Press
  AND #BTN_START
  BEQ :+

  LDA #$01 ; play the DON sample
  JSR famistudio_sfx_sample_play

  LDA #$81
  STA ts_ss_timer+1
  :

  JMP stay_here
.endproc

.proc update_title_screen_palette
  INC ts_ss_timer
  LDA ts_ss_timer
  CMP #20
  BNE :+
  LDX #$00
  STX fade_type
  LDX #$04
  STX fade_time
  :
  BCC :+
  LDA #39
  STA ts_ss_timer
  :
  RTS
.endproc

.proc update_ts_frame_timer
  LDA ts_ss_timer+1
  BNE :+
  RTS

  :
  INC ts_ss_timer+1
  LDA ts_ss_timer+1
  AND #$7F
  CMP #30
  BCS :+
  RTS

  :
  CMP #30
  BNE :+
  LDX #$01
  STX fade_type
  LDX #$02
  STX fade_time
  :
  CMP #70
  BEQ :+
  RTS
  :
  JMP load_song_sel
.endproc

title_screen_irq_init:
	PHA
  LDA #<title_screen_irq_1
  STA irq_address
  LDA #>title_screen_irq_1
  STA irq_address+1

  LDA #$00
	STA $5000
.if ROM_PAL
	; PAL timing
	LDA #$71+$80
	STA $5800
.else
	; NTSC timing
	LDA #$70+$80
	STA $5800
.endif
  PLA

	RTI

title_screen_irq_1:
	PHA
	LDA #$00
  STA $2005
  STA $2005

  LDA #<title_screen_irq_2
  STA irq_address
  LDA #>title_screen_irq_2
  STA irq_address+1

.if ROM_PAL
	; PAL timing
	LDA #$00
	STA $5000
	LDA #$39+$80
	STA $5800
.else
	; NTSC timing
	LDA #$00
	STA $5000
	LDA #$35+$80
	STA $5800
.endif

  PLA
	RTI

.proc title_screen_irq_2
	PHA
	LDA PPUSCROLL_X
  EOR #$FF
  STA $2005
  LDA #$00
  STA $2005

  LDA #<title_screen_irq_init
  STA irq_address
  LDA #>title_screen_irq_init
  STA irq_address+1

  LDA #$00
  STA $5800

  PLA
	RTI
.endproc

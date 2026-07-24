.proc irq_handler
	PHA

  LDA #$00
	STA $5800
	STA $2005
	STA $2005

	LDA PPUCTRL_kept_2
  STA $2000

  PLA
	RTI
.endproc

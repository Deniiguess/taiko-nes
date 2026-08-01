.proc irq_handler
	JMP (irq_address)
.endproc

.proc return_from_irq
	PHA
	LDA #$00
	STA $5800
	PLA
	RTI
.endproc

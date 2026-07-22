; not much here rn

.proc results
	LDA ts_ss_timer
	BEQ :+
	DEC ts_ss_timer
	JMP stay_here
	:

	JSR update_scroll_results

  LDA BTN_Press
  AND #BTN_A
  BEQ :+
  JMP load_song_sel
  :
  JMP stay_here
.endproc

.proc update_scroll_results
	LDA #$00
	STA PPUSCROLL_Y_speed

	LDA ts_ss_timer+1
	BEQ :+

	LDA #$FE
	STA PPUSCROLL_Y_speed
	DEC ts_ss_timer+1

	:
	RTS
.endproc

; not much here rn

.proc results

  LDA BTN_Press
  AND #BTN_A
  BEQ :+
  JMP load_song_sel
  :
  JMP stay_here
.endproc

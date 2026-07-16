.proc stay_here
  LDA misc
  AND #$80
  BNE stay_here ; loop stay_here if the last bit in misc is 1

  LDA misc
  ORA #$80
  STA misc ; set the last bit in misc to 1

  LDX scene
  LDA scenes_lo, X
  STA address_table
  LDA scenes_hi, X
  STA address_table+1
  JMP (address_table)

  RTS

scenes_lo:
.lobytes main_game, title_screen, song_sel, results

scenes_hi:
.hibytes main_game, title_screen, song_sel, results

.endproc

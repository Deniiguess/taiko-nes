.proc title_screen
  INC PPUSCROLL_X

  LDX #$B0
  :
  INX
  BNE :-

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

  LDA #$00
  STA $2005
  LDA #$00
  STA $2005

  :
  LDA PPUSTATUS
  AND #%01000000
  BEQ :-

  LDA PPUSCROLL_X
  EOR #$FF
  STA $2005
  LDA #$00
  STA $2005

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

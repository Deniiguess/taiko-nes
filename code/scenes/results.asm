; not much here rn

.proc results
	LDA results_transition_time
	BEQ :+

	JMP load_background_result

	:

  JMP stay_here
.endproc

.proc load_background_result
	LDA #$00
	LDX #$00
	reset_draw:
	STA draw, X
	INX
	CPX #$E0
	BNE reset_draw
	LDA #$01
	STA draw_bg_over_palette

	LDX results_transition_time+1
	DEX
	CPX #41
	BCC :+
	JMP stay_here
	:
  LDA background_jt_lo, X
  STA address_table
  LDA background_jt_hi, X
  STA address_table+1
  LDX #$00
  JMP (address_table)

  background_jt_lo:
  .lobytes background_result_load_1, background_result_load_2, background_result_load_3, background_result_load_4
  .lobytes background_result_load_5, background_result_load_6, background_result_load_7, background_result_load_8
  .lobytes background_result_load_9, background_result_load_10, background_result_load_11, background_result_load_12
  .lobytes background_result_load_13, background_result_load_14, background_result_load_15, background_result_load_16
  .lobytes background_result_load_17, background_result_load_18, background_result_load_19, background_result_load_20
  .lobytes background_result_load_21, background_result_load_22, background_result_load_23, background_result_load_24
  .lobytes background_result_load_25, background_result_load_26, background_result_load_27, background_result_load_28
  .lobytes background_result_load_29, background_result_load_30, background_result_load_31, background_result_load_32
  .lobytes background_result_load_33, background_result_load_34, background_result_load_35, background_result_load_36
  .lobytes background_result_load_37, background_result_load_38, background_result_load_39, background_result_load_40
  .lobytes background_result_load_41

  background_jt_hi:
  .hibytes background_result_load_1, background_result_load_2, background_result_load_3, background_result_load_4
  .hibytes background_result_load_5, background_result_load_6, background_result_load_7, background_result_load_8
  .hibytes background_result_load_9, background_result_load_10, background_result_load_11, background_result_load_12
  .hibytes background_result_load_13, background_result_load_14, background_result_load_15, background_result_load_16
  .hibytes background_result_load_17, background_result_load_18, background_result_load_19, background_result_load_20
  .hibytes background_result_load_21, background_result_load_22, background_result_load_23, background_result_load_24
  .hibytes background_result_load_25, background_result_load_26, background_result_load_27, background_result_load_28
  .hibytes background_result_load_29, background_result_load_30, background_result_load_31, background_result_load_32
  .hibytes background_result_load_33, background_result_load_34, background_result_load_35, background_result_load_36
  .hibytes background_result_load_37, background_result_load_38, background_result_load_39, background_result_load_40
  .hibytes background_result_load_41

.endproc

.proc background_result_load_1
	LDA background_result_load_1_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_1
	JMP stay_here

	background_result_load_1_data:
	.byte $30, $02, $20, $00, $00
.endproc

.proc background_result_load_2
	LDA background_result_load_2_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_2
	JMP stay_here

	background_result_load_2_data:
	.byte $30, $02, $20, $30, $00
.endproc

.proc background_result_load_3
	LDA background_result_load_3_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_3
	JMP stay_here

	background_result_load_3_data:
	.byte $30, $02, $20, $60, $00
.endproc

.proc background_result_load_4
	LDA background_result_load_4_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_4
	JMP stay_here

	background_result_load_4_data:
	.byte $30, $02, $20, $90, $00
.endproc

.proc background_result_load_5
	LDA background_result_load_5_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_5
	JMP stay_here

	background_result_load_5_data:
	.byte $30, $02, $20, $C0, $00
.endproc

.proc background_result_load_6
	LDA background_result_load_6_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_6
	JMP stay_here

	background_result_load_6_data:
	.byte $30, $02, $20, $F0, $00
.endproc

.proc background_result_load_7
	LDA background_result_load_7_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_7
	JMP stay_here

	background_result_load_7_data:
	.byte $30, $02, $21, $20, $00
.endproc

.proc background_result_load_8
	LDA background_result_load_8_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_8
	JMP stay_here

	background_result_load_8_data:
	.byte $30, $02, $21, $50, $00
.endproc

.proc background_result_load_9
	LDA background_result_load_9_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_9
	JMP stay_here

	background_result_load_9_data:
	.byte $30, $02, $21, $80, $00
.endproc

.proc background_result_load_10
	LDA background_result_load_10_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_10
	JMP stay_here

	background_result_load_10_data:
	.byte $30, $02, $21, $B0, $00
.endproc

.proc background_result_load_11
	LDA background_result_load_11_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_11
	JMP stay_here

	background_result_load_11_data:
	.byte $30, $02, $21, $E0, $00
.endproc

.proc background_result_load_12
	LDA background_result_load_12_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_12
	JMP stay_here

	background_result_load_12_data:
	.byte $30, $02, $22, $10, $00
.endproc

.proc background_result_load_13
	LDA background_result_load_13_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_13
	JMP stay_here

	background_result_load_13_data:
	.byte $30, $02, $22, $40, $00
.endproc

.proc background_result_load_14
	LDA background_result_load_14_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_14
	JMP stay_here

	background_result_load_14_data:
	.byte $30, $02, $22, $70, $00
.endproc

.proc background_result_load_15
	LDA background_result_load_15_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_15
	JMP stay_here

	background_result_load_15_data:
	.byte $30, $02, $22, $A0, $00
.endproc

.proc background_result_load_16
	LDA background_result_load_16_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_16
	JMP stay_here

	background_result_load_16_data:
	.byte $30, $02, $22, $D0, $00
.endproc

.proc background_result_load_17
	LDA background_result_load_17_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_17
	JMP stay_here

	background_result_load_17_data:
	.byte $30, $02, $23, $00, $00
.endproc

.proc background_result_load_18
	LDA background_result_load_18_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_18
	JMP stay_here

	background_result_load_18_data:
	.byte $30, $02, $23, $30, $00
.endproc

.proc background_result_load_19
	LDA background_result_load_19_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_19
	JMP stay_here

	background_result_load_19_data:
	.byte $30, $02, $23, $60, $00
.endproc

.proc background_result_load_20
	LDA background_result_load_20_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_20
	JMP stay_here

	background_result_load_20_data:
	.byte $30, $02, $23, $90, $00
.endproc

.proc background_result_load_21
	LDA background_result_load_21_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_21
	JMP stay_here

	background_result_load_21_data:
	.byte $30, $02, $23, $C0, $00
.endproc

.proc background_result_load_22
	LDA background_result_load_22_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_22
	JMP stay_here

	background_result_load_22_data:
	.byte 18, $06, $20, $C5, $02
	.byte 18, $06, $20, $C6, $02
.endproc

.proc background_result_load_23
	LDA background_result_load_23_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_23
	JMP stay_here

	background_result_load_23_data:
	.byte 18, $06, $20, $C7, $02
	.byte 18, $06, $20, $C8, $02
.endproc

.proc background_result_load_24
	LDA background_result_load_24_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_24
	JMP stay_here

	background_result_load_24_data:
	.byte 18, $06, $20, $C9, $02
	.byte 18, $06, $20, $CA, $02
.endproc

.proc background_result_load_25
	LDA background_result_load_25_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_25
	JMP stay_here

	background_result_load_25_data:
	.byte 18, $06, $20, $CB, $02
	.byte 18, $06, $20, $CC, $02
.endproc

.proc background_result_load_26
	LDA background_result_load_26_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_26
	JMP stay_here

	background_result_load_26_data:
	.byte 18, $06, $20, $CD, $02
	.byte 18, $06, $20, $CE, $02
.endproc

.proc background_result_load_27
	LDA background_result_load_27_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_27
	JMP stay_here

	background_result_load_27_data:
	.byte 18, $06, $20, $CF, $02
	.byte 18, $06, $20, $D0, $02
.endproc

.proc background_result_load_28
	LDA background_result_load_28_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_28
	JMP stay_here

	background_result_load_28_data:
	.byte 18, $06, $20, $D1, $02
	.byte 18, $06, $20, $D2, $02
.endproc

.proc background_result_load_29
	LDA background_result_load_29_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_29
	JMP stay_here

	background_result_load_29_data:
	.byte 18, $06, $20, $D3, $02
	.byte 18, $06, $20, $D4, $02
.endproc

.proc background_result_load_30
	LDA background_result_load_30_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_30
	JMP stay_here

	background_result_load_30_data:
	.byte 18, $06, $20, $D5, $02
	.byte 18, $06, $20, $D6, $02
.endproc

.proc background_result_load_31
	LDA background_result_load_31_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_31
	JMP stay_here

	background_result_load_31_data:
	.byte 18, $06, $20, $D7, $02
	.byte 18, $06, $20, $D8, $02
.endproc

.proc background_result_load_32
	LDA background_result_load_32_data, X
	STA draw, X
	INX
	CPX #$0A
	BNE background_result_load_32
	JMP stay_here

	background_result_load_32_data:
	.byte 18, $06, $20, $D9, $02
	.byte 18, $06, $20, $DA, $02
.endproc

.proc background_result_load_33
	LDA background_result_load_33_data, X
	STA draw, X
	INX
	CPX #$0E
	BNE background_result_load_33
	JMP stay_here

	background_result_load_33_data:
	.byte 22, $02, $20, $A5, $C1
	.byte $01, $05, $C2
	.byte 18, $07, $C6
	.byte $01, $01, $D1
.endproc

.proc background_result_load_34
	LDA background_result_load_34_data, X
	STA draw, X
	INX
	CPX #$0E
	BNE background_result_load_34
	JMP stay_here

	background_result_load_34_data:
	.byte $01, $04, $20, $A4, $C0
	.byte 18, $07, $C3
	.byte $01, $01, $CF
	.byte 22, $03, $D0
.endproc

.proc background_result_load_35
	LDA background_result_load_35_data, X
	STA draw, X
	INX
	CPX #33
	BNE background_result_load_35
	JMP stay_here

	background_result_load_35_data:
	.byte $01, $00, $21, $4B, $C7
	.byte $08, $03, $C8
	.byte $01, $01, $C9
	.byte $01, $00, $21, $6B, $CA
	.byte $08, $03, $00
	.byte $01, $01, $CB
	.byte $01, $00, $21, $8B, $CC
	.byte $08, $03, $CD
	.byte $01, $01, $CE
.endproc

.proc background_result_load_36
	LDA background_result_load_36_data, X
	STA draw, X
	INX
	CPX #15
	BNE background_result_load_36
	JMP stay_here

	background_result_load_36_data:
	.byte $0C, $02, $20, $E8, $D2
	.byte $04, $02, $20, $D4, $E7
	.byte $04, $02, $20, $F4, $E7
.endproc

.proc background_result_load_37
	LDA background_result_load_37_data, X
	STA draw, X
	INX
	CPX #47
	BNE background_result_load_37
	JMP stay_here

	background_result_load_37_data:
	.byte $05, $00, $21, $2D, $52, $42, $4E, $51, $44
	.byte $05, $00, $21, $C6, $42, $4E, $4C, $41, $4E
	.byte $04, $00, $22, $07, $51, $4E, $4B, $4B
	.byte $04, $00, $22, $47, $46, $4E, $4E, $43
	.byte $02, $00, $22, $89, $4E, $4A
	.byte $03, $00, $22, $C8, $41, $40, $43
.endproc

.proc background_result_load_38
	LDA background_result_load_38_data, X
	STA draw, X
	INX
	CPX #30
	BNE background_result_load_38
	JMP stay_here

	background_result_load_38_data:
	.byte $07, $02, $21, $6C, $20
	.byte $04, $02, $21, $CC, $5A
	.byte $04, $02, $22, $0C, $5A
	.byte $04, $02, $22, $4C, $5A
	.byte $04, $02, $22, $8C, $5A
	.byte $04, $02, $22, $CC, $5A
.endproc

.proc background_result_load_39
	LDA background_result_load_39_data, X
	STA draw, X
	INX
	CPX #$24
	BNE background_result_load_39
	JMP stay_here

	background_result_load_39_data:
	.byte $20, $00, $23, $C0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$a0,$a0,$a0,$50,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$f0,$f0,$f0,$00
.endproc

.proc background_result_load_40
	LDA background_result_load_40_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_40
	JMP stay_here

	background_result_load_40_data:
	.byte $20, $02, $23, $E0, $00
.endproc

.proc background_result_load_41
	LDA palette_result_data, X
	STA palette, X
	INX
	CPX #$1C
	BNE background_result_load_41

	LDA #$00
	STA draw_bg_over_palette

	JMP stay_here

	palette_result_data:
	.byte $0F, $21, $11, $20
	.byte $0F, $17, $27, $20
	.byte $0F, $05, $11, $15
	.byte $0F, $21, $11, $26

	.byte $0F, $0F, $0F, $0F
	.byte $0F, $0F, $0F, $0F
	.byte $0F, $0F, $0F, $0F
.endproc

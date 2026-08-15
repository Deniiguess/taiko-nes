; not much here rn

.proc results
	LDX results_jt_position
	CPX #$07
	BCS :+
	LDA #$01
	STA draw_bg_over_palette
	:

	LDA results_transition_time
	BEQ :+

	JMP load_background_result

	:

	LDA PPUMASK
	ORA #%00010000
	STA PPUMASK

	LDA frame_timer
	LSR
	BCC :+
	JSR update_countdown
	:

	JSR update_inputs_results

	JSR update_transition

	JSR update_high_score

  JMP stay_here
.endproc

.proc load_background_result
	LDA #$00
	LDX #$00
	reset_draw:
	STA draw, X
	INX
	BPL reset_draw

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

  .lobytes save_scores

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

  .hibytes save_scores

.endproc

.proc save_scores
	LDA #$00
	STA crown

	LDA mods
	LSR
	BCC :+
	JMP stay_here
	:
	LDA clear_bar+6
	BEQ :+
	LDA #$01
	STA crown

	LDA bad_count
	BNE :+
	LDA bad_count+1
	BNE :+
	LDA bad_count+2
	BNE :+
	LDA bad_count+3
	BNE :+
	LDA #$02
	STA crown
	:

	LDY #$00
	save_score:
	LDA score, Y
	CMP (sram_location), Y
	BCC :++
	BEQ :+
	write_score:
	LDA score, Y
	STA (sram_location), Y
	LDA #$01
	STA high_score
	INY
	CPY #6
	BNE write_score
	:
	INY
	CPY #6
	BCC save_score
	:

	LDA #10
	STA results_compare

	LDY #6
	LDA high_score
	BNE save_rest_alt

	LDX #$00
	save_rest:
	LDA score, Y
	CMP (sram_location), Y
	BCC :++
	BEQ :+
	write_rest:
	LDA score, Y
	STA (sram_location), Y
	INY
	CPY results_compare
	BCC write_rest
	:
	INY
	CPY results_compare
	BCC save_rest
	:
	INX
	LDA set_Y_save_rest, X
	TAY
	LDA set_res_cmp, X
	STA results_compare
	CPX #$05
	BNE save_rest

	leave_rest_alt:

	LDA crown
	CMP (sram_location), Y
	BCC :+
	BEQ :+
	STA (sram_location), Y
	:

	JMP stay_here

	save_rest_alt:
	LDA score, Y
	STA (sram_location), Y
	INY
	CPY #26
	BNE save_rest_alt

	JMP leave_rest_alt

	set_Y_save_rest:
	.byte 06, 10, 14, 18, 22, 26

	set_res_cmp:
	.byte 10, 14, 18, 22, 26, 32
.endproc

.proc update_countdown
	LSR
	BCC :+
	LDX results_jt_position
	CPX #$07
	BCS :+
	LDA #$00
  LDX #FAMISTUDIO_SFX_CH0
  JSR famistudio_sfx_play
	:

	LDX results_jt_position
	LDA countdown_jt_lo, X
	STA address_table
	LDA countdown_jt_hi, X
	STA address_table+1
	JMP (address_table)

	countdown_jt_lo:
	.lobytes update_countdown_bar, update_countdown_score, update_countdown_combo, update_countdown_roll
	.lobytes update_countdown_good, update_countdown_ok, update_countdown_bad, draw_crown, nothing

	countdown_jt_hi:
	.hibytes update_countdown_bar, update_countdown_score, update_countdown_combo, update_countdown_roll
	.hibytes update_countdown_good, update_countdown_ok, update_countdown_bad, draw_crown, nothing
.endproc

.proc update_countdown_bar
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$20
	STA draw+2
	LDA #$E8
	STA draw+3
	LDA #$D2
	STA draw+4
	STA base_clear_bar_tile_results

	LDX #$00
	STX results_position
	:

	LDX results_position

	loop_clear_bar:
	LDA clear_bar, X
	BEQ :++

	LDA clear_bar_results_inc
	AND #$04
	CMP #$04
	BNE :+
	INC draw+3
	LDA base_clear_bar_tile_results
	STA draw+4
	LDA clear_bar_results_inc
	AND #%11111000
	EOR #$80
	STA clear_bar_results_inc
	BMI :+
	DEC draw+3
	:

	INC draw+4
	DEC clear_bar, X
	INC clear_bar_results_inc
	RTS
	:

	INC results_position
	INC draw+3
	LDA base_clear_bar_tile_results
	STA draw+4

	INX
	CPX #$08
	BNE :+
	LDA #$00
	STA draw
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	CPX #$06
	BNE :+
	LDA #$02
	STA draw
	LDA #$06
	STA draw+1
	LDA #$20
	STA draw+2
	LDA #$D4
	STA draw+3
	LDA #$D7
	STA draw+4
	STA base_clear_bar_tile_results
	:

	JMP loop_clear_bar
.endproc

.proc update_countdown_score
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$21
	STA draw+2
	LDA #$72
	STA draw+3
	LDA #$20
	STA draw+4
	LDX #$06
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	CPX #$06
	BNE :+
	DEC draw+3
	DEC results_position
	RTS
	:

	LDA score, X
	BEQ :+
	INC draw+4
	DEC score, X
	RTS
	:
	DEC results_position
	DEC draw+3
	LDA #$20
	STA draw+4

	LDX results_position
	CPX #$FF
	BNE :+
	LDA #$00
	STA draw
	:

	RTS
.endproc

.proc update_countdown_combo
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$21
	STA draw+2
	LDA #$CF
	STA draw+3
	LDA #$5A
	STA draw+4
	LDX #$03
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	LDA combo, X
	BEQ :+
	INC draw+4
	DEC combo, X
	RTS
	:
.endproc

.proc load_4_digit_num
	DEC results_position
	DEC draw+3
	LDA #$5A
	STA draw+4

	LDX results_position
	CPX #$FF
	BNE :+
	LDA #$00
	STA draw
	:

	RTS
.endproc

.proc update_countdown_roll
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$22
	STA draw+2
	LDA #$0F
	STA draw+3
	LDA #$5A
	STA draw+4
	LDX #$03
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	LDA roll_count, X
	BEQ :+
	INC draw+4
	DEC roll_count, X
	RTS
	:

	JMP load_4_digit_num
.endproc

.proc update_countdown_good
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$22
	STA draw+2
	LDA #$4F
	STA draw+3
	LDA #$5A
	STA draw+4
	LDX #$03
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	LDA good_count, X
	BEQ :+
	INC draw+4
	DEC good_count, X
	RTS
	:

	JMP load_4_digit_num
.endproc

.proc update_countdown_ok
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$22
	STA draw+2
	LDA #$8F
	STA draw+3
	LDA #$5A
	STA draw+4
	LDX #$03
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	LDA ok_count, X
	BEQ :+
	INC draw+4
	DEC ok_count, X
	RTS
	:

	JMP load_4_digit_num
.endproc

.proc update_countdown_bad
	LDA ran_results_setup
	BNE :+

	LDA #$01
	STA draw
	STA ran_results_setup
	LDA #$00
	STA draw+1
	LDA #$22
	STA draw+2
	LDA #$CF
	STA draw+3
	LDA #$5A
	STA draw+4
	LDX #$03
	STX results_position
	RTS
	:

	LDX results_position
	BPL :+
	LDA #$00
	STA ran_results_setup
	INC results_jt_position
	RTS
	:

	LDA bad_count, X
	BEQ :+
	INC draw+4
	DEC bad_count, X
	RTS
	:

	JMP load_4_digit_num
.endproc

.proc draw_crown
	LDA #base_crown_X
	STA base_crown_sprite+3
	STA base_crown_sprite+19
	LDA #base_crown_X+8
	STA base_crown_sprite+7
	STA base_crown_sprite+23
	LDA #base_crown_X+16
	STA base_crown_sprite+11
	STA base_crown_sprite+27
	LDA #base_crown_X+24
	STA base_crown_sprite+15
	STA base_crown_sprite+31

	LDA #$00
	LDX #$DD
	LDY crown
	BNE :+
	LDX #$ED
	BNE :++
	:

	CPY #$02
	BNE :+
	LDA #$01
	:
	PHA

	LDA #base_crown_Y
	STA base_crown_Y_mem

	LDY #$00
	load_crown_tiles_and_pal:
	PLA
	STA base_crown_sprite+2, Y
	PHA
	LDA base_crown_Y_mem
	STA base_crown_sprite, Y
	TXA
	STA base_crown_sprite+1, Y
	INX
	INX
	INY
	INY
	INY
	INY
	CPY #16
	BCC load_crown_tiles_and_pal
	LDA #base_crown_Y+16
	STA base_crown_Y_mem
	CPY #32
	BNE load_crown_tiles_and_pal
	PLA

	LDA #$03
	JSR famistudio_sfx_sample_play

	INC results_jt_position

	RTS

	base_crown_sprite = $200
	base_crown_X = $9E
	base_crown_Y = $8F

.endproc

.proc nothing
	LDA #$00
	STA draw_bg_over_palette
	RTS
.endproc

.proc update_inputs_results
	LDA results_jt_position
	CMP #$07
	BCC dont_update_inputs
	LDA ts_ss_timer
	BNE :+

	LDA BTN_Press
	AND #%10010000
	BEQ :+

  LDA #$01
  STA fade_type
  LDA #$02
  STA fade_time
  INC ts_ss_timer

	JSR famistudio_music_stop
	LDA #$03
	JSR famistudio_sfx_sample_play

	:
	SEC

	dont_update_inputs:
	BCC skip_countdown
	RTS

	; unoptimized but idrc at this point
	; if it works it works
	skip_countdown:
	SEC
	LDA BTN_Press
	AND #BTN_A
	BEQ dont_update_inputs
	CLC

	LDA #$07
	STA results_jt_position

	LDA high_score
	BEQ :+
	LDA #48
	STA ts_ss_timer+1
	LDA #$26
	STA palette+15
	:

	LDA #$07
	STA draw
	LDA #$00
	TAY
	STA draw+1
	STA draw+12
	STA draw+20
	STA draw+28
	STA draw+36
	STA draw+44
	LDA #$21
	STA draw+2
	STA draw+13
	LDA #$6C
	STA draw+3
	LDA #$20
	STA draw+10

	skip_score:
	LDA score_keep, Y
	ADC #$20
	STA draw+4, Y
	INY
	CPY #$06
	BNE skip_score

	LDA #$04
	STA draw+11
	STA draw+19
	STA draw+27
	STA draw+35
	STA draw+43

	LDA #$22
	STA draw+21
	STA draw+29
	STA draw+37
	STA draw+45

	LDA #$CC
	STA draw+14
	STA draw+46
	LDA #$0C
	STA draw+22
	LDA #$4C
	STA draw+30
	LDA #$8C
	STA draw+38

	LDA #$10
	STA draw+51
	LDA #$00
	STA draw+52
	LDA #$20
	STA draw+53
	LDA #$E8
	STA draw+54

	LDA #$04
	STA draw+71
	LDA #$00
	STA draw+72
	LDA #$20
	STA draw+73
	LDA #$D4
	STA draw+74

	CLC
	skip_combo:
	LDA score_keep, Y
	ADC #$5A
	STA draw+9, Y
	INY
	CPY #10
	BNE skip_combo

	CLC
	skip_roll:
	LDA score_keep, Y
	ADC #$5A
	STA draw+13, Y
	INY
	CPY #14
	BNE skip_roll

	CLC
	skip_good:
	LDA score_keep, Y
	ADC #$5A
	STA draw+17, Y
	INY
	CPY #18
	BNE skip_good

	CLC
	skip_ok:
	LDA score_keep, Y
	ADC #$5A
	STA draw+21, Y
	INY
	CPY #22
	BNE skip_ok

	CLC
	skip_bad:
	LDA score_keep, Y
	ADC #$5A
	STA draw+25, Y
	INY
	CPY #26
	BNE skip_bad

	LDY #$00
	LDX #$00
	skip_clear_bar_red:
	LDA clear_bar_keep, Y
	BEQ :+
	CMP #$04
	BCC :+
	LDA #$D6
	STA draw+55, X
	INX
	LDA clear_bar_keep, Y
	SEC
	SBC #04
	:
	CLC
	ADC #$D2
	STA draw+55, X
	INX
	CPY #$06
	BCS :+
	INY
	:
	CPX #$0C
	BCC skip_clear_bar_red

	skip_clear_bar_gold:
	LDA clear_bar_keep, Y
	BEQ :+
	CMP #$04
	BCC :+
	LDA #$DB
	STA draw+55, X
	STA draw+63, X
	INX
	LDA clear_bar_keep, Y
	SEC
	SBC #04
	:
	CLC
	ADC #$D7
	STA draw+55, X
	STA draw+63, X
	INX
	TXA
	LSR
	BCS :+
	INY
	:
	CPX #$10
	BCC skip_clear_bar_gold

	RTS
.endproc

.proc update_transition
	LDA ts_ss_timer
	BEQ dont_update_transition
	INC ts_ss_timer
	CMP #$20
	BCC dont_update_transition
	JMP load_song_sel

	dont_update_transition:
	RTS
.endproc

.proc update_high_score
	LDA high_score
	BEQ dont_update_high_score
	LDA results_jt_position
	CMP #$07
	BCC dont_update_high_score
	LDA ts_ss_timer+1
	CMP #63
	BCC :+

	LDA #32
	STA ts_ss_timer+1

	LDA #$11
	STA palette+15
	:

	INC ts_ss_timer+1
	LDA ts_ss_timer+1
	CMP #48
	BNE dont_update_high_score

	LDA #$26
	STA palette+15

	dont_update_high_score:
	RTS
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
	CPX #29
	BNE background_result_load_36
	JMP stay_here

	background_result_load_36_data:
	.byte $0C, $02, $20, $E8, $D2
	.byte $04, $02, $20, $D4, $D7
	.byte $04, $02, $20, $F4, $D7
	.byte $0A, $00, $21, $F1, $47, $48, $46, $47, $02, $52, $42, $4E, $51, $44
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
	CPX #$24
	BNE background_result_load_38
	JMP stay_here

	background_result_load_38_data:
	.byte $20, $00, $23, $C0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$a0,$a0,$a0,$50,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$f0,$f0,$f0,$00

.endproc

.proc background_result_load_39
	LDA background_result_load_39_data, X
	STA draw, X
	INX
	CPX #$05
	BNE background_result_load_39
	JMP stay_here

	background_result_load_39_data:
	.byte $20, $02, $23, $E0, $00
.endproc

.proc background_result_load_40
	LDA palette_result_data, X
	STA palette, X
	INX
	CPX #$1C
	BNE background_result_load_40

	LDA #$00
	STA draw_bg_over_palette

	JMP stay_here

	palette_result_data:
	.byte $0F, $21, $11, $20
	.byte $0F, $17, $27, $20
	.byte $0F, $05, $11, $15
	.byte $0F, $21, $11, $11

	.byte $0F, $0F, $10, $20
	.byte $0F, $0F, $27, $37
	.byte $0F, $0F, $0F, $0F
.endproc

.proc main_game

  JSR update_position ; update the position bytes

  LDA PPUSCROLL_X_stored
  CLC
  ADC PPUSCROLL_X_speed
  STA PPUSCROLL_X_stored

  LDA frame_timer
  LSR
  BCS :+

  JSR metronome ; update the metronome countdowns

  JSR update_input_detection ; update the input detection pools

  LDA #$00
  STA PPUSCROLL_X_stored

  JSR update_drums ; update the drum spawning

  ; update drum tiles
  LDX #$00
  load_drum:
  LDA drum_data_pool, X
  STA draw+20, X
  INX
  CPX #21
  BNE load_drum

  JSR update_roll_gfx ; update the drum roll counter

  JSR update_attributes ; update the palette attributes

  LDA mods
  AND #%00001001
  CMP #%00001001
  BEQ :+

  JSR reset_misc_bit_2 ; set the bit 2 in misc to 0

  :

  JSR update_bars ; update bar positions

  LDA mods
  LSR
  BCS :+

  JSR update_inputs ; update inputs and drum hitting
  JMP :++
  :

  JSR update_autoplay

  LDA mods
  AND #%00001001
  CMP #%00001001
  BNE :+

  LDA frame_timer
  LSR
  BCS :+
  JSR reset_misc_bit_2 ; set the bit 2 in misc to 0

  :

  JSR update_scroll ; update scrolling

  LDA frame_timer
  AND #$01
  BEQ ineedaname

  JSR update_big_input ; update the big input timers

  JSR update_score_combo ; update the score and combo

  JSR update_clear_bar

  LDA drum_inc
  BEQ :+ ; dont increase drum hit pool position if its 0

  INC drum_hit_pool_pos+1
  LDX drum_hit_pool_pos+1
  CPX #$40 ; check for slot overflow
  BNE dont_reset_dhpp1

  LDX #$00 ; reset position
  STX drum_hit_pool_pos+1

  dont_reset_dhpp1:
  LDA #$00
  STA drum_inc ; set drum increase to 0

  :

  ineedaname:

  JSR update_input_rate ; update the input rating (GOOD, OK, BAD)

  INC sprite_flicker_toggle
  JSR update_drum_sprites ; update the drum sprites to clear bar movement
  DEC sprite_flicker_toggle

  JMP stay_here ; go to the forever loop

.endproc

.proc update_autoplay
  LDA #$00
  STA clear_bar
  STA clear_bar+1
  STA clear_bar+2
  STA clear_bar+3
  STA clear_bar+4
  STA clear_bar+5
  STA clear_bar+6
  STA clear_bar+7

  ; update the DON drum palette
  LDX drum_input_don_time
  CPX #$01
  BCS update_dinp_don
  exit_dinp_don:

  ; update the KAT drum palette
  LDX drum_input_kat_time
  CPX #$01
  BCS update_dinp_kat
  exit_dinp_kat:

  LDA roll_length+2
  BNE :+
  LDA roll_length+1
  BEQ :+
  LDA misc ; execute every 8 pixel scrolls
  AND #%00000010
  BEQ :+

  LDA #$0A
  STA drum_input_don_time

  LDA #$01
  JSR famistudio_sfx_sample_play

  LDX slot_number
  LDA drum_sprite_A, X
  AND #%11111101
  STA drum_sprite_A, X

  LDA #30
  STA roll_time

  JSR inc_roll

  RTS

  :

  LDX drum_hit_pool_pos+1
  LDY drum_hit_pool_frame_pos+1
  LDA drum_hit_pool_frame, Y
  CMP #$02
  BNE :+
  LDA drum_hit_pool_frame+1, Y
  CMP #$0B
  BCS :+

  LDA drum_hit_pool, X
  AND #%00000011
  CMP #$01
  BEQ don_ap
  CMP #$02
  BEQ kat_ap

  :

  RTS

  force_good:
  LDA #$02
  STA input_rate
  INC combo+3
  JSR add_points
  JMP clear_drum

  update_dinp_don:
  ; load the palette timer for DON
  LDX drum_input_don_time

  ; load the palette value in the pool + X
  LDA dinp_don_pal, X
  STA palette+26 ; store the value into the proper palette color slot

  ; check for the last 2 bits in the TWO location
  LDA drum_input_don_two
  AND #%11000000
  CMP #%11000000
  BNE :+ ; if its not $80, skip code
  LDA drum_input_don_two
  AND #%00000111
  TAX
  LDA dinp_don_pal_two, X ; set the lighter red for the KAT palette
  STA palette+25
  :

  DEC drum_input_don_time ; decrease the timer
  JMP exit_dinp_don

  update_dinp_kat:
  ; load the palette timer for KAT
  LDX drum_input_kat_time

  ; load the palette value in the pool + X
  LDA dinp_kat_pal, X
  STA palette+25 ; store the value into the proper palette color slot

  ; check for the last 2 bits in the TWO location
  LDA drum_input_kat_two
  AND #%11000000
  CMP #%11000000
  BNE :+ ; if its not $80, skip code
  LDA drum_input_kat_two
  AND #%00000111
  TAX
  LDA dinp_kat_pal_two, X ; set the lighter red for the DON palette
  STA palette+26
  :

  DEC drum_input_kat_time ; decrease the timer
  JMP exit_dinp_kat

  don_ap:
  LDA #$0A
  STA drum_input_don_time

  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :+
  LDA #$C2
  STA drum_input_don_two

  JSR set_sprite_to_big
  :

  LDA #$01
  JSR famistudio_sfx_sample_play

  LDX slot_number
  LDA drum_sprite_A, X
  AND #%11111101
  STA drum_sprite_A, X
  JMP force_good

  kat_ap:
  LDA #$0A
  STA drum_input_kat_time

  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :+
  LDA #$C2
  STA drum_input_kat_two

  JSR set_sprite_to_big
  :

  LDA #$02
  JSR famistudio_sfx_sample_play

  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000010
  STA drum_sprite_A, X
  JMP force_good

  set_sprite_to_big:
  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000100
  STA drum_sprite_A, X
  RTS

  add_points:
  LDA score_to_add
  ADC #45
  LDX combo
  BNE add_max
  LDX combo+1
  BNE add_max

  PHA
  LDY combo+2
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :++

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE :++

  :
  TYA
  CLC
  ASL
  TAY

  :
  PLA
  add_points_loop:
  CPY #$00
  BEQ no_longer_add_points
  CLC
  ADC #10
  BCC :+
  INC score_to_add_10
  :
  DEY
  JMP add_points_loop

  no_longer_add_points:
  STA score_to_add
  RTS

  add_max:
  CLC
  ADC #100

  TAY
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ dont_add_max

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE dont_add_max

  :
  TYA
  ADC #100
  BCC dont_add_max
  INC score_to_add_10
  TAY

  dont_add_max:
  TYA
  JMP no_longer_add_points
.endproc

.proc update_inputs
  ; reset the drum clear bytes every other frame
  LDA frame_timer
  AND #$01
  BEQ dont_reset_clear_drum
  LDA #$00
  STA draw+7
  STA draw+8
  STA draw+12
  STA draw+13
  STA draw+17
  STA draw+18
  dont_reset_clear_drum:

  ; update the DON input
  LDA BTN_Press
  AND don_inputs+2
  BNE don_branch

  ; update the KAT input
  LDA BTN_Press
  AND kat_inputs+2
  BNE kat

  exit_input:
  ; update the DON drum palette
  LDX drum_input_don_time
  CPX #$01
  BCS update_dinp_don
  exit_dinp_don:

  ; update the KAT drum palette
  LDX drum_input_kat_time
  CPX #$01
  BCS update_dinp_kat_branch
  exit_dinp_kat:

  RTS






  update_dinp_kat_branch:
  JMP update_dinp_kat

  don_branch:
  JMP don



  kat:
  LDA #$02 ; play the KAT sample
  JSR famistudio_sfx_sample_play

  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000010
  STA drum_sprite_A, X

  LDA drum_input_kat_two
  AND #%11000000
  BNE dont_rest_double_kat

  ORA #%00000010
  STA drum_input_kat_two

  dont_rest_double_kat:

  ; check for the KAT left input button bits
  LDA BTN_Press
  BIT kat_inputs
  BEQ no_kat_left ; skip if 0

  ; set the LEFT KAT bit to 1
  LDA drum_input_kat_two
  ORA #%01000000
  STA drum_input_kat_two
  LDA BTN_Press ; reload BTN_Press to A

  no_kat_left:

  ; check for the KAT right input button bits
  BIT kat_inputs+1
  BEQ no_kat_right ; skip if 0

  ; set the RIGHT KAT bit to 1
  LDA drum_input_kat_two
  ORA #%10000000
  STA drum_input_kat_two

  no_kat_right:

  ; set drum_input_kat_time to $0A
  LDA #$0A
  STA drum_input_kat_time

  ; perform drum roll code
  LDA roll_length+1
  BNE input_roll_branch_kat
  dont_input_roll_kat:

  ; load the pool positions to X and Y
  LDX drum_hit_pool_pos+1
  LDY drum_hit_pool_frame_pos+1

  LDA drum_hit_pool, X ; load the value in the drum pool + X to A
  AND #%00000011 ; set everything to 0 except bit 1 and 2
  CMP #$02 ; if its not 2 (the KAT drum), dont do anything after
  BNE dont_clear_kat

  JMP set_input_timing ; set the GOOD/OK/BAD

  dont_clear_kat:
  JMP exit_input ; exit the input code

  ; branch for drum roll
  input_roll_branch_kat:
  LDA roll_length+2
  BEQ input_roll_p2_branch_kat
  JMP dont_input_roll_kat ; stop code if its 0

  input_roll_p2_branch_kat:
  JMP input_roll_p2_kat


  update_dinp_don:
  ; load the palette timer for DON
  LDX drum_input_don_time

  ; load the palette value in the pool + X
  LDA dinp_don_pal, X
  STA palette+26 ; store the value into the proper palette color slot

  ; check for the last 2 bits in the TWO location
  LDA drum_input_don_two
  AND #%11000000
  CMP #%11000000
  BNE :+ ; if its not $80, skip code
  LDA drum_input_don_two
  AND #%00000111
  TAX
  LDA dinp_don_pal_two, X ; set the lighter red for the KAT palette
  STA palette+25
  :

  DEC drum_input_don_time ; decrease the timer
  JMP exit_dinp_don

  update_dinp_kat:
  ; load the palette timer for KAT
  LDX drum_input_kat_time

  ; load the palette value in the pool + X
  LDA dinp_kat_pal, X
  STA palette+25 ; store the value into the proper palette color slot

  ; check for the last 2 bits in the TWO location
  LDA drum_input_kat_two
  AND #%11000000
  CMP #%11000000
  BNE :+ ; if its not $80, skip code
  LDA drum_input_kat_two
  AND #%00000111
  TAX
  LDA dinp_kat_pal_two, X ; set the lighter red for the DON palette
  STA palette+26
  :

  DEC drum_input_kat_time ; decrease the timer
  JMP exit_dinp_kat




  ; branch for drum roll
  input_roll_branch_don:
  LDA roll_length+2
  BEQ input_roll_p2_branch_don
  JMP dont_input_roll_don

  input_roll_p2_branch_don:
  JMP input_roll_p2_don ; stop code if its 0



  don:
  LDA #$01 ; play the DON sample
  JSR famistudio_sfx_sample_play

  LDX slot_number
  LDA drum_sprite_A, X
  AND #%11111101
  STA drum_sprite_A, X

  LDA drum_input_don_two
  AND #%11000000
  BNE dont_rest_double_don

  ORA #%00000010
  STA drum_input_don_two

  dont_rest_double_don:

  LDA BTN_Press
  AND don_inputs
  BEQ no_don_left

  LDA drum_input_don_two
  ORA #%01000000
  STA drum_input_don_two

  no_don_left:

  LDA BTN_Press
  AND don_inputs+1
  BEQ no_don_right

  LDA drum_input_don_two
  ORA #%10000000
  STA drum_input_don_two

  no_don_right:

  ; set drum_input_don_time to $0A
  LDA #$0A
  STA drum_input_don_time

  LDA roll_length+1
  BNE input_roll_branch_don
  dont_input_roll_don:

  ; load the pool positions to X and Y
  LDX drum_hit_pool_pos+1
  LDY drum_hit_pool_frame_pos+1

  LDA drum_hit_pool, X ; load the value in the drum pool + X to A
  AND #%00000011 ; set everything to 0 except bit 1 and 2
  CMP #$01 ; if its not 1 (the DON drum), dont do anything after
  BNE dont_clear_don

  JMP set_input_timing

  dont_clear_don:
  JMP exit_input

  bad_times_1:
  .byte $12, $15

  ok_times_1:
  .byte $0E, $13

  good_times:
  .byte $0B, $0F

  ok_times_2:
  .byte $05, $04

  bad_times_2:
  .byte $01, $01

  set_input_timing:
  LDA tempo
  AND #%01000000
  CLC
  ROL
  ROL
  ROL
  TAX
  LDA drum_hit_pool_frame, Y
  CMP #$02
  BEQ set_input_timing1
  CMP #$01
  BEQ set_input_timing2
  JMP exit_input

  set_input_timing1:
  LDA drum_hit_pool_frame+1, Y
  CMP bad_times_2, X
  BCC set_bad
  CMP ok_times_2, X
  BCC set_ok
  CMP good_times, X
  BCC set_good
  CMP ok_times_1, X
  BCC set_ok
  CMP bad_times_1, X
  BCC set_bad
  JMP exit_input

  set_input_timing2:
  LDA drum_hit_pool_frame+1, Y
  BEQ set_bad
  CMP #$FF
  BCS set_bad
  JMP exit_input

  set_good:
  LDA #$02
  STA input_rate
  INC combo+3
  INC clear_bar_inputs
  JSR add_points
  JMP clear_drum

  set_ok:
  LDA #$01
  STA input_rate
  INC combo+3
  INC clear_bar_inputs
  JSR add_points_ok
  JMP clear_drum

  set_bad:
  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000001
  STA drum_sprite_A, X

  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :+

  LDA #$01
  STA drum_inc
  :

  INC clear_bar_input_miss

  LDA #$00
  STA input_rate
  STA combo
  STA combo+1
  STA combo+2
  STA combo+3
  JMP clear_drum

  add_points:
  LDA score_to_add
  ADC #45
  LDX combo
  BNE add_max
  LDX combo+1
  BNE add_max

  PHA
  LDY combo+2
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :++

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE :++

  :
  TYA
  CLC
  ASL
  TAY

  :
  PLA
  add_points_loop:
  CPY #$00
  BEQ no_longer_add_points
  CLC
  ADC #10
  BCC :+
  INC score_to_add_10
  :
  DEY
  JMP add_points_loop

  no_longer_add_points:
  STA score_to_add
  RTS

  add_max:
  CLC
  ADC #100

  TAY
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ dont_add_max

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE dont_add_max

  :
  TYA
  ADC #100
  BCC dont_add_max
  INC score_to_add_10
  TAY

  dont_add_max:
  TYA
  JMP no_longer_add_points





  add_points_ok:
  LDA score_to_add
  ADC #23
  LDX combo
  BNE add_max_ok
  LDX combo+1
  BNE add_max_ok

  PHA
  LDY combo+2
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ :++

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE :++

  :
  TYA
  CLC
  ASL
  TAY

  :
  PLA
  add_points_loop_ok:
  CPY #$00
  BEQ no_longer_add_points_ok
  CLC
  ADC #5
  BCC :+
  INC score_to_add_10
  :
  DEY
  JMP add_points_loop_ok

  no_longer_add_points_ok:
  STA score_to_add
  RTS

  add_max_ok:
  CLC
  ADC #50

  TAY
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ dont_add_max_ok

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ :+

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BNE dont_add_max_ok

  :
  TYA
  ADC #100
  BCC dont_add_max_ok
  INC score_to_add_10
  TAY

  dont_add_max_ok:
  TYA
  JMP no_longer_add_points_ok


  input_roll_p2_don:
  LDA #30
  STA roll_time

  JSR inc_roll

  JMP exit_input

  input_roll_p2_kat:
  LDA #30
  STA roll_time

  JSR inc_roll

  JMP exit_input
.endproc

.proc inc_roll
  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000001
  STA drum_sprite_A, X

  INC drum_roll+2
  LDX #$01

  increase_roll:
  LDA drum_roll+1, X
  dont_increase_num:
  CMP #$0A
  BCC escape_roll
  SEC
  SBC #$0A
  STA drum_roll+1, X
  INC drum_roll, X
  JMP increase_roll

  escape_roll:
  DEX
  CPX #$FF
  BNE increase_roll

  LDA drum_roll

  CMP #$0A
  BCC escape_rollL
  LDA #$09
  STA drum_roll
  STA drum_roll+1
  STA drum_roll+2
  STA drum_roll+3

  escape_rollL:

  INC score+4
  LDA roll_size
  BEQ not_big_roll

  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000100
  STA drum_sprite_A, X
  INC score+4
  not_big_roll:

  RTS
.endproc

.proc clear_drum
  LDA #$01
  STA draw_bg_over_palette
  LDA #$01
  STA bg_attr+1

  ; load the pool positions to X and Y
  LDX drum_hit_pool_pos+1
  LDY drum_hit_pool_frame_pos+1

  ; tranfer the bytes from the saved drum spawn position + Y to drum_disappear_position
  LDA drum_spawn_position_kept, Y
  STA drum_disappear_position
  LDA drum_spawn_position_kept+1, Y
  STA drum_disappear_position+1

  LDA drum_hit_pool, X ; load the drum pool + X to A
  PHA
  LDA tempo
  AND #%01000000
  TAX
  PLA
  AND #%00011000 ; set every bit to 0 except bit 4 and 5
  LSR
  LSR
  LSR ; shift the bits to bit 1 and 2
  CPX #$00
  BEQ :+
  CMP #$00
  BNE :+
  LDA #$01
  :
  TAX ; put the value to X
  LDY #$00 ; set Y to 0

  loop_disappearing:
  ; set the drum disappear positions to the draw buffer
  LDA drum_disappear_position
  STA draw+8, Y
  LDA drum_disappear_position+1
  STA draw+7, Y

  ; if X is 0, get out of the loop
  CPX #$00
  BEQ exit_disappearing
  DEX ; decrease X
  INY
  INY
  INY
  INY
  INY ; increase Y 5 times (to the next draw buffer write)
  INC drum_disappear_position ; increase the low disappear position byte
  LDA drum_disappear_position ; load it to A
  CMP #$20
  BNE dont_switch_nametable ; skip code below if A is not $20

  ; set low disappear position byte to 0
  LDA #$00
  STA drum_disappear_position
  LDA drum_disappear_position+1
  EOR #%00000100 ; flip the 3rd bit in the high disappear position byte
  STA drum_disappear_position+1

  dont_switch_nametable:

  JMP loop_disappearing ; loop

  exit_disappearing:

  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000011
  CMP #$03
  BEQ still_increase
  LDA drum_hit_pool, X
  AND #%00000100
  BNE :+
  still_increase:
  LDA #$01
  STA drum_inc
  :

  ; set the frame timing bytes to 0
  LDY drum_hit_pool_frame_pos+1
  LDA #$00
  STA drum_hit_pool_frame, Y
  INC drum_hit_pool_frame_pos+1
  INY
  LDA #$00
  STA drum_hit_pool_frame, Y
  INC drum_hit_pool_frame_pos+1
  INY
  CPY #128
  BNE dont_reset_dhpfp1 ; set the position to 0 if its 128

  LDA #$00
  STA drum_hit_pool_frame_pos+1

  dont_reset_dhpfp1:

  LDA #$10 ; set the rating timer (for the sprite appearing) to $10
  STA input_rate_timer
  RTS
.endproc




.proc reset_misc_bit_2
  LDA misc
  AND #%00000010
  BEQ dont_reset

  LDA misc
  EOR #%00000010
  STA misc

  dont_reset:
  RTS
.endproc






.proc update_position
  LDA position_8px
  CLC
  ADC PPUSCROLL_X_speed

  decrease:
  CMP #$08
  BCC stop_decreasing

  PHA

  ; update blanking tiles
  LDA #$01
  STA draw_bg_over_palette
  LDA #$04
  STA draw+0
  LDA #%00000110
  STA draw+1
  LDA drum_spawn_position+3
  STA draw+2
  LDA drum_spawn_position+2
  STA draw+3

  LDA misc
  ORA #%00001010
  STA misc

  LDA bg_attr_position+2
  EOR #%00000001
  STA bg_attr_position+2
  AND #$01
  BNE dont_change_bit_two

  LDA bg_attr_position+2
  EOR #%00000010
  STA bg_attr_position+2

  dont_change_bit_two:

  PLA

  SBC #$08

  INC position_8px+1
  LDX position_8px+1
  BEQ increase_8px2

  JMP decrease

  stop_decreasing:
  STA position_8px

  RTS

  increase_8px2:
  INC position_8px+2
  JMP decrease
.endproc







.proc update_input_detection
  LDX #$00
  decrease_dhpf:
  LDA drum_hit_pool_frame, X
  BEQ dont_decrease_dhpf

  INX
  LDA drum_hit_pool_frame, X
  EOR #$80
  SEC
  SBC PPUSCROLL_X_stored
  EOR #$80
  STA drum_hit_pool_frame, X
  DEX

  BVC dont_decrease_dhpf

  DEC drum_hit_pool_frame, X

  dont_decrease_dhpf:
  INX
  INX
  CPX #128
  BNE decrease_dhpf

  LDX drum_hit_pool_frame_pos+1
  LDA drum_hit_pool_frame, X
  CMP #$01
  BNE dont_add_dhpfp
  LDA drum_hit_pool_frame+1, X
  CMP #$FE
  BCS dont_add_dhpfp

  LDA #$00
  STA drum_hit_pool_frame, X
  STA drum_hit_pool_frame+1, X

  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000011
  CMP #$03
  BEQ dont_reset_combo

  LDA #$00
  STA combo
  STA combo+1
  STA combo+2
  STA combo+3

  INC clear_bar_input_miss

  INC drum_hit_pool_pos+1
  LDX drum_hit_pool_pos+1
  CPX #$40 ; check for slot overflow
  BNE dont_reset_dhpp1

  LDX #$00 ; reset position
  STX drum_hit_pool_pos+1

  dont_reset_dhpp1:

  LDY drum_hit_pool_frame_pos+1
  LDA #$00
  STA drum_hit_pool_frame, Y
  INC drum_hit_pool_frame_pos+1
  INY
  LDA #$00
  STA drum_hit_pool_frame, Y
  INC drum_hit_pool_frame_pos+1
  INY
  CPY #128
  BNE dont_reset_dhpfp1

  LDA #$00
  STA drum_hit_pool_frame_pos+1

  dont_reset_dhpfp1:

  dont_add_dhpfp:

  RTS

  dont_reset_combo:
  LDA #$01
  STA drum_inc
  JMP dont_reset_dhpp1
.endproc










.proc update_drums
  LDA misc
  AND #%00000010
  BNE update_drums_p2

  RTS

  reset_drum_spawn_position:
  SEC
  SBC #$20
  STA drum_spawn_position

  LDA drum_spawn_position+1
  EOR #%00000100
  STA drum_spawn_position+1

  JMP continue_update_drums_p2

  reset_drum_delete_position:
  SEC
  SBC #$20
  STA drum_spawn_position+2

  LDA drum_spawn_position+3
  EOR #%00000100
  STA drum_spawn_position+3

  JMP continue_update_drums_p2_again





  update_drums_p2:
  INC drum_spawn_position
  LDA drum_spawn_position
  CMP #$20
  BEQ reset_drum_spawn_position

  continue_update_drums_p2:

  INC drum_spawn_position+2
  LDA drum_spawn_position+2
  CMP #$20
  BEQ reset_drum_delete_position

  continue_update_drums_p2_again:

  JSR update_roll_inputs

  LDX roll_length
  BNE spawn_roll_branch
  escape_spawn_roll:

  LDX tiles_remaining
  BEQ update_drums_p3

  DEC tiles_remaining
  RTS

  spawn_roll_branch:
  JMP spawn_roll




  update_drums_p3:
  LDY #$00
  LDA (drum_bank_positon), Y
  BNE update_drums_p4

  RTS




  load_rol_branch:
  JMP load_rol

  update_drums_p4:
  LDY drum_hit_pool_frame_pos
  CPY #128
  BNE dont_reset_dhpfp

  LDA #$00
  STA drum_hit_pool_frame_pos
  TAY

  dont_reset_dhpfp:
  LDA #3
  STA drum_hit_pool_frame, Y

  LDA drum_spawn_position
  STA drum_spawn_position_kept, Y
  INC drum_hit_pool_frame_pos
  LDA drum_spawn_position+1
  STA drum_spawn_position_kept+1, Y
  INC drum_hit_pool_frame_pos

  INC drum_hit_pool_pos
  LDY drum_hit_pool_pos
  CPY #$40
  BNE dont_reset_dhpp

  LDY #$00
  STY drum_hit_pool_pos

  dont_reset_dhpp:
  LDX #$00
  LDA (drum_bank_positon, X)
  AND #%11000000

  CMP #$40
  BEQ force_continue

  CMP #$80
  BNE :+
  LDA beat_animation
  EOR #$01
  STA beat_animation
  :

  CMP #$C0
  BNE :+
  JMP end_song
  :

  LDA (drum_bank_positon, X)
  PHA
  LDA mods
  AND #$04
  TAX
  PLA
  CPX #$00
  BEQ :+
  EOR #%00000011
  BNE :+
  EOR #%00000011
  :
  STA drum_hit_pool, Y
  AND #%00000011

  LDX #$00

  CMP #$01
  BEQ load_don

  CMP #$02
  BEQ load_kat

  CMP #$03
  BEQ load_rol_branch

  RTS

  force_continue:
  JMP done_drawing_small_don






  load_don:
  LDA #$01
  STA draw_bg_over_palette

  LDA (drum_bank_positon, X)
  AND #%00000100
  LSR A
  LSR A

  BNE load_big_don_branch

  LDA mods
  AND #$02
  BNE done_drawing_small_don

  JSR prepare_data_small

  ; tiles
  LDY #$30
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+10
  INY
  STY drum_data_pool+11

  done_drawing_small_don:

  LDA tempo
  AND #%01000000
  TAY

  JSR inc_dbp
  LDA (drum_bank_positon, X)
  CPY #$00
  BEQ :+
  ASL
  ADC #$01
  :
  STA tiles_remaining

  JSR inc_dbp
  RTS

  load_big_don_branch:
  JMP load_big_don






  load_big_kat_branch:
  JMP load_big_kat

  load_kat:
  LDA #$01
  STA draw_bg_over_palette

  LDA (drum_bank_positon, X)
  AND #%00000100
  LSR A
  LSR A

  BNE load_big_kat_branch

  LDA mods
  AND #$02
  BNE done_drawing_small_kat

  JSR prepare_data_small

  ; tiles
  LDY #$34
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+10
  INY
  STY drum_data_pool+11

  done_drawing_small_kat:
  JMP done_drawing_small_don
  RTS







  load_big_rol_branch:
  JMP load_big_rol

  load_attr_roll_R:
  LDA #%01010101
  STA bg_attr
  JMP leave_attr_roll

  load_attr_roll_B:
  LDA drum_spawn_position
  AND #$02
  BNE leave_attr_roll_2

  LDA #%01010101
  STA bg_attr
  JMP leave_attr_roll_2

  dont_draw_rol:
  JMP :+

  load_rol:

  LDA #$01
  STA draw_bg_over_palette

  LDA #$1E
  STA roll_length+2

  LDA mods
  AND #$02
  BNE dont_draw_rol

  LDA bg_attr_position+2
  AND #%00000010
  BEQ load_attr_roll_R

  LDA #%01000100
  STA bg_attr

  leave_attr_roll:

  LDA drum_spawn_position
  AND #$01
  BNE load_attr_roll_B

  leave_attr_roll_2:

  LDA (drum_bank_positon, X)
  AND #%00000100
  LSR A
  LSR A
  STA roll_size

  BNE load_big_rol_branch

  LDA #%01000000
  STA stop_save

  JSR prepare_data_small

  ; tiles
  LDY #$48
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+10
  INY
  STY drum_data_pool+11

  :

  LDA tempo
  AND #%01000000
  TAY

  JSR inc_dbp
  LDA (drum_bank_positon, X)
  CPY #$00
  BEQ :+
  ASL
  ADC #$01
  :
  STA tiles_remaining

  JSR inc_dbp

  LDA (drum_bank_positon, X)
  AND #$7F
  CPY #$00
  BEQ :+
  ASL
  ADC #$02
  :

  STA roll_length
  CLC
  ADC #$03
  STA roll_length+1

  DEC roll_length
  INC drum_bank_positon
  RTS













  load_big_kat:
  LDA mods
  AND #$02
  BNE :+

  LDA #$01
  STA draw_bg_over_palette

  JSR prepare_data_big

  LDY #$40
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+6
  INY
  STY drum_data_pool+11
  INY
  STY drum_data_pool+12
  INY
  STY drum_data_pool+13
  INY
  STY drum_data_pool+18
  INY
  STY drum_data_pool+19
  LDY #$00
  STY drum_data_pool+20

  :

  JMP done_drawing_small_kat

  load_big_don:
  LDA mods
  AND #$02
  BNE :+

  LDA #$01
  STA draw_bg_over_palette

  JSR prepare_data_big

  LDY #$38
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+6
  INY
  STY drum_data_pool+11
  INY
  STY drum_data_pool+12
  INY
  STY drum_data_pool+13
  INY
  STY drum_data_pool+18
  INY
  STY drum_data_pool+19
  LDY #$00
  STY drum_data_pool+20

  :

  JMP done_drawing_small_don

  dont_draw_big_rol:
  JMP :+

  load_big_rol:
  LDA mods
  AND #$02
  BNE dont_draw_big_rol

  LDA #$01
  STA draw_bg_over_palette

  LDA #%01100000
  STA stop_save

  LDA #$03
  STA drum_data_pool
  STA drum_data_pool+7
  STA drum_data_pool+14
  ; attributes
  LDA #%00000100
  STA drum_data_pool+1
  STA drum_data_pool+8
  STA drum_data_pool+15
  ; PPU high byte
  LDA drum_spawn_position+1
  STA drum_data_pool+2
  STA drum_data_pool+9
  STA drum_data_pool+16
  ; PPU low byte
  LDA drum_spawn_position
  STA drum_data_pool+3
  TAY
  INY
  TYA
  CMP #$20
  BCC dont_change_screen_big_roll_1

  PHA
  LDA drum_spawn_position+1
  EOR #%00000100
  STA drum_data_pool+9
  LDA drum_spawn_position
  PLA
  SEC
  SBC #$20

  dont_change_screen_big_roll_1:

  STA drum_data_pool+10
  LDA drum_spawn_position
  CLC
  ADC #$02
  CMP #$20
  BCC dont_change_screen_big_roll_2

  PHA
  LDA drum_spawn_position+1
  EOR #%00000100
  STA drum_data_pool+16
  LDA drum_spawn_position
  PLA
  SEC
  SBC #$20

  dont_change_screen_big_roll_2:
  STA drum_data_pool+17

  ; tiles
  LDY #$50
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+6
  INY
  STY drum_data_pool+11
  INY
  STY drum_data_pool+12
  INY
  STY drum_data_pool+13
  INY
  STY drum_data_pool+18
  INY
  STY drum_data_pool+19
  INY
  STY drum_data_pool+20

  :

  LDA tempo
  AND #%01000000
  TAY

  JSR inc_dbp
  LDA (drum_bank_positon, X)
  CPY #$00
  BEQ :+
  ASL
  ADC #$01
  :
  STA tiles_remaining

  JSR inc_dbp

  LDA (drum_bank_positon, X)
  CPY #$00
  BEQ :+
  ASL
  ADC #$01
  :
  STA roll_length
  CLC
  ADC #$03
  STA roll_length+1

  INC drum_bank_positon
  RTS














  prepare_data_small:

  LDA #$02
  STA drum_data_pool ; length 1
  STA drum_data_pool+6 ; length 2
  LDA #%00000100 ; attributes
  STA drum_data_pool+1 ; 1
  STA drum_data_pool+7 ; 2
  LDA drum_spawn_position+1 ; high byte PPU loc
  STA drum_data_pool+2 ; 1
  STA drum_data_pool+8 ; 2
  LDA drum_spawn_position ; low byte PPU loc
  CLC
  ADC #$20 ; add 20 (+1 height tile)
  STA drum_data_pool+3 ; 1
  CMP #$3F
  BCC dont_change_screen_small

  PHA ; push A to stack
  LDA drum_spawn_position+1 ; load high byte PPU location
  EOR #%00000100 ; flip 3rd bit (next screen)
  STA drum_data_pool+8 ; store to drum part 2
  LDA drum_spawn_position ; load low byte PPU location
  PLA ; pull A from stack
  SEC
  SBC #$20 ; subtract $20

  dont_change_screen_small:
  TAY
  INY
  STY drum_data_pool+9 ; 2

  RTS

  prepare_data_big:

  LDA #$03
  STA drum_data_pool
  STA drum_data_pool+7
  STA drum_data_pool+14
  ; attributes
  LDA #%00000100
  STA drum_data_pool+1
  STA drum_data_pool+8
  STA drum_data_pool+15
  ; PPU high byte
  LDA drum_spawn_position+1
  STA drum_data_pool+2
  STA drum_data_pool+9
  STA drum_data_pool+16
  ; PPU low byte
  LDA drum_spawn_position
  STA drum_data_pool+3
  TAY
  INY
  TYA
  CMP #$20
  BCC dont_change_screen_big_1

  PHA
  LDA drum_spawn_position+1
  EOR #%00000100
  STA drum_data_pool+8
  LDA drum_spawn_position
  PLA
  SEC
  SBC #$20

  dont_change_screen_big_1:

  STA drum_data_pool+10
  LDA drum_spawn_position
  CLC
  ADC #$22
  CMP #$40
  BCC dont_change_screen_big_2

  PHA
  LDA drum_spawn_position+1
  EOR #%00000100
  STA drum_data_pool+16
  LDA drum_spawn_position
  PLA
  SEC
  SBC #$20

  dont_change_screen_big_2:
  STA drum_data_pool+17

  RTS





  stop:
  TYA
  STA stop_save
  JMP escape_spawn_roll

  spawn_roll:
  LDA mods
  AND #$02
  BNE stop

  LDA #$01
  STA draw_bg_over_palette

  LDA stop_save
  ROL
  TAY
  AND #%10000000
  BNE stop

  LDA #$00
  STA stop_save

  CPX #$01
  BEQ spawn_roll_last

  LDY roll_size
  BNE spawn_roll_big

  LDA #$02
  STA drum_data_pool ; length
  LDA #%00000100
  STA drum_data_pool+1
  LDA drum_spawn_position+1 ; high byte PPU loc
  STA drum_data_pool+2 ; 1
  LDA drum_spawn_position ; low byte PPU loc
  CLC
  ADC #$20 ; add 20 (+1 height tile)
  STA drum_data_pool+3 ; 1

  ; tiles
  LDY #$4C
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5

  ; attributes
  LDA bg_attr_position+2
  AND #%00000010
  BEQ spawn_attr_R

  LDA bg_attr
  ORA #%01010101
  STA bg_attr

  end_spawn_attr:

  DEC roll_length

  JMP escape_spawn_roll

  spawn_attr_R:

  LDA bg_attr
  ORA #%00010001
  STA bg_attr

  JMP end_spawn_attr

  spawn_roll_big:
  LDA #$03
  STA drum_data_pool ; length
  LDA #%00000100
  STA drum_data_pool+1
  LDA drum_spawn_position+1 ; high byte PPU loc
  STA drum_data_pool+2 ; 1
  LDA drum_spawn_position ; low byte PPU loc
  STA drum_data_pool+3 ; 1

  ; tiles
  LDY #$59
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+6

  ; attributes
  LDA bg_attr_position+2
  AND #%00000010
  BEQ spawn_attr_R_big

  LDA bg_attr
  ORA #%01010101
  STA bg_attr

  end_spawn_attr_big:

  DEC roll_length

  JMP escape_spawn_roll

  spawn_attr_R_big:

  LDA bg_attr
  ORA #%00010001
  STA bg_attr

  JMP end_spawn_attr_big



  spawn_roll_last:
  LDA #$01
  STA draw_bg_over_palette

  LDY roll_size
  BNE spawn_roll_last_big

  LDA #$02
  STA drum_data_pool ; length
  LDA #%00000100
  STA drum_data_pool+1
  LDA drum_spawn_position+1 ; high byte PPU loc
  STA drum_data_pool+2 ; 1
  LDA drum_spawn_position ; low byte PPU loc
  CLC
  ADC #$20 ; add 20 (+1 height tile)
  STA drum_data_pool+3 ; 1

  ; tiles
  LDY #$4E
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5

  ; attributes
  LDA bg_attr_position+2
  AND #%00000010
  BNE spawn_attr_F_end

  LDA bg_attr
  ORA #%00010001
  STA bg_attr

  end_spawn_attr_end:

  DEC roll_length

  JMP escape_spawn_roll

  spawn_attr_F_end:
  LDA #%01010101
  STA bg_attr

  JMP end_spawn_attr_end

  spawn_roll_last_big:
  LDA #$03
  STA drum_data_pool ; length
  LDA #%00000100
  STA drum_data_pool+1
  LDA drum_spawn_position+1 ; high byte PPU loc
  STA drum_data_pool+2 ; 1
  LDA drum_spawn_position ; low byte PPU loc
  STA drum_data_pool+3 ; 1

  ; tiles
  LDY #$5C
  STY drum_data_pool+4
  INY
  STY drum_data_pool+5
  INY
  STY drum_data_pool+6

  ; attributes
  LDA bg_attr_position+2
  AND #%00000010
  BNE spawn_attr_F_end_big

  LDA bg_attr
  ORA #%00010001
  STA bg_attr

  end_spawn_attr_end_big:

  DEC roll_length

  JMP escape_spawn_roll

  spawn_attr_F_end_big:
  LDA #%01010101
  STA bg_attr

  JMP end_spawn_attr_end_big






  end_uri:
  CMP #$FF
  BEQ end_uri_alt
  RTS

  end_uri_alt:
  INC roll_length+2
  DEC roll_length+1
  RTS

  update_roll_inputs:
  LDA roll_length+1
  BEQ end_uri
  DEC roll_length+2
  LDA roll_length+2
  BNE end_uri
  DEC roll_length+1
  RTS







  end_song:
  DEC end_song_timer
  LDA end_song_timer
  BNE :+

  JMP load_results
  :

  CMP #$09
  BNE :+
  LDA #$02
  STA fade_time
  LDA #$01
  STA fade_type
  :

  RTS
.endproc




.proc update_attributes
  LDX metronome_v
  DEX
  BNE dont_update_attr

  LDA misc
  AND #%00000100
  BEQ dont_update_attr

  LDA bg_attr+1
  BNE dont_update_attr

  INC bg_attr_position+1
  LDX bg_attr_position+1
  CPX #$D8
  BNE dont_update_nametable

  LDX #$D0
  STX bg_attr_position+1
  LDA bg_attr_position
  EOR #%00000100
  STA bg_attr_position

  dont_update_nametable:

  INC bg_attr_position+4
  LDX bg_attr_position+4
  CPX #$D8
  BNE dont_update_nametable_2

  LDX #$D0
  STX bg_attr_position+4
  LDA bg_attr_position+3
  EOR #%00000100
  STA bg_attr_position+3

  dont_update_nametable_2:

  LDA misc
  EOR #%00000100
  STA misc

  dont_update_attr:

  LDA #$00
  STA bg_attr+1
  RTS
.endproc




.proc update_scroll
  LDA tempo
  AND #$80
  BNE update_scroll_2x

  LDA tempo
  AND #%00111111
  TAX
  LDY tempo+1
  LDA tempo_tables_lo, X
  STA address_table
  LDA tempo_tables_hi, X
  STA address_table+1
  LDA (address_table), Y
  PHA
  PHA
  LDA tempo
  AND #%01000000
  TAY
  PLA
  AND #%00011111
  CPY #$00
  BEQ :+
  ASL
  :
  STA PPUSCROLL_X_speed

  INC tempo+1
  PLA
  AND #%00100000
  BEQ :+
  LDA #$00
  STA tempo+1
  :


  RTS

  update_scroll_2x:
  LDA tempo
  AND #%00111111
  TAX
  LDY tempo+1
  LDA tempo_tables_lo_2x, X
  STA address_table
  LDA tempo_tables_hi_2x, X
  STA address_table+1
  LDA (address_table), Y
  PHA
  PHA
  LDA tempo
  AND #%01000000
  TAY
  PLA
  AND #%00011111
  CPY #$00
  BEQ :+
  ASL
  :
  STA PPUSCROLL_X_speed

  INC tempo+1
  PLA
  AND #%00100000
  BEQ :+
  LDA #$00
  STA tempo+1
  :

  RTS

tempo_tables_lo:
  .lobytes tempo_1_table, tempo_2_table, tempo_3_table, tempo_4_table
  .lobytes tempo_5_table, tempo_6_table, tempo_7_table, tempo_8_table

tempo_tables_hi:
  .hibytes tempo_1_table, tempo_2_table, tempo_3_table, tempo_4_table
  .hibytes tempo_5_table, tempo_6_table, tempo_7_table, tempo_8_table

tempo_tables_lo_2x:
  .lobytes tempo_1_table_2x, tempo_2_table_2x, tempo_3_table_2x, tempo_4_table_2x
  .lobytes tempo_5_table_2x, tempo_6_table_2x, tempo_7_table_2x, tempo_8_table_2x

tempo_tables_hi_2x:
  .hibytes tempo_1_table_2x, tempo_2_table_2x, tempo_3_table_2x, tempo_4_table_2x
  .hibytes tempo_5_table_2x, tempo_6_table_2x, tempo_7_table_2x, tempo_8_table_2x

tempo_1_table:
  .byte $01, $01, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $01, $00, $20

tempo_2_table:
  .byte $01, $01, $00, $01, $01, $00, $20

tempo_3_table:
  .byte $01, $01, $00, $01, $01, $00, $01, $01, $00, $01, $01, $00, $20

tempo_4_table:
  .byte $01, $01, $01, $00, $01, $01, $01, $00, $01, $01, $00, $20

tempo_5_table:
  .byte $01, $01, $01, $00, $01, $01, $01, $00, $01, $01, $20

tempo_6_table:
  .byte $01, $01, $01, $01, $20

tempo_7_table:
  .byte $01, $01, $01, $01, $01, $01, $01, $01, $20

tempo_8_table:
  .byte $21



tempo_1_table_2x:
  .byte $01, $01, $01, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $21

tempo_2_table_2x:
  .byte $01, $01, $01, $02, $01, $01, $21

tempo_3_table_2x:
  .byte $01, $01, $01, $02, $01, $01, $02, $01, $01, $02, $01, $01, $21

tempo_4_table_2x:
  .byte $01, $02, $01, $01, $02, $02, $01, $01, $02, $01, $01, $21

tempo_5_table_2x:
  .byte $02, $02, $01, $01, $02, $02, $01, $01, $02, $01, $21

tempo_6_table_2x:
  .byte $02, $02, $02, $01, $01, $01, $02, $02, $02, $21

tempo_7_table_2x:
  .byte $02, $02, $02, $02, $02, $02, $02, $01, $21

tempo_8_table_2x:
  .byte $22
.endproc












.proc update_bars
  LDX base_sprite+2
  LDY #$00
  set_circle_sprite_data:
  LDA circle_sprite_data, Y
  STA $204, X
  INX
  INY
  CPY #24
  BNE set_circle_sprite_data

  LDX base_sprite+2
  LDY #$00
  set_bar_sprite_data:
  LDA bar_sprite_data_pool, Y
  STA $21C, X
  INX
  INY
  CPY #$10
  BNE set_bar_sprite_data

  LDA bar_x
  SEC
  SBC PPUSCROLL_X_speed
  STA bar_x
  ; set X
  LDX base_sprite+2
  STA $21F, X
  STA $223, X
  EOR #$80
  STA $227, X
  STA $22B, X

  LDA tempo
  AND #$40
  BEQ :+
  LDA #$F0
  STA $224, X
  STA $228, X
  :

  RTS
.endproc











.proc update_input_rate
  LDY #$00
  LDX base_sprite+3
  LDA input_rate
  BEQ loop_bad
  CMP #$01
  BEQ loop_ok
  CMP #$02
  BEQ loop_good

  end_ir_setup:
  LDX input_rate_timer
  BEQ dont_update_input_rate

  LDY base_sprite+3
  LDA input_rate_y_pool, X
  STA $238, Y
  STA $23C, Y

  DEC input_rate_timer

  dont_update_input_rate:
  RTS

  loop_bad:
  LDA bad_sprite, Y
  STA $238, X
  INX
  INY
  CPY #$08
  BNE loop_bad
  JMP end_ir_setup

  loop_ok:
  LDA ok_sprite, Y
  STA $238, X
  INX
  INY
  CPY #$08
  BNE loop_ok
  JMP end_ir_setup

  loop_good:
  LDA good_sprite, Y
  STA $238, X
  INX
  INY
  CPY #$08
  BNE loop_good
  JMP end_ir_setup
.endproc

.proc update_roll_gfx
  LDY base_sprite+3
  LDA roll_time
  BNE load_roll_gfx

  LDA #$00
  STA drum_roll
  STA drum_roll+1
  STA drum_roll+2

  LDA #$F0
  STA $22C, Y
  STA $230, Y
  STA $234, Y
  RTS

  load_roll_gfx:
  DEC roll_time

  LDA #$62
  STA $22C, Y
  STA $230, Y
  STA $234, Y

  LDA #$10
  STA $22F, Y
  CLC
  ADC #$08
  STA $233, Y
  ADC #$08
  STA $237, Y

  LDA #$4E
  LDX #$FF
  loop_drum_roll:
  CLC
  ADC #$02
  STA $22D, Y
  INX
  CPX drum_roll
  BNE loop_drum_roll

  LDA #$4E
  LDX #$FF
  loop_drum_roll1:
  CLC
  ADC #$02
  STA $231, Y
  INX
  CPX drum_roll+1
  BNE loop_drum_roll1

  LDA #$4E
  LDX #$FF
  loop_drum_roll2:
  CLC
  ADC #$02
  STA $235, Y
  INX
  CPX drum_roll+2
  BNE loop_drum_roll2

  RTS
.endproc







.proc update_big_input
  LDA drum_input_don_two
  AND #%00000111
  BEQ dont_decrease_didt

  DEC drum_input_don_two
  JMP dont_reset_didt

  dont_decrease_didt:
  LDA #$00
  STA drum_input_don_two
  dont_reset_didt:

  LDA drum_input_kat_two
  AND #%00000111
  BEQ dont_decrease_dikt

  DEC drum_input_kat_two
  JMP dont_reset_dikt

  dont_decrease_dikt:
  LDA #$00
  STA drum_input_kat_two
  dont_reset_dikt:

  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ dont_update_big_input

  LDA drum_hit_pool, X
  AND #%00000011
  CMP #%00000011
  BEQ dont_update_big_input

  LDA drum_input_don_two
  AND #%11000000
  CMP #$C0
  BEQ add_extra_points

  LDA drum_input_kat_two
  AND #%11000000
  CMP #$C0
  BEQ add_extra_points

  dont_update_big_input:
  RTS

  add_extra_points:
  LDX input_rate
  BEQ dont_update_big_input
  CLC

  LDA score_to_add
  ROL
  BCC dont_increase_score_1k

  ROR
  LDX #$01
  decrease_score:
  LDA score_to_add
  CMP #$0A
  BCC escape_score
  SEC
  SBC #$0A
  STA score_to_add
  INC score_to_add_10
  JMP decrease_score

  escape_score:
  LDA score_to_add_10, X
  ASL
  STA score_to_add_10, X
  DEX
  BPL escape_score

  LDA score+4
  ADC score_to_add_10
  STA score+4
  LDA score_to_add

  dont_increase_score_1k:
  STA score_to_add

  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000100
  STA drum_sprite_A, X

  dont_reset_dhpp1:

  JMP dont_update_big_input

.endproc










.proc update_score_combo
  LDX drum_hit_pool_pos+1
  LDA drum_hit_pool, X
  AND #%00000100
  BEQ dont_check_for_big

  LDA drum_input_don_two
  AND #%11000000
  BEQ :+
  CMP #$C0
  BEQ :+

  RTS

  :

  LDA drum_input_kat_two
  AND #%11000000
  BEQ :+
  CMP #$C0
  BEQ :+

  RTS

  :

  dont_check_for_big:

  LDA score_to_add
  BEQ dont_inc_score

  LDA score+5
  CLC
  ADC score_to_add
  STA score+5

  LDX slot_number
  LDA drum_sprite_A, X
  ORA #%00000001
  STA drum_sprite_A, X

  LDA #$01
  STA drum_inc

  LDA #$00
  STA score_to_add

  dont_inc_score:

  LDX #$02
  decrease_combo:
  LDA combo+1, X
  CMP #$0A
  BCC escape_combo
  SEC
  SBC #$0A
  STA combo+1, X
  INC combo, X
  JMP decrease_combo

  escape_combo:
  DEX
  CPX #$FF
  BNE decrease_combo

  LDA combo

  CMP #$0A
  BCC escape_comboL
  LDA #$09
  STA combo
  STA combo+1
  STA combo+2
  STA combo+3

  escape_comboL:

  LDX #$05
  decrease_score:
  LDA score+1, X
  CMP #$0A
  BCC escape_score
  SEC
  SBC #$0A
  STA score+1, X
  INC score, X
  JMP decrease_score

  escape_score:
  DEX
  BPL decrease_score

  LDA score

  CMP #$0A
  BCC escape_scoreL
  LDA #$09
  STA score
  STA score+1
  STA score+2
  STA score+3
  STA score+4
  STA score+5

  escape_scoreL:

  RTS
.endproc

.proc update_drum_sprites
  LDX #$00

  LDY slot_number
  LDA drum_sprite_A, Y
  AND #%00000100
  BEQ update_drum_sprites_small

  JMP update_drum_sprites_big

  update_drum_sprites_small:
  LDA drum_sprite_A, Y
  BIT taiko_bg_1 ; #$01 basically
  BEQ dont_update_drum_sprites

  AND #%00000010
  CLC
  ROR
  STA drum_sprite_A_type

  LDA #30
  STA drum_sprite_T, Y

  LDA sprite_location_table, Y
  CLC
  ADC base_sprite+1
  STA address_table
  LDA #$02
  STA address_table+1

  LDA #$00
  STA drum_sprite_A, Y
  INC slot_number

  loop_loading_drum_sprite:
  LDA #$46
  STA drum_sprite_Y, Y
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_tile_small, X
  LDX #$00
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_attr, X
  LDX #$00
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_X_start_table_small, X
  LDX #$00
  STA drum_sprite_X, Y
  STA (address_table, X)

  INC address_table

  LDA drum_sprite_A_type
  EOR #$02
  STA drum_sprite_A_type
  AND #$02

  BNE loop_loading_drum_sprite

  dont_update_drum_sprites:

  LDX #$00
  loop_ds_timer:
  LDA drum_sprite_T, X
  BNE perform_drum_update
  return_ds_timer:
  INC slot_number+1
  INX
  CPX #$08
  BNE loop_ds_timer

  LDA #$00
  STA slot_number+1

  JSR loop_ds_timer_big_jsr

  LDA slot_number
  CMP #$08
  BCS reset_slot_number
  RTS

  reset_slot_number:
  SBC #$08
  STA slot_number
  RTS

  perform_drum_update:
  TXA
  PHA

  LDA #$08
  STA drum_sprite_X_incr

  LDY slot_number+1
  LDA sprite_location_table, Y
  CLC
  ADC base_sprite+1
  ADC #$07
  STA address_table
  LDA #$02
  STA address_table+1

  perform_drum_update_loop:
  LDX drum_sprite_T, Y
  LDA drum_sprite_X, Y
  ADC drum_sprite_X_table, X
  LDX #$00
  ADC drum_sprite_X_incr
  STA (address_table, X)

  DEC address_table
  DEC address_table
  DEC address_table

  LDX drum_sprite_T, Y
  LDA drum_sprite_Y_table, X
  LSR
  LSR
  LSR
  LSR
  STA drum_sprite_Y_kept

  CPX #11
  BCC decrease_drum_Y

  LDA drum_sprite_Y, Y
  ADC drum_sprite_Y_kept
  LDX #$00
  STA (address_table, X)

  return_to_dul:

  DEC address_table

  LDA drum_sprite_X_incr
  EOR #$08
  STA drum_sprite_X_incr
  BEQ perform_drum_update_loop

  LDX drum_sprite_T, Y
  LDA drum_sprite_X, Y
  ADC drum_sprite_X_table, X
  STA drum_sprite_X, Y

  LDA drum_sprite_Y, Y
  CPX #11
  BCC decrease_drum_Y_after
  ADC drum_sprite_Y_kept
  continue_drum_Y_after:
  STA drum_sprite_Y, Y

  PLA
  TAX
  DEC drum_sprite_T, X
  JMP return_ds_timer

  decrease_drum_Y_after:
  SEC
  SBC drum_sprite_Y_kept
  JMP continue_drum_Y_after

  decrease_drum_Y:
  CPX #$01
  BEQ set_sprites_offsceen

  LDA drum_sprite_Y, Y
  SEC
  SBC drum_sprite_Y_kept
  LDX #$00
  STA (address_table, X)

  JMP return_to_dul

  set_sprites_offsceen:
  LDA #$F0
  LDX #$00
  STA (address_table, X)

  JMP return_to_dul
















update_drum_sprites_big:
  LDA drum_sprite_A, Y
  BIT taiko_bg_1 ; #$01 basically
  BEQ dont_update_drum_sprites_big

  AND #%00000010
  CLC
  ROR
  STA drum_sprite_A_type

  LDA #$00
  STA drum_sprite_A, Y

  LDY slot_number_big

  LDA #30
  STA drum_sprite_T_big, Y

  LDA sprite_location_table_big, Y
  CLC
  ADC base_sprite+3
  STA address_table
  LDA #$02
  STA address_table+1

  LDA #$00
  STA drum_sprite_A_big, Y

  LDA slot_number_big
  EOR #$01
  STA slot_number_big

  loop_loading_drum_sprite_big:
  LDX drum_sprite_A_type
  LDA drum_sprite_Y_start_table_big, X
  LDX #$00
  STA drum_sprite_Y_big, Y
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_tile_big, X
  LDX #$00
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_attr, X
  LDX #$00
  STA (address_table, X)

  INC address_table
  LDX drum_sprite_A_type
  LDA drum_sprite_X_start_table_big, X
  LDX #$00
  STA drum_sprite_X_big, Y
  STA (address_table, X)

  INC address_table

  LDA drum_sprite_A_type
  ADC #$02
  STA drum_sprite_A_type
  AND #$FE
  ROR
  CMP #$05
  BNE loop_loading_drum_sprite_big

  dont_update_drum_sprites_big:
  JMP dont_update_drum_sprites

  loop_ds_timer_big_jsr:

  LDX #$00
  loop_ds_timer_big:
  LDA drum_sprite_T_big, X
  BNE perform_drum_update_big
  return_ds_timer_big:
  INC slot_number+1
  INX
  CPX #$02
  BNE loop_ds_timer_big

  LDA #$00
  STA slot_number+1

  RTS

perform_drum_update_big:
  TXA
  PHA

  LDA #$00
  STA drum_big_sprite_loop

  LDA #$08
  STA drum_sprite_X_incr

  LDY slot_number+1
  LDA sprite_location_table_big, Y
  CLC
  ADC base_sprite+3
  ADC #19
  STA address_table
  LDA #$02
  STA address_table+1

  perform_drum_update_loop_big:
  LDX drum_sprite_T_big, Y
  LDA drum_sprite_X_big, Y
  ADC drum_sprite_X_table, X
  LDX drum_big_sprite_loop
  ADC drum_sprite_X_incr_table_big, X
  LDX #$00
  STA (address_table, X)

  DEC address_table
  DEC address_table
  DEC address_table

  LDX drum_sprite_T_big, Y
  LDA drum_sprite_Y_table, X
  LSR
  LSR
  LSR
  LSR
  STA drum_sprite_Y_kept

  CPX #11
  BCC decrease_drum_Y_big

  LDA drum_sprite_Y_big, Y
  LDX drum_big_sprite_loop
  ADC drum_sprite_Y_incr_table_big, X
  ADC drum_sprite_Y_kept
  LDX #$00
  STA (address_table, X)

  return_to_dul_big:

  DEC address_table

  INC drum_big_sprite_loop
  LDA drum_big_sprite_loop
  CMP #$05
  BNE perform_drum_update_loop_big

  LDX drum_sprite_T_big, Y
  LDA drum_sprite_X_big, Y
  ADC #$06
  STA drum_sprite_X_big, Y

  LDA drum_sprite_Y_big, Y
  CPX #11
  BCC decrease_drum_Y_after_big
  ADC drum_sprite_Y_kept
  continue_drum_Y_after_big:
  STA drum_sprite_Y_big, Y

  PLA
  TAX
  DEC drum_sprite_T_big, X

  JMP return_ds_timer_big

  decrease_drum_Y_after_big:
  SEC
  SBC drum_sprite_Y_kept
  JMP continue_drum_Y_after_big

  decrease_drum_Y_big:
  CPX #$01
  BEQ set_sprites_offsceen_big

  LDA drum_sprite_Y_big, Y
  SEC
  SBC drum_sprite_Y_kept
  LDX drum_big_sprite_loop
  ADC drum_sprite_Y_incr_table_big, X
  LDX #$00
  STA (address_table, X)

  JMP return_to_dul_big

  set_sprites_offsceen_big:
  LDA #$F0
  LDX #$00
  STA (address_table, X)

  JMP return_to_dul_big











drum_sprite_X_table:
  .byte 7, 6, 7, 6, 7, 6, 6, 7, 6, 7
  .byte 7, 6, 7, 6, 7, 6, 6, 7, 6, 7
  .byte 7, 6, 7, 6, 7, 6, 6, 7, 6, 7
  .byte 7

drum_sprite_X_incr_table_big:
  .byte $08, $00, $10, $08, $00

drum_sprite_Y_incr_table_big:
  .byte $10, $10, $08, $00, $00

drum_sprite_Y_table:
    .byte $44, $3E, $38, $32, $2C, $26, $1F, $19, $13, $0D, $06, $03
    .byte $00, $00, $03, $06, $0D, $13, $19, $1F, $26, $2C, $32, $38, $3E, $44, $4A, $50, $56, $5C

sprite_location_table:
    .byte $00, $08, $10, $18, $20, $28, $30, $38

sprite_location_table_big:
    .byte $00, $14

drum_sprite_tile_small:
    .byte $10, $14
    .byte $12, $16

drum_sprite_attr:
    .byte $00, $01
    .byte $00, $01
    .byte $00, $01
    .byte $00, $01
    .byte $00, $01

drum_sprite_X_start_table_small:
    .byte $11, $11
    .byte $19, $19

drum_sprite_X_start_table_big:
    .byte $0F, $0F
    .byte $17, $17
    .byte $1F, $1F
    .byte $0F, $0F
    .byte $17, $17

drum_sprite_Y_start_table_big:
    .byte $2E, $2E
    .byte $2E, $2E
    .byte $36, $36
    .byte $3E, $3E
    .byte $3E, $3E

drum_sprite_tile_big:
    .byte $18, $22
    .byte $1A, $24
    .byte $1C, $26
    .byte $1E, $28
    .byte $20, $2A

.endproc










.proc update_clear_bar
  LDA clear_bar_inputs
  CMP clear_bar_inputs+1
  BNE dont_increase_cb

  INC clear_bar
  LDA #$00
  STA clear_bar_inputs

  dont_increase_cb:

  LDA clear_bar_input_miss
  CMP clear_bar_input_miss+1
  BNE :+

  LDX #$07
  dont_decrease_cb_loop:
  LDA clear_bar, X
  BEQ dont_decrease_cb
  DEC clear_bar, X
  JMP escape_decrease_cb
  dont_decrease_cb:
  DEX
  BPL dont_decrease_cb_loop

  escape_decrease_cb:
  LDA #$00
  STA clear_bar_input_miss

  :

  LDX #$06
  decrease_cb:
  LDA clear_bar+1, X

  BPL escape_d_cb
  LDA #$00
  STA clear_bar+1, X
  DEC clear_bar, X

  escape_d_cb:
  DEX
  BPL decrease_cb

  LDA clear_bar
  BPL dont_reset_cb

  LDA #$00
  STA clear_bar

  dont_reset_cb:

  LDX #$00
  increase_cb:
  LDA clear_bar, X
  CMP #$09
  BCC escape_cb
  LDA #$08
  STA clear_bar, X
  INC clear_bar+1, X
  JMP increase_cb

  escape_cb:
  INX
  CPX #$07
  BNE increase_cb

  LDA clear_bar+7

  CMP #$08
  BCC escape_cbL
  LDA #$08
  STA clear_bar
  STA clear_bar+1
  STA clear_bar+2
  STA clear_bar+3
  STA clear_bar+4
  STA clear_bar+5
  STA clear_bar+6
  STA clear_bar+7

  escape_cbL:

  LDX #$02
  LDA clear_bar+7
  CMP #$08
  BEQ set_bg_palette_4
  LDA clear_bar+6
  BNE set_bg_palette_3
  LDA clear_bar+4
  BNE set_bg_palette_2
  LDA clear_bar+2
  BNE set_bg_palette_1

  set_bg_palette_0:
  LDA #$0F
  STA palette+13, X
  DEX
  BPL set_bg_palette_0

  RTS

  set_bg_palette_1:
  LDA bg_pal_1_table, X
  STA palette+13, X
  DEX
  BPL set_bg_palette_1
  RTS

  set_bg_palette_2:
  LDA bg_pal_2_table, X
  STA palette+13, X
  DEX
  BPL set_bg_palette_2
  RTS

  set_bg_palette_3:
  LDA bg_pal_3_table, X
  STA palette+13, X
  DEX
  BPL set_bg_palette_3
  RTS

  set_bg_palette_4:
  LDA bg_attr_position+2
  BEQ set_bg_palette_4_a

  LDA clear_bar_timer
  BNE set_bg_palette_4_b
  JMP set_bg_palette_3

  set_bg_palette_4_a:
  LDA #$02
  STA clear_bar_timer
  LDA bg_pal_4_table_A, X
  STA palette+13, X
  DEX
  BPL set_bg_palette_4_a

  RTS

  set_bg_palette_4_b:
  LDA bg_pal_4_table_B, X
  STA palette+13, X
  DEX
  BPL set_bg_palette_4_b
  DEC clear_bar_timer
  RTS




  bg_pal_1_table:
  .byte $0F, $0F, $01

  bg_pal_2_table:
  .byte $0F, $01, $11

  bg_pal_3_table:
  .byte $01, $11, $21

  bg_pal_4_table_A:
  .byte $21, $30, $30

  bg_pal_4_table_B:
  .byte $11, $21, $30

.endproc

inc_dbp:
  LDA drum_bank_positon
  EOR #$80
  CLC
  ADC #$01
  EOR #$80
  BVC :+
  INC drum_bank_positon+1
  :
  STA drum_bank_positon
  RTS

main_g_pal:
  .byte $0F, $21, $16, $20
  .byte $0F, $17, $27, $20
  .byte $0F, $05, $15, $25
  .byte $0F, $0F, $0F, $0F

  .byte $0F, $27, $16, $20
  .byte $0F, $21, $00, $20
  .byte $0F, $20, $20, $2D
  .byte $0F, $0F, $0F, $0F

drum_input_sprites:
  .byte $78, $34, %00000010, $10
  .byte $78, $36, %00000010, $18
  .byte $78, $34, %01000010, $20

  .byte $78, $38, %00000010, $14
  .byte $78, $38, %01000010, $1C

dinp_don_pal:
  .byte $20, $20, $36, $36, $36, $26, $26, $26, $16, $16, $16

dinp_don_pal_two:
  .byte $20, $26, $26, $26

dinp_kat_pal:
  .byte $20, $20, $31, $31, $31, $21, $21, $21, $11, $11, $11

dinp_kat_pal_two:
  .byte $20, $21, $21, $21

bar_sprite_data_pool:
  .byte $3F, $0E, $22, $00, $4F, $0E, $22, $00
  .byte $3F, $0E, $22, $00, $4F, $0E, $22, $00

circle_sprite_data:
  .byte $41, $3A, $21, $1B
  .byte $41, $3C, $21, $23
  .byte $41, $3E, $21, $2B

  .byte $51, $40, $21, $1B
  .byte $51, $42, $21, $23
  .byte $51, $44, $21, $2B

good_sprite:
  .byte $F0, $02, $00, $20
  .byte $F0, $04, $00, $28

ok_sprite:
  .byte $F0, $06, $00, $20
  .byte $F0, $08, $00, $28

bad_sprite:
  .byte $F0, $0A, $01, $20
  .byte $F0, $0C, $01, $28

input_rate_y_pool:
  .byte $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $35, $34, $33, $34, $35, $37

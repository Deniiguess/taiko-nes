.proc nmi_handler
  PHA
  TXA
  PHA
  TYA
  PHA

  ; update PPUMASK
  LDA PPUMASK
  STA $2001 ; PPUMASK

  ; update PPUCTRL
  LDA PPUCTRL
  STA $2000 ; PPUCTRL
  AND #$80
  BNE :+
  JMP leave_nmi
  :

  LDA draw_bg_over_palette ; load draw_bg_over_palette to A
  BNE draw_background_branch ; if its 0, draw palettes

  JSR draw_palette
  JMP escape_draw_palette

  draw_background_branch:
  JSR draw_background ; if its 0, update the background

  LDA scene
  BNE escape_draw_palette

  ; clear drums in pool after drawing them
  LDX #$00
  clear_drum:
  LDA #$00
  STA drum_data_pool, X
  INX
  CPX #21
  BNE clear_drum

  escape_draw_palette:

    ; update sprites
  LDA #$00
  STA $2003 ; OAMADDR
  LDA #$02
  STA $4014 ; OAMDMA
  LDA PPUSCROLL_X
  STA $2005
  LDA PPUSCROLL_Y
  STA $2005
    ldx #1             ; get put          <- strobe code must take an odd number of cycles total
    stx BTN_Hold+0      ; get put get      <- buttons must be in the zeropage
    stx $4016          ; put get put get
    dex                ; put get
    stx $4016          ; put get put get
loop:
    lda $4017          ; put get put GET  <- loop code must take an even number of cycles total
    and #3             ; put get
    cmp #1             ; put get
    rol BTN_Hold+1, x   ; put get put get put get (X = 0; waste 1 cycle for alignment)
    lda $4016          ; put get put GET
    and #3             ; put get
    cmp #1             ; put get
    rol BTN_Hold+0      ; put get put get put
    bcc loop           ; get put [get]    <- this branch must not be allowed to cross a page

  ; update PPUCTRL again
  LDA PPUCTRL
  STA $2000 ; PPUCTRL

  ; update PPUSCROLL
  LDA PPUSCROLL_X ; load PPUSCROLL_X to A
  EOR #$80
  CLC
  ADC PPUSCROLL_X_speed ; A = PPUSCROLL_X + PPUSCROLL_X_speed
  EOR #$80
  STA PPUSCROLL_X ; store A PPUSCROLL_X
  BVC escape_change_nametable_X ; if overflow flag is 1, change nametable

  LDA PPUCTRL ; load PPUCTRL to A
  EOR #$01 ; flip the 1st bit (horizontal nametable)
  STA PPUCTRL ; store A to PPUCTRL
  LDA PPUCTRL_kept ; do the same with PPUCTRL_kept
  EOR #$01
  STA PPUCTRL_kept

  escape_change_nametable_X:
  LDA PPUSCROLL_Y_speed ; load PPUSCROLL_Y_speed to A
  BPL :+ ; check if its negative
  ; if yes run this*
  LDA PPUSCROLL_Y ; load PPUSCROLL_Y to A
  CLC
  ADC PPUSCROLL_Y_speed ; add PPUSCROLL_Y_speed
  STA PPUSCROLL_Y ; store A to PPUSCROLL_Y
  BCS escape_change_nametable_Y ; if not overflowed, dont change nametable
  ADC #$F0 ; add -$10 to PPUSCROLL_Y
  STA PPUSCROLL_Y

  JMP :++ ; do the nametable thingies
  :

  LDA PPUSCROLL_Y
  CLC
  ADC #$10
  STA PPUSCROLL_Y

  ; *otherwise run this instead
  LDA PPUSCROLL_Y ; load PPUSCROLL_Y to A
  CLC
  ADC PPUSCROLL_Y_speed ; add PPUSCROLL_Y_speed
  STA PPUSCROLL_Y ; store A to PPUSCROLL_Y
  BCC escape_change_nametable_Y ; if overflowed, change nametable

  :
  LDA PPUCTRL ; load PPUCTRL to A
  EOR #$02 ; flip the 2nd bit (vertical nametable)
  STA PPUCTRL ; store A to PPUCTRL
  LDA PPUCTRL_kept ; flip the 2nd bit in PPUCTRL_kept too
  EOR #$02
  STA PPUCTRL_kept
  JMP :+

  escape_change_nametable_Y:

  LDA PPUSCROLL_Y_speed
  BMI :+
  LDA PPUSCROLL_Y
  CLC
  ADC #$F0
  STA PPUSCROLL_Y
  :

  JSR famistudio_update ; update audio

  LDA misc
  AND #$01
  BNE split_x_scrolling_branch ; branch if the sprite 0 bit (bit 1) in misc is enabled
  escape_split_x_scrolling:

  LDA sprite_flicker_toggle
  AND #$01
  BNE :+
  JSR sprite_flicker ; change sprite priorities
  :

  JSR update_controller_1 ; update controller holding and presses
  ; less cycles and bytes if TWO_CONTROLLERS is disabled

  LDA PRGROM_buf
  STA $F800 ; restore PRG-ROM read-write because the sound engine does stuff with it

  INC frame_timer ; increase frame_timer

  leave_nmi:
  JSR update_fade

  ; make the 8th bit in misc 0 to get out of the loop
  LDA misc
  AND #%01111111
  STA misc

  pla ; restore Y
  tay
  pla ; restore X
  tax
  pla ; restore A
  RTI

  split_x_scrolling_branch:
  JSR split_x_scrolling
  JMP escape_split_x_scrolling

  scroll_Y_values:
  .byte $00, $F0
.endproc


.proc update_fade
  LDA fade_time
  BEQ dont_fade

  INC fade_time+1
  LDA fade_time+1
  CMP fade_time
  BNE dont_fade

  LDA fade_type
  BEQ :+

  INC fade_intensity
  LDA #$00
  STA fade_time+1

  LDA fade_intensity
  AND #%00000111
  CMP #$05
  BCC stop_fade
  PHA
  LDA #$00
  STA fade_time
  PLA
  BCC stop_fade
  :

  DEC fade_intensity
  LDA #$00
  STA fade_time+1

  LDA fade_intensity
  AND #%00000111
  CMP #$05
  BCC :+
  LDA #$00
  STA fade_time
  :

  stop_fade:
  STA fade_intensity

  dont_fade:
  RTS
.endproc



.proc draw_background
  LDY #$00 ; reset Y (first time drawing)

  draw_background_sub_loop:
  LDA draw, Y ; loads draw length byte to A
  BNE :+ ; if the length is 0, stop drawing bg
  STA draw_bg_over_palette ; set draw_bg_over_palette to 0 (A is already 0)
  RTS
  :

  STA draw_length ; store A to draw_length
  INY ; next byte

  LDA draw, Y ; loads attributes to A
  AND #%00000111 ; get rid of extra bits
  TAX ; put A to X

  ; %-----VRN
  ; N - No PPU address changes
  ; R - RLE loading
  ; V - Vertical drawing

  ; load proper addresses
  ; depends on the attribute value
  LDA draw_attribute_locations_lo, X
  STA draw_attribute_location
  LDA draw_attribute_locations_hi, X
  STA draw_attribute_location+1

  ; jump to the proper location
  JMP (draw_attribute_location)




  draw_background_no:

  INY ; next byte
  LDA PPUSTATUS
  LDA draw, Y ; loads PPU high byte to A
  STA PPUADDR ; stores A to PPUADDR high byte
  INY ; next byte
  LDA draw, Y ; loads PPU low byte to A
  STA PPUADDR ; stores A to PPUADDR low byte

  draw_background_loop:
  LDX draw_length ; loads draw_length to X
  BEQ draw_background_exit ; if not 0, loop

  INY ; next byte

  LDA draw, Y ; loads the tile byte
  STA PPUDATA

  DEC draw_length ; decreases draw_length

  JMP draw_background_loop





  draw_background_RLE:

  INY ; next byte
  LDA PPUSTATUS
  LDA draw, Y ; loads PPU high byte to A
  STA PPUADDR ; stores A to PPUADDR high byte
  INY ; next byte
  LDA draw, Y ; loads PPU low byte to A
  STA PPUADDR ; stores A to PPUADDR low byte

  draw_background_NO_PPU_RLE:
  INY ; next byte

  draw_background_loop_RLE:

  LDX draw_length ; loads draw_length to X
  BEQ draw_background_exit ; if not 0, loop

  LDA draw, Y ; loads the tile byte
  STA PPUDATA

  DEC draw_length ; decreases draw_length

  JMP draw_background_loop_RLE




  ; set PPUCTRL ($2000) to increment by 32 instead of 1
  ; then jump to the correct location
  draw_background_VER:
  LDA PPUCTRL
  ORA #%00000100
  STA $2000
  JMP draw_background_no

  draw_background_VER_NO_PPU:
  LDA PPUCTRL
  ORA #%00000100
  STA $2000
  JMP draw_background_loop

  draw_background_VER_RLE:
  LDA PPUCTRL
  ORA #%00000100
  STA $2000
  JMP draw_background_RLE

  draw_background_VER_NO_PPU_RLE:
  LDA PPUCTRL
  ORA #%00000100
  STA $2000
  JMP draw_background_NO_PPU_RLE

  draw_background_exit:
  LDA PPUCTRL
  STA $2000

  INY ; next byte
  JMP draw_background_sub_loop ; end of section, go back to draw_background_sub_loop




  draw_attribute_locations_lo:
  .lobytes draw_background_no, draw_background_loop, draw_background_RLE, draw_background_NO_PPU_RLE, draw_background_VER, draw_background_VER_NO_PPU, draw_background_VER_RLE, draw_background_VER_NO_PPU_RLE

  draw_attribute_locations_hi:
  .hibytes draw_background_no, draw_background_loop, draw_background_RLE, draw_background_NO_PPU_RLE, draw_background_VER, draw_background_VER_NO_PPU, draw_background_VER_RLE, draw_background_VER_NO_PPU_RLE
.endproc

.proc draw_palette
  CLC
  LDA fade_intensity
  ASL
  ASL
  ASL
  ASL
  STA fade_intensity

  LDX #$00 ; load $00 to X

  ; set PPUADDR to $3F00
  LDA PPUSTATUS
  LDA #$3f
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  ; load palette bytes in memory to palette bytes in PPU ($3F00)
  draw_palette_loop:
  LDA palette, X ; load bytes from palette + X
  SEC
  SBC fade_intensity
  BPL :+
  LDA #$0F
  :
  AND #%00111111
  STA PPUDATA

  INX
  CPX #$20
  BNE draw_palette_loop

  LDA fade_intensity
  LSR
  LSR
  LSR
  LSR
  STA fade_intensity

  LDA scene
  BEQ :+

  JMP dont_do_main_stuff

  :

  LDX bg_attr
  BEQ dont_draw_bg_attr
  ; dont execute code below if bg_attr is 0

  LDA PPUSTATUS
  LDA bg_attr_position
  STA PPUADDR
  LDA bg_attr_position+1
  STA PPUADDR ; load the bytes in bg_attr_position to PPUADDR
  LDA bg_attr
  STA PPUDATA ; load the value in bg_attr to PPUDATA

  dont_draw_bg_attr:

  ; reset the palette offscreen after a drum roll
  LDA PPUSTATUS
  LDA bg_attr_position+3
  STA PPUADDR
  LDA bg_attr_position+4
  STA PPUADDR
  LDA #$00
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$06
  STA PPUADDR
  LDX #$00

  CLC

  loop_combo:
  LDA combo, X
  ADC #$20
  STA PPUDATA
  INX
  CPX #$04
  BNE loop_combo

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$0D
  STA PPUADDR
  LDX #$00

  CLC

  loop_score:
  LDA score, X
  ADC #$20
  STA PPUDATA
  INX
  CPX #$06
  BNE loop_score

  CLC

  LDA PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$F6
  STA PPUADDR
  LDX #$00

  loop_clear_bar_1:
  LDA clear_bar, X
  ADC #$80
  STA PPUDATA
  INX
  CPX #$06
  BNE loop_clear_bar_1

  CLC

  loop_clear_bar_2:
  LDA clear_bar, X
  ADC #$90
  STA PPUDATA
  INX
  CPX #$08
  BNE loop_clear_bar_2

  ; rest bg_attr after drawing
  LDA #$00
  STA bg_attr

  dont_do_main_stuff:
  RTS
.endproc

update_controller_1:
  CLC ; set carry bit to 0
  LDA #$01 ; load $01 to A
  STA BTN_Press+2 ; set BTN_Press+2 to A ($01)

check_presses:
  ; check which button youre holding
  LDA BTN_Hold ; load BTN_Hold to A
  AND BTN_Press+2 ; compare bit in A to BTN_Press+2
  BEQ reset_presses ; if they dont match (button isnt pressed), go to reset_presses

  ; check if BTN_Press has a value
  LDA BTN_Press ; load BTN_Press to A
  AND BTN_Press+2 ; compare bit in A to BTN_Press+2
  BNE set_BTN_Pressp1 ; if it has a value, go to set_BTN_Pressp1

  ; check if BTN_Press+1 has a value
  LDA BTN_Press+1 ; load BTN_Press to A
  AND BTN_Press+2 ; compare bit in A to BTN_Press+2
  BEQ set_button_press ; if it doesnt have a value, go to set_button_press
  BNE done_checking_a_press ; if it does have a value, go to done_checking_a_press

reset_presses: ; resets BTN_Press+1
  ; check if BTN_Press has a value
  ; important if you press a button for 1 frame, otherwise its not gonna reset
  LDA BTN_Press ; load BTN_Press to A
  AND BTN_Press+2 ; compare bit in A to BTN_Press+2
  BNE reset_presses_alt ; if BTN_Press has a value, go to reset_presses_alt

  ; check if BTN_Press+1 has a value
  LDA BTN_Press+1 ; load BTN_Press+1 to A
  AND BTN_Press+2 ; compare bit in A to BTN_Press+2
  BEQ done_checking_a_press ; if it doesnt have a value, go to done_checking_a_press

  LDA BTN_Press+2 ; laod BTN_Press+2 to A
  EOR BTN_Press+1 ; invert bit in A specified by BTN_Press+1
  STA BTN_Press+1 ; store A to BTN_Press+1, resetting it

  JMP done_checking_a_press ; go to done_checking_a_press

reset_presses_alt: ; resets BTN_Press
; (same as reset_presses, but its BTN_Press instead of BTN_Press+1)
  LDA BTN_Press+2 ; loads BTN_Press to A
  EOR BTN_Press ; invert bit in A specified by BTN_Press
  STA BTN_Press ; store A to BTN_Press, resetting it

  JMP done_checking_a_press ; go to done_checking_a_press

set_BTN_Pressp1: ; sets a value in BTN_Press+1
; important so it doesnt loop the code 2 frames later essentially making it turbo
; basically the same as BTN_Hold, but the important difference is this one is delayed by 1 frame
; otherwise it wouldnt set a value in BTN_Press
  LDA BTN_Press+2 ; load BTN_Press+2 to A
  EOR BTN_Press ; invert bit in A specified by BTN_Press
  STA BTN_Press ; store A to BTN_Press, resetting it, indicading a finished button press

  LDA BTN_Press+2 ; load BTN_Press+2 to A (again, to overwrite the leftover A)
  ORA BTN_Press+1 ; set bit in A specified by BTN_Press+1 to 1
  STA BTN_Press+1 ; store A (BTN_Press+2) to BTN_Press+1, so it wont repeat this code the next frame

  JMP done_checking_a_press ; go to done_checking_a_press

set_button_press: ; sets a value in BTN_Press
  LDA BTN_Press+2 ; load BTN_Press+2 to A
  ORA BTN_Press ; set bit in A specified by BTN_Press to 1
  STA BTN_Press ; store A (BTN_Press+2) to BTN_Press

  ; this doesnt need a JMP instruction because the code is right below this

done_checking_a_press: ; stop checking a button

  ROL BTN_Press+2 ; move bits in BTN_Press+2 to the left, including the carry flag bit
  BCC check_presses ; check if the carry flag is 1, if not, loop

  ; carry flag has 1 (it checked all 8 buttons), loop finished
  RTS

split_x_scrolling:
  LDX #$00
  wait:
  INX
  BPL wait

  sprite_zero:
  LDA PPUSTATUS
  AND #$40
  BEQ sprite_zero ; waste time until the sprite 0 hit flag is on

  LDA #$00 ; set the bottom half scrolls to 0
  STA $2005
  STA $2005

  LDA PPUCTRL_kept_2 ; set the bottom half PPUCTRL to PPUCTRL_kept_2
  STA $2000
  RTS

.proc metronome
  LDA misc ; execute every 8 pixel scrolls
  AND #%00000010
  BEQ end

  DEC metronome_v
  LDX metronome_v
  BNE end ; decrease metronome_v(alue) and branch if its not 0

  LDX #$04
  STX metronome_v ; reset metronome_v

  LDA misc
  ORA #%00000100
  STA misc ; flip the 3rd bit in misc

  end:

  RTS
.endproc

.proc sprite_flicker
  LDA sprite_flicker_toggle
  EOR #$02
  STA sprite_flicker_toggle

  LDA base_sprite
  increase_again:
  CLC
  ADC #$40
  BEQ increase_again
  STA base_sprite ; increase base_sprite by $40

  TAY ; transfer it to Y as well

  increase_again_again:
  CLC
  ADC #$40
  BEQ increase_again_again ; increase by $40 again

  PHA ; push it to the stack
  LDX #$00
  STX sprite_loop ; set sprite_loop to $00
  change_sprites:
  PLA
  TAX ; put stack to X
  LDA $200, X
  PHA ; load $200 + X and put it into stack
  LDA $200, Y
  STA $200, X ; transfer $200 + Y to $200 + X
  PLA
  STA $200, Y ; put stack to $200 + Y
  INX
  TXA ; increase X and then put it to A
  PHA ; push to stack
  INC sprite_loop
  LDX sprite_loop ; increase sprite_loop and put it to X
  INY ; increase Y
  CPX #$40
  BNE change_sprites ; repeat $40 times
  PLA ; pull stack so RTS works properly

  LDA sprite_flicker_toggle
  AND #$02
  BEQ shift_2 ; run this code every other frame instead

  ; swap base_sprite+2 and base_sprite+1
  LDA base_sprite+2
  PHA
  LDA base_sprite+1
  STA base_sprite+2
  PLA
  STA base_sprite+1
  RTS

  shift_2: ; swap base_sprite+3 and base_sprite+1
  LDA base_sprite+3
  PHA
  LDA base_sprite+1
  STA base_sprite+3
  PLA
  STA base_sprite+1
  RTS
.endproc

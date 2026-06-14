PPUSTATUS = $2002
PPUADDR   = $2006
PPUDATA   = $2007

BTN_RIGHT   = %00000001
BTN_LEFT    = %00000010
BTN_DOWN    = %00000100
BTN_UP      = %00001000
BTN_START   = %00010000
BTN_SELECT  = %00100000
BTN_B       = %01000000
BTN_A       = %10000000

CONTROLLER1 = $4016
CONTROLLER2 = $4017

; FAMISTUDIO_CFG_NTSC_SUPPORT  = 1 ; for NTSC
; FAMISTUDIO_CFG_PAL_SUPPORT   = 1 ; for PAL

FAMISTUDIO_CFG_EXTERNAL       = 1 ; enables external configuration

; FAMISTUDIO_CFG_SMOOTH_VIBRATO = 1 ; for a smooth vibrato

; FAMISTUDIO_CFG_EQUALIZER      = 1 ; enables songs
; FAMISTUDIO_CFG_SFX_SUPPORT    = 1 ; enables sfx
; FAMISTUDIO_CFG_SFX_STREAMS    = 2 ; how many sfx can play at once

FAMISTUDIO_USE_VOLUME_TRACK = 1 ; enables volume track
FAMISTUDIO_USE_VOLUME_SLIDES = 1 ; enables volume slides in volume track

; FAMISTUDIO_USE_PITCH_TRACK = 1 ; enables pitch track

; FAMISTUDIO_USE_NOISE_SLIDE_NOTES = 1 ; enables slide notes (noise)
FAMISTUDIO_USE_SLIDE_NOTES = 1 ; enables slide notes
FAMISTUDIO_USE_RELEASE_NOTES = 1 ; enables release notes

FAMISTUDIO_USE_VIBRATO = 1 ; enables vibrato tracks
; FAMISTUDIO_USE_ARPEGGIO = 1 ; enables arpeggios

; FAMISTUDIO_USE_DUTYCYCLE_EFFECT  = 1 ; enables the duty cycle track

FAMISTUDIO_CFG_DPCM_SUPPORT   = 1 ; enables DPCM
; FAMISTUDIO_USE_DELTA_COUNTER = 1 ; enables the delta track (DPCM)
FAMISTUDIO_DPCM_OFF = dmc_data ; sets DPCM location

FAMISTUDIO_EXP_N163 = 1
FAMISTUDIO_EXP_N163_CHN_CNT = 8





MAING_BANK = $00
TSCRN_BANK = $01

DBANK1_BANK = $02

MBANKS_BANK = $03
MBANKSS_BANK = $04
MBANK1_BANK = $06
MBANK2_BANK = $07
MBANK3_BANK = $08
MBANK4_BANK = $09
MBANK5_BANK = $0A
MBANK6_BANK = $0B




; CA65-specifc config.
.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT  BSS
.define FAMISTUDIO_CA65_CODE_SEGMENT START
;
.include "soundengine.asm"
.import _play_song, _update, _init
;
.if FAMISTUDIO_CFG_DPCM_SUPPORT
.segment "DMC"
dmc_data:
.incbin "songs/taiko.dmc"
.endif

.segment "HEADER"
.byte $4e, $45, $53, $1a ; Magic string that always begins an iNES header
.byte $07        ; Number of 16KB PRG-ROM banks
.byte $02        ; Number of 8KB CHR-ROM banks
.byte %00110011  ; MMMM (Mapper, 19), Alt nametable (Off), 512-byte trainer (Off), Contains PRG-RAM (On), Mirroring (Horizontal)
.byte %00010000  ; MMMM (Mapper, 19), NN (NES 2.0 Format, Off), Hint Screen Data (PlayChoice-10, Off), VS Unisystem (Off)
.byte $01        ; PRG-RAM size
.byte $00        ; NTSC (0) or PAL (1)

.segment "DRAW"
draw: .res 224

.segment "PAL"
palette: .res 32

.segment "ZEROPAGE"
BTN_Hold: .res 2
BTN_Press: .res 3

PPUCTRL: .res 1
PPUMASK: .res 1
PPUSCROLL_X: .res 1
PPUSCROLL_Y: .res 1
PPUSCROLL_X_speed: .res 1
PPUSCROLL_Y_speed: .res 1
PPUSCROLL_Y_overflow: .res 1

PPUSCROLL_X_stored: .res 1

frame_timer: .res 1
PPUCTRL_kept: .res 1
PPUCTRL_kept_2: .res 1

draw_length: .res 1
draw_bg_over_palette: .res 1
draw_attribute_location: .res 2

fade_intensity: .res 1
fade_time: .res 2
fade_type: .res 1

scene: .res 1
misc: .res 1

position_8px: .res 3
drum_spawn_position: .res 4
bg_attr: .res 1
bg_attr_position: .res 5

tiles_remaining: .res 1
drum_bank_positon: .res 2

bar_x: .res 1

tempo: .res 2
address_table: .res 2

roll_length: .res 3
roll_size: .res 1
roll_time: .res 1

bar_level: .res 1

base_sprite: .res 4
sprite_loop: .res 1

score_to_add_10: .res 1
score_to_add: .res 1

don_inputs: .res 3
kat_inputs: .res 3
drum_inc: .res 1

beat_animation: .res 1
beat_anim_frame: .res 1

sprite_flicker_toggle: .res 1

clear_bar: .res 8
clear_bar_inputs: .res 2
clear_bar_input_miss: .res 2
clear_bar_timer: .res 1

ts_ss_timer: .res 3

song_sel_entry: .res 2
song_sel_cursor_time: .res 1

frame_timer_1s: .res 1

.segment "BSS"
drum_data_pool: .res 21

drum_input_don_time: .res 1
drum_input_kat_time: .res 1

drum_input_don_two: .res 1
drum_input_kat_two: .res 1

stop_save: .res 1

metronome_v: .res 1

PRGROM_buf: .res 1

drum_disappear_position: .res 2

input_rate: .res 1
input_rate_timer: .res 1

score: .res 6
combo: .res 4
drum_roll: .res 3

input: .res 1

end_song_timer: .res 1

slot_number: .res 2
drum_sprite_X: .res 8
drum_sprite_Y: .res 8
drum_sprite_A: .res 8
drum_sprite_T: .res 8

drum_sprite_Y_kept: .res 1
drum_sprite_A_type: .res 1
drum_sprite_X_incr: .res 1

slot_number_big: .res 1
drum_sprite_X_big: .res 2
drum_sprite_Y_big: .res 2
drum_sprite_A_big: .res 2
drum_sprite_T_big: .res 2
drum_big_sprite_loop: .res 1

controller_sprites_screen: .res 3
don_sprites_screen: .res 4


.segment "PRGRAM"

drum_hit_pool: .res 64
drum_hit_pool_pos: .res 2
drum_hit_pool_frame: .res 128
drum_hit_pool_frame_pos: .res 2
drum_spawn_position_kept: .res 128

.segment "SRAM"
don_color: .res 2
song_sel_position: .res 3

song_difficulty_position: .res 6
song_difficulty_position_time: .res 2

.segment "MUSIC_BANK_SONGSELS"
.include "songs/donstart.s"
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.incbin "songs/donstart.dmc"

.segment "MUSIC_BANK_SONGSEL"
.include "songs/songselect.s"

.segment "MUSIC_BANK_1"
.include "songs/fluffy.s" ; include song

.segment "MUSIC_BANK_2"
;.include "songs/fluffy.s" ; include song

.segment "MUSIC_BANK_3"
.include "songs/euphoria.s" ; include song

.segment "MUSIC_BANK_4"
;.include "songs/fluffy.s" ; include song

.segment "MUSIC_BANK_5"
;.include "songs/fluffy.s" ; include song

.segment "MUSIC_BANK_6"
.include "songs/finnedfrontier.s" ; include song

.segment "DRUM_BANK_1"
dbank1:
.byte $83, $01
.byte $01, $00, $09, $00, $00

dbank2:
.byte $04, $02
.byte $02, $00, $0A, $00, $00

dbank3:
.byte $C5, $03
.byte $09, $03, $09, $03, $09, $03, $09, $03, $00

dbank4:
.byte $07, $04
.byte $0A, $03, $0A, $03, $0A, $03, $0A, $03, $00

dbank5:
.byte $C1, $05
.byte $01, $00, $02, $00, $09, $00, $00

dbank6:
.byte $C7, $06
.byte $02, $00, $01, $00, $0A, $00, $00

dbank7:
.byte $00, $07
.byte $09, $01, $0A, $01, $09, $01, $0A, $01, $00

dbank8:
.byte $C6, $08
.byte %00010110, $10, $00

.segment "START"

.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  PHA
  TXA
  PHA
  TYA
  PHA

  ; update sprites
  LDA #$00
  STA $2003 ; OAMADDR
  LDA #$02
  STA $4014 ; OAMDMA
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

  ; update PPUCTRL again
  LDA PPUCTRL
  STA $2000 ; PPUCTRL

  LDA PPUSCROLL_X
  STA $2005
  LDA PPUSCROLL_Y
  STA $2005

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
  BPL :+
  LDA #$01 ; set PPUSCROLL_Y_overflow to 1
  STA PPUSCROLL_Y_overflow ; if PPUSCROLL_Y_speed is above 80 (going upwards)
  LDA PPUSCROLL_Y_speed ; restore A by reloading PPUSCROLL_Y_speed
  :
  CLC ; clear carry (just in case)
  ADC #$10 ; add $10 to PPUSCROLL_Y_speed
  STA PPUSCROLL_Y_speed

  LDA PPUSCROLL_Y ; load PPUSCROLL_Y to A
  EOR #$80 ; flip the last bit for the overflow flag
  ADC PPUSCROLL_Y_speed ; add $10 + the actual speed
  EOR #$80 ; flip the last bit again to preserve the flag
  STA PPUSCROLL_Y ; store A to PPUSCROLL_Y
  BVC escape_change_nametable_Y ; if overflow flag is 1, change nametable

  LDA PPUCTRL ; load PPUCTRL to A
  EOR #$02 ; flip the 2nd bit (vertical nametable)
  STA PPUCTRL ; store A to PPUCTRL
  LDX PPUSCROLL_Y_overflow ; load PPUSCROLL_Y_overflow to X
  BNE :+
  STA $2000 ; store to PPUCTRL early if X is 0 (going downwards)
  :
  LDA PPUCTRL_kept ; flip the 2nd bit in PPUCTRL_kept too
  EOR #$02
  STA PPUCTRL_kept

  ; restore the actual PPUSCROLL_Y (only in overflow)
  LDA PPUSCROLL_Y ; load PPUSCROLL_Y to A
  CLC ; clear carry (just in case)
  ADC scroll_Y_values, X ; add either $F0 (-$10; X == 0) or $00 (X == 1) to A
  STA PPUSCROLL_Y ; store A to PPUSCROLL_Y

  escape_change_nametable_Y:
  ; clear PPUSCROLL_Y_overflow
  LDA #$00
  STA PPUSCROLL_Y_overflow

  ; restore the actual PPUSCROLL_Y_speed
  LDA PPUSCROLL_Y_speed
  SEC
  SBC #$10 ; subtract $10
  STA PPUSCROLL_Y_speed

  ; restore the actual PPUSCROLL_Y (always)
  LDA PPUSCROLL_Y
  SBC #$10 ; subtract $10 rom PPUSCROLL_Y
  STA PPUSCROLL_Y

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

















.proc reset_handler
  LDX #0
  STX $1000
  LDY #0
  STY $1001
  SEI ; disable IRQ
  CLD ; clear decimal
  LDX #$40
  STX $4017
  LDX #$FF
  TXS ; set stack to $FF
  INX ; set X to 0
  STX $2000
  STX $2001
  STX $4010
  BIT $2002
vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait
vblankwait2:
  BIT $2002
  BPL vblankwait2

  JMP main
.endproc

.proc main
  LDX #$00 ; load $00 to X so theres no offest
  STX $4000
  LDA #$ff

  ; reset memory
  LDA #$00
  LDX #$00
  ; enable writing to $6000-$7FFF
  LDA #%01000000
  STA $F800
  LDA #$00

  loop_reset_memory:
  STA $000, X
  STA $100, X
  STA $200, X
  STA $300, X
  STA $400, X
  STA $500, X
  STA $600, X
  STA $700, X
  STA $6000, X
  STA $6100, X
  INX
  BNE loop_reset_memory

  ; set the read-write of PRG-ROM to PRGROM_buf
  LDA #%01000000
  STA PRGROM_buf

  vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait
  ; set PPUADDR to $3F00

  LDA #$40 ; setup sprite flickering
  STA base_sprite+1
  LDA #$80
  STA base_sprite+2
  LDA #$C0
  STA base_sprite+3

  ; define sfx
;   LDX #<sounds ; load low byte to X
;   LDY #>sounds ; load high byte to Y
;   JSR famistudio_sfx_init ; initialize sfx

  ; set palette as black
  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  :
  LDA #$0F
  STA PPUDATA
  INX
  CPX #$20
  BNE :-

  JSR load_title_screen

  LDA #%10110000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  STA PPUCTRL_kept
  STA PPUCTRL_kept_2
  STA $2000 ; PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK
.endproc

.proc stay_here
  LDA misc
  AND #$80
  BNE stay_here ; loop stay_here if the last bit in misc is 1

  LDA misc
  ORA #$80
  STA misc ; set the last bit in misc to 1

  LDX scene
  LDA scenes_hi, X
  PHA

  LDA scenes_lo, X
  PHA

  RTS

scenes_lo:
.lobytes main_game, title_screen, song_sel, results

scenes_hi:
.hibytes main_game, title_screen, song_sel, results

.endproc

.proc load_main_game
  LDA PPUMASK
  AND #%11100111
  STA PPUMASK

  LDA PPUCTRL
  AND #%01111000
  STA PPUCTRL

  :
  LDA misc
  AND #$80
  BNE :-

  ; load PRG banks
  LDA #MAING_BANK
  STA $E000
  LDA #DBANK1_BANK
  STA $E800

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$01
  STA $8800
  LDA #$02
  STA $A000
  LDA #$03
  STA $A800
  LDA #$04
  STA $B000
  LDA #$E1
  STA $C800
  STA $D800
  LDA #$E0
  STA $C000
  STA $D000

  ; put every sprite offscreen
  LDX #$00
  put_sprites_offscreen:
  LDA #$F0
  STA $200, X
  INX
  INX
  INX
  INX
  BNE put_sprites_offscreen

  ; reset necessary values
  LDA #$00
  reset_PRGRAM:
  STA $6000, X
  STA $6100, X
  INX
  BNE reset_PRGRAM

  reset_positions:
  STA position_8px, X
  INX
  CPX #$0E
  BNE reset_positions

  ; reset misc bit 2
  ; otherwise drum inputs will be offsynced by -8px
  LDA misc
  AND #%11111101
  STA misc

  ; set sprite 0 for scrolling
  LDA #$68
  STA $200
  LDA #$06
  STA $201
  LDA #%00100000
  STA $202
  LDA #$00
  STA $203

  LDA #10
  STA end_song_timer

  LDA PPUSTATUS
  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  ; reset palette
  LDX #$00
  loop_reset_palette:
  LDA main_g_pal, X
  STA palette, X
  STA PPUDATA
  INX
  CPX #$20
  BNE loop_reset_palette

  LDA #$FF
  STA drum_hit_pool_pos

  ; setup buttons
  LDA #%10000000
  STA don_inputs
  LDA #%00000110
  STA don_inputs+1
  ORA don_inputs
  STA don_inputs+2

  LDA #%01000000
  STA kat_inputs
  LDA #%00001001
  STA kat_inputs+1
  ORA kat_inputs
  STA kat_inputs+2

  ; prepare the $00 tiles for drum dispawning
  LDA #$03
  STA draw+5
  STA draw+10
  STA draw+15
  LDA #%00000110
  STA draw+6
  STA draw+11
  STA draw+16

  ; prepare the drum spawn positions
  ; for spawning and dispawning
  LDA #$25
  STA drum_spawn_position+1
  STA drum_spawn_position+3
  LDA #$0B
  STA drum_spawn_position+2
  LDA #$03
  STA drum_spawn_position

  ; prepare the drum spawn palette attributes
  ; for spawning and dispawning
  LDA #$27
  STA bg_attr_position
  STA bg_attr_position+3
  LDA #$D1
  STA bg_attr_position+1
  LDA #$D2
  STA bg_attr_position+4

  ; set the X coordinate of the bars
  LDA #$28
  STA bar_x
  JSR update_bars

  ; set misc and metronome_v to 1
  ; misc to 1 to toggle sprite 0 hit execution
  ; metronome_v to start executing at beat 0 instead of beat 1
  LDA #$01
  STA metronome_v

  LDX #$00

  ; set tempo (tmp)
  LDA (drum_bank_positon, X)
  STA tempo

  LDA drum_bank_positon
  CMP #$FF
  BNE :+
  INC drum_bank_positon+1
  :

  INC drum_bank_positon

  LDA (drum_bank_positon, X)
  STA clear_bar_inputs+1
  STA clear_bar_input_miss+1

  LDA drum_bank_positon
  CMP #$FF
  BNE :+
  INC drum_bank_positon+1
  :

  INC drum_bank_positon

  LDA #$00
  STA scene
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_Y_speed

  ; spawn the sprites for drum hitting
  LDY base_sprite+2
  load_drum_input_sprites:
  LDA drum_input_sprites, X
  STA $22C, Y
  INY
  INX
  CPX #20
  BNE load_drum_input_sprites

  ; load background for both nametables

  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  LDY #$02

  load_taiko_bg:
  load_taiko_bg_1:
  LDA taiko_bg_1, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_1

  load_taiko_bg_2:
  LDA taiko_bg_2, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_2

  load_taiko_bg_3:
  LDA taiko_bg_3, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_3

  load_taiko_bg_4:
  LDA taiko_bg_4, X
  STA PPUDATA
  INX
  BNE load_taiko_bg_4

  DEY
  BNE load_taiko_bg

  LDX song_sel_position ; load the song number to X

  LDA misc
  ORA #$01
  STA misc

  LDA PPUMASK
  ORA #%00011000
  STA PPUMASK

  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUCTRL
  ORA #%10000000
  STA PPUCTRL_kept
  STA PPUCTRL
  STA $2000

  LDA frame_timer
  AND #$FE
  STA frame_timer

  LDA song_bank_numbers, X
  STA $F000
  JSR init_song

  LDA #$00 ; song number
  JSR famistudio_music_play ; play song

  JMP stay_here

  song_bank_numbers:
  .byte $06, $07, $08, $09, $0A, $0B
.endproc

.proc load_title_screen
  ; setup sprite 0 hit
  LDA #$C8
  STA $200
  LDA #$06
  STA $201
  LDA #%00100000
  STA $202

  ; load PRG banks
  LDA #$01
  STA $E000

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$05
  STA $A000
  LDA #$06
  STA $A800
  LDA #$07
  STA $B000
  LDA #$02
  STA $B800

  ; load PPU nametables
  LDA #$E1
  STA $C800
  STA $D800
  STA $C000
  STA $D000

  ; define song
  LDX #<(taiko_sfx) ; load low byte to X
  LDY #>(taiko_sfx) ; load high byte to Y

  LDA #$01 ; NTSC speed
  JSR famistudio_init ; initialize songs

  LDA #$01
  STA scene

  LDA misc
  AND #%11111110
  STA misc

  LDX #$00
  load_title_palette:
  LDA title_palette, X
  STA palette, X
  INX
  CPX #$14
  BNE load_title_palette

  LDA #$0F
  STA palette+16

  LDA #$04
  STA fade_intensity

  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00

  load_title_bg:
  load_title_bg_1:
  LDA title_bg_1, X
  STA PPUDATA
  INX
  BNE load_title_bg_1

  load_title_bg_2:
  LDA title_bg_2, X
  STA PPUDATA
  INX
  BNE load_title_bg_2

  load_title_bg_3:
  LDA title_bg_3, X
  STA PPUDATA
  INX
  BNE load_title_bg_3

  load_title_bg_4:
  LDA title_bg_4, X
  STA PPUDATA
  INX
  BNE load_title_bg_4

  RTS
.endproc

.proc load_song_sel
  LDA PPUMASK
  AND #%11100111
  STA PPUMASK

  LDA PPUCTRL
  STA PPUCTRL_kept
  AND #%01111000
  STA PPUCTRL

  ; disable sprite 0 hit
  LDA misc
  AND #$FE
  STA misc

  ; unload all sprites
  LDX #$00
  unload_sprites:
  LDA #$F0
  STA $200, X
  INX
  INX
  INX
  INX
  BNE unload_sprites

  ; rest draw memory bytes
  LDA #$00
  reset_draw:
  STA draw, X
  INX
  BPL reset_draw

  :
  LDA misc
  AND #$80
  BNE :-

  ; reset scrolling
  LDA #$00
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_X_speed
  STA PPUSCROLL_Y_speed

  ; load PRG banks (just in case)
  LDA #$01
  STA $E000

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$01
  STA $8800
  STA song_sel_entry
  LDA #$02
  STA $A000
  LDA #$08
  STA $A800
  LDA #$09
  STA $B000

  ; load nametable banks
  ; load PPU nametables
  LDA #$E0
  STA $C800
  STA $D800
  LDA #$E1
  STA $D000
  LDA #$0D
  STA $C000

  LDA #$00
  STA fade_intensity

  LDX #$00
  STX ts_ss_timer
  STX ts_ss_timer+1
  loop_reset_palette:
  LDA song_sel_pal, X
  STA palette, X
  INX
  CPX #$20
  BNE loop_reset_palette

  ; load background for both nametables
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
  LDY #$02

;   load_song_sel_bg:
;   load_song_sel_1:
;   LDA song_sel_1, X
;   STA PPUDATA
;   INX
;   BNE load_song_sel_1
;
;   load_song_sel_2:
;   LDA song_sel_2, X
;   STA PPUDATA
;   INX
;   BNE load_song_sel_2
;
;   load_song_sel_3:
;   LDA song_sel_3, X
;   STA PPUDATA
;   INX
;   BNE load_song_sel_3
;
;   load_song_sel_4:
;   LDA song_sel_4, X
;   STA PPUDATA
;   INX
;   BNE load_song_sel_4
;
;   DEY
;   BNE load_song_sel_bg

  LDA #$02
  STA scene
  LDA #$00
  STA PPUSCROLL_X

  LDA PPUMASK
  ORA #%00011000
  STA PPUMASK

  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUCTRL
  ORA #%10000000
  STA PPUCTRL_kept
  STA PPUCTRL
  STA $2000

  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  LDA #$01
  JSR famistudio_sfx_sample_play

  LDA #$FF
  STA song_sel_position+1

  LDA #$04
  STA fade_intensity

  LDA #$00
  STA fade_type

  LDA #$01
  STA fade_time

  JMP stay_here
.endproc

.proc load_results
  LDA PPUMASK
  AND #%11100111
  STA PPUMASK

  LDA PPUCTRL
  STA PPUCTRL_kept
  AND #%01111000
  STA PPUCTRL

  ; disable sprite 0 hit
  LDA misc
  AND #$FE
  STA misc

  ; unload all sprites
  LDX #$00
  unload_sprites:
  LDA #$F0
  STA $200, X
  INX
  INX
  INX
  INX
  BNE unload_sprites

  :
  LDA misc
  AND #$80
  BNE :-

  ; reset scrolling
  LDA #$00
  STA PPUSCROLL_X
  STA PPUSCROLL_Y
  STA PPUSCROLL_X_speed
  STA PPUSCROLL_Y_speed

  ; load PRG banks (just in case)
  LDA #$01
  STA $E000

  ; load CHR banks
  LDA #$00
  STA $8000
  LDA #$01
  STA $8800
  STA song_sel_entry
  LDA #$02
  STA $A000
  LDA #$08
  STA $A800
  LDA #$09
  STA $B000

  ; load nametable banks
  ; and load PPU nametables
  LDA #$E0
  STA $C800
  STA $D800
  LDA #$E1
  STA $D000
  LDA #$0D
  STA $C000

  LDA #$00
  STA fade_intensity

  LDX #$00
  STX ts_ss_timer
  STX ts_ss_timer+1
  loop_reset_palette:
  LDA song_sel_pal, X
  STA palette, X
  INX
  CPX #$20
  BNE loop_reset_palette

  ; load background
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00

;   load_results_bg:
;   load_results_1:
;   LDA results_1, X
;   STA PPUDATA
;   INX
;   BNE load_results_1
;
;   load_results_2:
;   LDA results_2, X
;   STA PPUDATA
;   INX
;   BNE load_results_2
;
;   load_results_3:
;   LDA results_3, X
;   STA PPUDATA
;   INX
;   BNE load_results_3
;
;   load_results_4:
;   LDA results_4, X
;   STA PPUDATA
;   INX
;   BNE load_results_4

  LDA #$03
  STA scene
  LDA #$00
  STA PPUSCROLL_X

  LDA PPUMASK
  ORA #%00011000
  STA PPUMASK

  :
  BIT PPUSTATUS
  BPL :-

  LDA PPUCTRL
  ORA #%10000000
  STA PPUCTRL_kept
  STA PPUCTRL
  STA $2000

  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  LDA #$01
  JSR famistudio_sfx_sample_play

  LDA #$FF
  STA song_sel_position+1

  LDA #$04
  STA fade_intensity

  LDA #$00
  STA fade_type

  LDA #$01
  STA fade_time

  JMP stay_here
.endproc

init_song:
; define song
  LDX #<$C000 ; load low byte to X
  LDY #>$C000 ; load high byte to Y

  LDA #$01 ; NTSC speed
  JSR famistudio_init ; initialize songs
  RTS

init_song_alt:
; define song
  LDX #<$A000 ; load low byte to X
  LDY #>$A000 ; load high byte to Y

  LDA #$01 ; NTSC speed
  JSR famistudio_init ; initialize songs
  RTS

taiko_sfx:
.include "songs/taiko.s"





















.segment "TITL_SCEN_SONG_SEL_RES"

.proc title_screen
  NOP

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

title_bg_1:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5
	.byte $ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$01,$02,$00,$03,$04,$05,$06,$07,$08,$09,$0a,$00,$00,$0b,$0c,$0d,$0e,$0f,$10,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$00,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$00,$00,$00
	.byte $00,$00,$00,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$00,$00,$00

title_bg_2:
	.byte $00,$00,$00,$42,$43,$44,$43,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$43,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$00,$00,$00,$00
	.byte $00,$00,$00,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$00,$00,$00
	.byte $00,$00,$00,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$00,$00,$00
	.byte $00,$00,$00,$8d,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$00,$00,$00
	.byte $00,$00,$00,$a7,$a8,$00,$00,$a9,$aa,$00,$00,$d7,$c4,$cc,$ce,$d2,$00,$d1,$c8,$d6,$00,$00,$00,$00,$00,$ab,$ac,$ad,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ae,$af,$b0,$b1,$b1,$00,$b1,$b2,$b3,$af,$b2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

title_bg_3:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$d3,$d2,$d5,$d7,$00,$c5,$dc,$00,$c7,$c8,$d1,$cc,$ed,$cc,$ca,$d8,$c8,$d6,$d6,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$d7,$cb,$cc,$d6,$00,$d3,$d2,$d5,$d7,$00,$cc,$d6,$00,$d8,$d1,$c4,$c9,$c9,$cc,$cf,$cc,$c4,$d7,$c8,$c7,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$da,$cc,$d7,$cb,$00,$c5,$c4,$d1,$c7,$c4,$cc,$00,$d1,$c4,$d0,$c6,$d2,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$d7,$c4,$cc,$ce,$d2,$00,$d1,$d2,$00,$d7,$c4,$d7,$d6,$d8,$cd,$cc,$d1,$00,$cc,$d6,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$d2,$da,$d1,$c8,$c7,$00,$c4,$d1,$c7,$00,$c6,$d2,$d3,$dc,$d5,$cc,$ca,$cb,$d7,$c8,$c7,$00,$c5,$dc,$00,$00,$00,$00

title_bg_4:
	.byte $00,$c5,$c4,$d1,$c7,$c4,$cc,$00,$d1,$c4,$d0,$c6,$d2,$00,$c8,$d1,$d7,$c8,$d5,$d7,$c4,$cc,$d1,$d0,$c8,$d1,$d7,$00,$cc,$d1,$c6,$eb
	.byte $c2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9,$b4,$b5,$b8,$b9
	.byte $b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb,$b6,$b7,$ba,$bb
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $50,$50,$50,$50,$50,$50,$50,$50
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $52,$50,$50,$50,$50,$50,$50,$50
	.byte $00,$00,$00,$00,$00,$00,$00,$00

title_palette:
    .byte $0F, $16, $26, $20
    .byte $0F, $16, $21, $20
    .byte $0F, $0F, $0F, $20
    .byte $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F

.proc song_sel
  NOP

  JSR update_START
  JSR update_B
  JSR update_SEL

  JSR update_cursor_position

  JSR update_song_select_value

  JSR update_pauses

  JSR update_Y_scroll

  JSR update_controller_highlight

  JMP stay_here
.endproc

.proc update_pauses
  LDA ts_ss_timer+1
  BNE :+
  RTS

  :

  INC ts_ss_timer+1
  CMP #20
  BNE :+

  LDA #$02
  JSR famistudio_sfx_sample_play

  :
  CMP #180
  BNE dont_load_main_game

  LDA #$00
  LDX song_sel_position
  LDY #$00

  draw_stars:
  LDA song_stars, X

  CLC
  ;SBC #$


  LDY song_difficulty_position, X
  :
  CPX #$00
  BEQ :+
  CLC
  ADC #$04
  DEX
  CLV
  BVC :-
  :

  TAX
  :
  CPY #$00
  BEQ :+
  INX
  DEY
  BVC :-
  :

  LDA song_address_start_lo, X
  STA drum_bank_positon

  LDA song_address_start_hi, X
  STA drum_bank_positon+1

  JMP load_main_game
  dont_load_main_game:

  RTS

  song_address_start_lo:
  .lobytes dbank1, dbank2, dbank3, dbank4
  .lobytes dbank5, dbank6, dbank7, dbank8
  .lobytes dbank1, dbank2, dbank3, dbank4
  .lobytes dbank5, dbank6, dbank7, dbank8
  .lobytes dbank1, dbank2, dbank3, dbank4
  .lobytes dbank5, dbank6, dbank7, dbank8

  song_address_start_hi:
  .hibytes dbank1, dbank2, dbank3, dbank4
  .hibytes dbank5, dbank6, dbank7, dbank8
  .hibytes dbank1, dbank2, dbank3, dbank4
  .hibytes dbank5, dbank6, dbank7, dbank8
  .hibytes dbank1, dbank2, dbank3, dbank4
  .hibytes dbank5, dbank6, dbank7, dbank8

  song_stars:
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00
  .byte $00, $00, $00, $00

  song_author_1:
  .byte $00, $00, $00, $00, $00, $00
  song_author_2:
  .byte $00, $00, $00, $00, $00, $00
  song_author_3:
  .byte $00, $00, $00, $00, $00, $00
  song_author_4:
  .byte $00, $00, $00, $00, $00, $00
  song_author_5:
  .byte $00, $00, $00, $00, $00, $00
  song_author_6:
  .byte $00, $00, $00, $00, $00, $00
  song_author_7:
  .byte $00, $00, $00, $00, $00, $00
  song_author_8:
  .byte $00, $00, $00, $00, $00, $00
  song_author_9:
  .byte $00, $00, $00, $00, $00, $00
  song_author_10:
  .byte $00, $00, $00, $00, $00, $00
  song_author_11:
  .byte $00, $00, $00, $00, $00, $00
  song_author_12:
  .byte $00, $00, $00, $00, $00, $00

  song_chartr_1:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_2:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_3:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_4:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_5:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_6:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_7:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_8:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_9:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_10:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_11:
  .byte $00, $00, $00, $00, $00, $00
  song_chartr_12:
  .byte $00, $00, $00, $00, $00, $00
.endproc

.proc update_START
  LDA ts_ss_timer+1
  BNE :+++

  LDA song_sel_entry+1
  BNE :++

  LDA BTN_Press
  AND #%10010000
  BEQ :+++

  LDA #$03
  JSR famistudio_sfx_sample_play

  INC song_sel_entry
  LDA song_sel_entry
  CMP #$01
  BEQ :+
  CMP #$02
  BNE :+++
  :
  LDA #$07
  STA song_sel_entry+1

  LDA song_sel_entry
  CMP #$02
  BNE :+
  LDA #$E1
  STA $D000

  LDA frame_timer
  AND #$01
  STA frame_timer
  :

  RTS
  :
  CMP #$03
  BNE :++

  LDA ts_ss_timer+1
  BNE :+
  LDA #MBANKS_BANK
  STA $F000
  JSR init_song

  LDA #$03
  JSR famistudio_sfx_sample_play
  :

  INC ts_ss_timer+1

  LDA #121
  STA ts_ss_timer

  LDA #$80
  STA song_sel_position+2
  :
  RTS
.endproc

update_B:
  LDA song_sel_entry
  CMP #$02
  BNE :+

  LDA BTN_Press
  AND #BTN_B
  BEQ :+

  down:

  LDA song_sel_entry+1
  BNE :+

  LDA #$87
  STA song_sel_entry+1

  DEC song_sel_entry

  LDA #$03
  JSR famistudio_sfx_sample_play
  :
  RTS

update_SEL:
  LDA song_sel_entry
  CMP #$01
  BNE :+

  LDA BTN_Press
  AND #BTN_SELECT
  BEQ :+

  LDA #$E0
  STA $D000

  JMP down

  :
  RTS


.proc update_song_select_value
  LDA ts_ss_timer
  CMP #100
  BCS :+

  INC ts_ss_timer
  RTS

  :

  CMP #100
  BNE :+++

  LDA song_sel_position+2
  AND #$7F
  BEQ :+
  DEC song_sel_position+2
  RTS
  :

  LDA song_sel_position
  CMP song_sel_position+1
  BEQ :++

  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song

  LDA #20
  STA song_sel_position+2

  JSR famistudio_music_stop

  LDA song_sel_position+1
  CMP #$FF
  BEQ :+
  :

  LDA song_sel_position
  STA song_sel_position+1
  :

  LDA song_sel_position+2
  BNE :+
  BMI :+
  ORA #$80
  STA song_sel_position+2
  LDA song_sel_position
  JSR famistudio_music_play
  :
  RTS
.endproc

.proc update_Y_scroll
  LDA song_sel_entry+1
  AND #$7F
  TAX
  BEQ :+
  LDA song_sel_entry+1
  AND #$80
  BNE :+
  INC PPUSCROLL_Y
  :

  LDA Y_scroll_table, X
  PHA
  LDA song_sel_entry+1
  AND #$80
  BNE :+
  PLA
  EOR #$FF
  PHA
  :
  PLA
  STA PPUSCROLL_Y_speed
  BEQ :+
  DEC song_sel_entry+1
  :

  LDA song_sel_entry+1
  CMP #$80
  BNE :+
  ASL
  STA song_sel_entry+1
  STA PPUSCROLL_Y
  DEC PPUSCROLL_Y
  :
  RTS
.endproc

.proc update_cursor_position
  LDX song_sel_entry
  LDA cursor_code_lo, X
  STA address_table
  LDA cursor_code_hi, X
  STA address_table+1
  JMP (address_table)

  cursor_code_lo:
  .lobytes options_cursor, song_cursor, diff_cursor, nothing
  cursor_code_hi:
  .hibytes options_cursor, song_cursor, diff_cursor, nothing

  nothing:
  RTS
.endproc

.proc options_cursor
  RTS
.endproc

MAX_SONG_COUNT = $05

.proc song_cursor
  LDA song_sel_cursor_time
  CMP #19
  BNE :+

  LDA #MBANKSS_BANK
  STA $E800
  LDA #MBANKSS_BANK+1
  STA $F000
  JSR init_song
  LDA #$02
  JSR famistudio_sfx_sample_play
  :

  LDA BTN_Hold
  AND #%00000011
  BNE :+
  LDA #$00
  STA song_sel_cursor_time
  :

  LDA BTN_Hold
  AND #BTN_LEFT
  BEQ :++
  LDA song_sel_cursor_time
  BNE :+

  LDA #20
  STA song_sel_cursor_time
  LDA #20
  STA song_sel_position+2

  DEC song_sel_position
  LDA song_sel_position
  CMP #$FF
  BNE :+
  LDA #MAX_SONG_COUNT
  STA song_sel_position
  :
  DEC song_sel_cursor_time
  JMP update_cursor_sprite

  :
  LDA BTN_Hold
  AND #BTN_RIGHT
  BNE :+
  JMP update_cursor_sprite

  :
  LDA song_sel_cursor_time
  BNE :+

  LDA #20
  STA song_sel_cursor_time
  LDA #20
  STA song_sel_position+2

  INC song_sel_position
  LDA song_sel_position
  CMP #MAX_SONG_COUNT+1
  BCC :+
  LDA #$00
  STA song_sel_position
  :
  DEC song_sel_cursor_time

  update_cursor_sprite:
  LDA #$1B
  STA $204
  LDA #$6C
  STA $205

  LDA #BASE_CURSOR_X_POSITION_SONG_SEL
  LDX song_sel_position
  CLC

  loop_ucs:
  BEQ leave_lucs
  ADC #$20
  DEX
  BNE loop_ucs

  leave_lucs:
  STA $207
  RTS

  BASE_CURSOR_X_POSITION_SONG_SEL = $28
.endproc

.proc diff_cursor
  RTS
.endproc

c_h_base_sprite = $208

.proc update_controller_highlight ; and that donchan icon
  LDX #$00
  load_c_h_sprites:
  LDA controller_highlight_sprite_data, X
  STA c_h_base_sprite, X
  INX
  CPX #$14
  BNE load_c_h_sprites

  INC frame_timer_1s
  LDA frame_timer_1s
  CMP #30
  BNE :+
  LDA #0
  STA frame_timer_1s
  LDA beat_anim_frame
  EOR #$01
  STA beat_anim_frame
  :

  LDA beat_anim_frame
  BNE :+
  LDX #$00
  unload_c_h_sprites:
  LDA #$F0
  STA c_h_base_sprite, X
  INX
  INX
  INX
  INX
  CPX #$14
  BNE unload_c_h_sprites
  :

  LDX #$00
  sync_c_h_height:
  LDY #$00

  LDA PPUSCROLL_Y
  BEQ :+
  INY
  :

  LDA PPUCTRL
  AND #$02
  BEQ :+
  INY
  :

  LDA c_h_base_sprite, X
  CMP #$F0
  BCS :+
  SEC
  SBC PPUSCROLL_Y
  CPY #$01
  BCC :+
  LDA #$F0
  :
  STA c_h_base_sprite, X
  INX
  INX
  INX
  INX
  CPX #$14
  BNE sync_c_h_height

  LDA $204
  SEC
  SBC PPUSCROLL_Y
  CPY #$01
  BCC :+
  LDA #$F0
  :
  STA $204

  RTS
.endproc

Y_scroll_table:
  .byte $FF, $01, $02, $0C, $13, $31, $43, $5A

song_sel_pal:
  .byte $0F, $05, $15, $25
  .byte $0F, $0F, $16, $30
  .byte $0F, $16, $37, $0F
  .byte $0F, $0F, $0F, $0F

  .byte $0F, $30, $30, $30
  .byte $0F, $0F, $0F, $0F
  .byte $0F, $0F, $0F, $0F
  .byte $0F, $0F, $0F, $0F

controller_highlight_sprite_data:
  .byte $D9, $66, $00, $9E, $D9, $66, $00, $A5, $DB, $68, $00, $B4, $DB, $6A, $00, $C4

.proc results
  NOP
  LDA BTN_Press
  AND #BTN_A
  BEQ :+
  JMP load_song_sel
  :
  JMP stay_here
.endproc


.segment "MAIN_GAME"

.proc main_game
  NOP

  JSR update_position ; update the position bytes

  LDA PPUSCROLL_X_stored
  CLC
  ADC PPUSCROLL_X_speed
  STA PPUSCROLL_X_stored

  LDA frame_timer
  AND #$01
  BNE :+

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

  JSR reset_misc_bit_2 ; set the bit 2 in misc to 0

  :

  JSR update_bars ; update bar positions

  JSR update_inputs ; update inputs and drum hitting

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
  AND #%00000111
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
  AND #%00000111
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

  clear_drum:
  LDA #$01
  STA draw_bg_over_palette

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


  bad_times_1:
  .byte $12, $15

  ok_times_1:
  .byte $0E, $11

  good_times:
  .byte $0B, $0E

  ok_times_2:
  .byte $05, $05

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
  CLC
  ADC #45
  LDX combo
  BNE add_max
  LDX combo+1
  BNE add_max

  add_points_loop:
  BEQ no_longer_add_points
  ADC #10
  DEX
  JMP add_points_loop

  no_longer_add_points:
  STA score_to_add
  RTS

  add_max:
  CLC
  ADC #100

  dont_add_max:
  JMP no_longer_add_points





  add_points_ok:

  LDA score_to_add
  CLC
  ADC #23
  LDX combo+0
  BNE add_max_ok
  LDX combo+1
  BNE add_max_ok

  add_points_loop_ok:
  BEQ no_longer_add_points_ok
  ADC #5
  DEX
  JMP add_points_loop_ok

  no_longer_add_points_ok:
  STA score_to_add
  RTS

  add_max_ok:
  CLC
  ADC #50

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

  inc_roll:
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
  STA drum_hit_pool, Y
  AND #%00000011

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

  load_rol:
  LDA #$01
  STA draw_bg_over_palette

  LDA #$1E
  STA roll_length+2

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

  JMP done_drawing_small_kat

  load_big_don:
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

  JMP done_drawing_small_don

  load_big_rol:
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
  STA drum_data_pool+9 ; store to drum part 2
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
  .byte $02, $02, $02, $01, $01, $02, $02, $02, $02, $21

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

taiko_bg_1:
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $71,$71,$71,$71,$71,$78,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$78,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71
	.byte $02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$77,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $70,$70,$70,$70,$70,$76,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$76,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
	.byte $03,$03,$03,$03,$03,$75,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$75,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $6f,$6f,$6f,$6f,$6f,$74,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$74,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f

taiko_bg_2:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$60,$61,$62,$00,$06,$12,$10,$05,$12,$2A,$00,$16,$06,$12,$15,$08,$2A,$00,$00,$00,$80,$80,$80,$80,$80,$80,$90,$90,$00,$00

taiko_bg_3:
	.byte $00,$00,$63,$64,$65,$00,$20,$20,$20,$20,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$66,$67,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c,$6c
	.byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte $6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d,$6d
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02

taiko_bg_4:
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e,$6e
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $40,$10,$00,$00,$00,$a0,$a0,$10
	.byte $f4,$f1,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f

.byte $00, $00, $03, $06, $0D, $13, $19, $1F, $26, $2C, $32, $38, $3E, $44, $4A, $50
.byte $56, $5C, $62, $68, $6D, $73, $79, $7E, $84, $89, $8E, $93, $98, $9D, $A2, $A7
.byte $AC, $B1, $B5, $B9, $BE, $C2, $C6, $CA, $CE, $D1, $D5, $D8, $DC, $DF, $E2, $E5
.byte $E7, $EA, $ED, $EF, $F1, $F3, $F5, $F7, $F8, $FA, $FB, $FC, $FD, $FE, $FF, $FF

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "CHR-ROM/gfx.chr"
.incbin "CHR-ROM/gfx2.chr"
.include "CHR-ROM/song_sel.asm"
.include "CHR-ROM/song_sel.asm"
; .include "CHR-ROM/options.asm"
; .include "CHR-ROM/results.asm"

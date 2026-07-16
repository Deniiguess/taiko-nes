; FAMISTUDIO_CFG_NTSC_SUPPORT  = 1 ; for NTSC
; FAMISTUDIO_CFG_PAL_SUPPORT   = 1 ; for PAL
FAMISTUDIO_CFG_EXTERNAL       = 1 ; enables external configuration

; FAMISTUDIO_CFG_SMOOTH_VIBRATO = 1 ; for a smooth vibrato

; FAMISTUDIO_CFG_EQUALIZER      = 1 ; enables songs
; FAMISTUDIO_CFG_SFX_SUPPORT    = 1 ; enables sfx
; FAMISTUDIO_CFG_SFX_STREAMS    = 2 ; how many sfx can play at once

FAMISTUDIO_USE_VOLUME_TRACK = 1 ; enables volume track
FAMISTUDIO_USE_VOLUME_SLIDES = 1 ; enables volume slides in volume track

FAMISTUDIO_USE_PITCH_TRACK = 1 ; enables pitch track

; FAMISTUDIO_USE_NOISE_SLIDE_NOTES = 1 ; enables slide notes (noise)
FAMISTUDIO_USE_SLIDE_NOTES = 1 ; enables slide notes
FAMISTUDIO_USE_RELEASE_NOTES = 1 ; enables release notes

FAMISTUDIO_USE_VIBRATO = 1 ; enables vibrato tracks
FAMISTUDIO_USE_ARPEGGIO = 1 ; enables arpeggios

; FAMISTUDIO_USE_DUTYCYCLE_EFFECT  = 1 ; enables the duty cycle track

FAMISTUDIO_CFG_DPCM_SUPPORT   = 1 ; enables DPCM
; FAMISTUDIO_USE_DELTA_COUNTER = 1 ; enables the delta track (DPCM)
FAMISTUDIO_DPCM_OFF = dmc_data ; sets DPCM location

FAMISTUDIO_EXP_N163 = 1
FAMISTUDIO_EXP_N163_CHN_CNT = 8

; CA65-specifc config.
.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT  BSS
.define FAMISTUDIO_CA65_CODE_SEGMENT START

.include "soundengine.asm"
.import _play_song, _update, _init
;
.if FAMISTUDIO_CFG_DPCM_SUPPORT
.segment "DMC"
dmc_data:
.incbin "../songs/taiko.dmc"
.endif

.include "constants.asm"
.include "memory.asm"
.include "header.asm"
.include "musicbnk.asm"
.include "drumbnk.asm"

.segment "START"

.include "handlers/nmi.asm"
.include "handlers/reset.asm"

.include "handlers/scene_jump_table.asm"

.include "load/load_maingame.asm"
.include "load/load_titlescreen.asm"
.include "load/load_songsel.asm"
.include "load/load_results.asm"

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
.include "../songs/taiko.s"


.segment "TITL_SCEN_SONG_SEL_RES"
.include "scenes/title_screen.asm"
.include "scenes/song_sel.asm"
.include "scenes/results.asm"

.segment "MAIN_GAME"
.include "scenes/main_game.asm"

.segment "VECTORS"
.addr nmi_handler, reset_handler, reset_handler ; irq handler

.segment "CHR"
.incbin "../CHR-ROM/gfx.chr"
.incbin "../CHR-ROM/gfx2.chr"
.include "../CHR-ROM/song_sel.asm"
.include "../CHR-ROM/song_sel.asm"
; .include "CHR-ROM/options.asm"
; .include "CHR-ROM/results.asm"

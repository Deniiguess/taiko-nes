.segment "MUSIC_BANK_SONGSELS"
.include "songs/donstart.s"
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.incbin "songs/donstart.dmc"

.segment "MUSIC_BANK_SONGSEL"
.include "songs/songselectpal.s"

.segment "MUSIC_BANK_1"
.include "songs/treeclimberbossPAL.s" ; include song

.segment "MUSIC_BANK_2"
.include "songs/whounleashedthedogPAL.s" ; include song

.segment "MUSIC_BANK_3"
.include "songs/euphoriaPAL.s" ; include song

.segment "MUSIC_BANK_4"
.include "songs/beanbrainedPAL.s" ; include song

.segment "MUSIC_BANK_5"
.include "songs/remix8dsPAL.s" ; include song

.segment "MUSIC_BANK_6"
.include "songs/finnedfrontierPAL.s" ; include song

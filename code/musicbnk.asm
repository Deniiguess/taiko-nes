.segment "MUSIC_BANK_SONGSELS"
.include "../songs/donstart.s"
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.incbin "../songs/donstart.dmc"

.segment "MUSIC_BANK_SONGSEL"
.include "../songs/songselect.s"

.segment "MUSIC_BANK_1"
.include "../songs/fluffy.s" ; include song

.segment "MUSIC_BANK_2"
.include "../songs/whounleashedthedog.s" ; include song

.segment "MUSIC_BANK_3"
.include "../songs/euphoria.s" ; include song

.segment "MUSIC_BANK_4"
;.include "../songs/remix8ds.s" ; include song

.segment "MUSIC_BANK_5"
.include "../songs/remix8ds.s" ; include song

.segment "MUSIC_BANK_6"
.include "../songs/finnedfrontier.s" ; include song

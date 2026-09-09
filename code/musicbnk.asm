.segment "MUSIC_BANK_SONGSELS"
.include "songs/donstart.s"
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.incbin "songs/donstart.dmc"

.segment "MUSIC_BANK_SONGSEL"
.include "songs/songselect.s"

.segment "MUSIC_BANK_1"
.include "songs/KarippaBoss/treeclimberboss.s" ; include song

.segment "MUSIC_BANK_2"
.include "songs/WhoUnleashedTheDog/whounleashedthedog.s" ; include song

.segment "MUSIC_BANK_3"
.include "songs/Euphoria/euphoria.s" ; include song

.segment "MUSIC_BANK_4"
.include "songs/BeanBrained/beanbrained.s" ; include song

.segment "MUSIC_BANK_5"
.include "songs/Remix8DS/remix8ds.s" ; include song

.segment "MUSIC_BANK_6"
.include "songs/FinnedFrontier/finnedfrontier.s" ; include song

.segment "MUSIC_BANK_2A03_1"
.include "songs/KarippaBoss/treeclimberboss2A03.s" ; include song
.include "songs/Remix8DS/remix8ds2A03.s" ; include song

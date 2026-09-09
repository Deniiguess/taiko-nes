.segment "MUSIC_BANK_SONGSELS"
.include "songs/donstart.s"
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.incbin "songs/donstart.dmc"

.segment "MUSIC_BANK_SONGSEL"
.include "songs/songselectpal.s"

.segment "MUSIC_BANK_1"
.include "songs/KarippaBoss/treeclimberbossPAL.s" ; include song

.segment "MUSIC_BANK_2"
.include "songs/WhoUnleashedTheDog/whounleashedthedogPAL.s" ; include song

.segment "MUSIC_BANK_3"
.include "songs/Euphoria/euphoriaPAL.s" ; include song

.segment "MUSIC_BANK_4"
.include "songs/BeanBrained/beanbrainedPAL.s" ; include song

.segment "MUSIC_BANK_5"
.include "songs/Remix8DS/remix8dsPAL.s" ; include song

.segment "MUSIC_BANK_6"
.include "songs/FinnedFrontier/finnedfrontierPAL.s" ; include song

.segment "MUSIC_BANK_2A03_1"
.include "songs/KarippaBoss/treeclimberboss2A03.s" ; include song
.include "songs/Remix8DS/remix8ds2A03.s" ; include song

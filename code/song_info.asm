  song_address_start_lo:
  .lobytes dbank1, dbank2, dbank3, dbank4
  .lobytes dbank5, dbank6, dbank7, dbank8
  .lobytes dbank1, dbank2, dbank3, dbank4
  .lobytes dbank5, dbank6, dbank7, dbank8
  .lobytes dbank1, remix_8_normal, dbank3, remix_8_oni
  .lobytes finned_frontier_easy, dbank6, dbank7, dbank8

  song_address_start_hi:
  .hibytes dbank1, dbank2, dbank3, dbank4
  .hibytes dbank5, dbank6, dbank7, dbank8
  .hibytes dbank1, dbank2, dbank3, dbank4
  .hibytes dbank5, dbank6, dbank7, dbank8
  .hibytes dbank1, remix_8_normal, dbank3, remix_8_oni
  .hibytes finned_frontier_easy, dbank6, dbank7, dbank8

  drum_bank_list:
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK

  song_stars:
  .byte $03, $04, $08, $0A
  .byte $09, $03, $02, $01
  .byte $0A, $04, $03, $09
  .byte $00, $00, $00, $00
  .byte $00, $04, $00, $0A
  .byte $02, $04, $04, $06

  song_author_1: ; ADONETE
  .byte $40, $43, $4E, $4D, $44, $53, $44, $02, $02, $02, $02, $02
  song_author_2: ; DDRKIRBY ISQ
  .byte $43, $43, $51, $4A, $48, $51, $41, $58, $02, $48, $52, $50
  song_author_3: ; AYAKO SASO
  .byte $40, $58, $40, $4A, $4E, $02, $52, $40, $52, $4E, $02, $02
  song_author_4: ; ADONETE
  .byte $40, $43, $4E, $4D, $44, $53, $44, $02, $02, $02, $02, $02
  song_author_5: ; MASAMI YONE
  .byte $4C, $40, $52, $40, $4C, $48, $02, $58, $4E, $4D, $44, $02
  song_author_6: ; THEPURPLANON
  .byte $53, $47, $44, $4F, $54, $51, $4F, $4B, $40, $4D, $4E, $4D

  song_chartr_1: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_2: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_3: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_4: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_5: ; TFD500
  .byte $53, $45, $43, $5F, $5A, $5A, $02, $02, $02, $02, $02, $02
  song_chartr_6: ; DENI_IGUESS (i made it!! i had no other choice-)
  .byte $43, $44, $4D, $48, $67, $48, $46, $54, $44, $52, $52, $02

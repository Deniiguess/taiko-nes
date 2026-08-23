  song_address_start_lo:
  .lobytes karippa_boss_easy, karippa_boss_normal, karippa_boss_hard, karippa_boss_oni
  .lobytes empty, empty, empty, empty
  .lobytes euphoria_easy, euphoria_normal, euphoria_hard, euphoria_oni
  .lobytes empty, empty, empty, empty
  .lobytes empty, remix_8_normal, empty, remix_8_oni
  .lobytes finned_frontier_easy, finned_frontier_normal, finned_frontier_hard, finned_frontier_oni

  song_address_start_hi:
  .hibytes karippa_boss_easy, karippa_boss_normal, karippa_boss_hard, karippa_boss_oni
  .hibytes empty, empty, empty, empty
  .hibytes euphoria_easy, euphoria_normal, euphoria_hard, euphoria_oni
  .hibytes empty, empty, empty, empty
  .hibytes empty, remix_8_normal, empty, remix_8_oni
  .hibytes finned_frontier_easy, finned_frontier_normal, finned_frontier_hard, finned_frontier_oni

  drum_bank_list:
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK2_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK

  song_stars:
  .byte $02, $05, $05, $08
  .byte $00, $00, $00, $00
  .byte $02, $04, $07, $09
  .byte $00, $00, $00, $00
  .byte $00, $04, $00, $08
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

  song_chartr_1: ; DIAMONDN1NJA
  .byte $43, $48, $40, $4C, $4E, $4D, $43, $4D, $5B, $4D, $49, $40
  song_chartr_2: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_3: ; RYUTO
  .byte $51, $58, $54, $53, $4E, $02, $02, $02, $02, $02, $02, $02
  song_chartr_4: ; [blank]
  .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
  song_chartr_5: ; TFD500
  .byte $53, $45, $43, $5F, $5A, $5A, $02, $02, $02, $02, $02, $02
  song_chartr_6: ; DENI_IGUESS (i made it!! i had no other choice-)
  .byte $43, $44, $4D, $48, $67, $48, $46, $54, $44, $52, $52, $02

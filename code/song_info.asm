; chart locations
song_address_start_lo:
  .lobytes karippa_boss_easy, karippa_boss_normal, karippa_boss_hard, karippa_boss_oni
  .lobytes who_unleashed_the_dog_easy, who_unleashed_the_dog_normal, who_unleashed_the_dog_hard, who_unleashed_the_dog_oni
  .lobytes euphoria_easy, euphoria_normal, euphoria_hard, euphoria_oni
  .lobytes bean_brained_easy, bean_brained_normal, bean_brained_hard, bean_brained_oni
  .lobytes remix_8_easy, remix_8_normal, remix_8_hard, remix_8_oni
  .lobytes finned_frontier_easy, finned_frontier_normal, finned_frontier_hard, finned_frontier_oni

  song_address_start_hi:
  .hibytes karippa_boss_easy, karippa_boss_normal, karippa_boss_hard, karippa_boss_oni
  .hibytes who_unleashed_the_dog_easy, who_unleashed_the_dog_normal, who_unleashed_the_dog_hard, who_unleashed_the_dog_oni
  .hibytes euphoria_easy, euphoria_normal, euphoria_hard, euphoria_oni
  .hibytes bean_brained_easy, bean_brained_normal, bean_brained_hard, bean_brained_oni
  .hibytes remix_8_easy, remix_8_normal, remix_8_hard, remix_8_oni
  .hibytes finned_frontier_easy, finned_frontier_normal, finned_frontier_hard, finned_frontier_oni

  drum_bank_list:
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK3_BANK, DBANK3_BANK, DBANK3_BANK, DBANK3_BANK
  .byte DBANK1_BANK, DBANK2_BANK, DBANK1_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK2_BANK, DBANK2_BANK, DBANK2_BANK
  .byte DBANK2_BANK, DBANK1_BANK, DBANK2_BANK, DBANK1_BANK
  .byte DBANK1_BANK, DBANK1_BANK, DBANK1_BANK, DBANK1_BANK

; PRG-ROM bank numbers
  song_bank_numbers:
  .byte MBANK1_BANK, MBANK2_BANK, MBANK3_BANK, MBANK4_BANK, MBANK5_BANK, MBANK6_BANK

; PRG-ROM bank numbers (2A03)
  song_bank_numbers_2A03:
  .byte MBANK2A03_1_BANK, MBANK2A03_2_BANK, MBANK2A03_3_BANK, MBANK2A03_2_BANK, MBANK2A03_1_BANK, MBANK2A03_3_BANK

; song (2A03) locations (because there are multiple in one bank)
  song_location_2A03_low:
  .lobytes music_data_tree_climber_2A03
  .lobytes music_data_ddrkirbyisq_2A03
  .lobytes music_data_rave_racer_2A03
  .lobytes music_data_adonete_2A03
  .lobytes music_data_remix8ds2A03
  .lobytes music_data_finned_frontier_2A03

  song_location_2A03_high:
  .hibytes music_data_tree_climber_2A03
  .hibytes music_data_ddrkirbyisq_2A03
  .hibytes music_data_rave_racer_2A03
  .hibytes music_data_adonete_2A03
  .hibytes music_data_remix8ds2A03
  .hibytes music_data_finned_frontier_2A03

; difficulty stars for the charts
; (up to 10)
  song_stars:
  .byte 2, 5, 5, 8
  .byte 4, 4, 7, 7
  .byte 2, 4, 7, 9
  .byte 1, 3, 4, 6
  .byte 3, 4, 6, 9
  .byte 2, 4, 4, 6

; song creators
; (must be 12 characters long)
  song_author_1:
  .byte "ADONETE     "
  song_author_2:
  .byte "DDRKIRBY ISQ"
  song_author_3:
  .byte "AYAKO SASO  "
  song_author_4:
  .byte "ADONETE     "
  song_author_5:
  .byte "MASAMI YONE "
  song_author_6:
  .byte "THEPURPLANON"

; chart creators
; (must be 12 characters long)
  song_chartr_1:
  .byte "DIAMONDN1NJA"
  song_chartr_2:
  .byte "EGGZ        "
  song_chartr_3:
  .byte "RYUTO       "
  song_chartr_4:
  .byte "DIAMONDN1NJA"
  song_chartr_5:
  .byte "TFD500      "
  song_chartr_6:
  .byte "DENI_IGUESS "

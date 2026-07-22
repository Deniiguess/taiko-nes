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
bg_attr: .res 2
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
diff_sel_cursor_time: .res 1

frame_timer_controller: .res 1

sram_location: .res 2

options_position: .res 1
in_color_set: .res 1

pause: .res 2
pause_pos: .res 1

drum_bank_position_chart_backup: .res 1

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
good_count: .res 4
ok_count: .res 4
bad_count: .res 4
crown: .res 1

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

temp_screen: .res 1
cursor_diff_screen: .res 1
cursor_song_screen: .res 1
cursor_sett_screen: .res 1
drum_sel_screen: .res 1
controller_h_screen: .res 1
diff_icon_screen: .res 1
color_sqr_screen: .res 1
controller_t_screen: .res 1

cursor_diff_Y: .res 1
cursor_song_Y: .res 1
cursor_sett_Y: .res 1
drum_sel_Y: .res 1
controller_h_Y: .res 1
diff_icon_Y: .res 1
color_sqr_Y: .res 1
controller_t_Y: .res 1

diff_sel_load_timer: .res 1

score_to_draw: .res 6
combo_to_draw: .res 4
roll_to_draw: .res 3
good_to_draw: .res 4
okay_to_draw: .res 4
bad_to_draw: .res 4
crown_to_draw: .res 1

frame_timer_score_draw: .res 1

drum_hit_pool: .res 64
drum_hit_pool_pos: .res 2
drum_hit_pool_frame: .res 128
drum_hit_pool_frame_pos: .res 2
drum_spawn_position_kept: .res 128

.segment "SETT"
don_color: .res 3
song_sel_position: .res 3
diff_sel_position: .res 6
controller: .res 1

mods: .res 1
don_color_pos: .res 2

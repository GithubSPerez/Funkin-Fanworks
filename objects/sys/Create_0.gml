global.track_pos = 0;
alarm[0] = 10;
debug = true;
songs_extract();

adv = 1;
show_fps = 60;
time = 0;
s_w = 1280;
s_h = 700;

l_ww = window_get_width();
l_wh = window_get_height();

just_focus = false;
lfoc = true;

levels = 4;
level = 1;
lname[0] = "easy";
lname[1] = "medium";
lname[2] = "hard";
lname[3] = "insane";

lv_col[0] = c_aqua;
lv_col[1] = c_white;
lv_col[2] = c_orange;
lv_col[3] = c_red;

menu = mst.title;
song_n = 0;
editor = false;

sound_mark = false;
file_name = "dad";
set_res = "";
ini_open("lloaded");
file_name = ini_read_string("details", "file", file_name);
ini_close();
gpu_set_texfilter(true);
cus_keys = false;
input_ini();

scroll_dir = 1;
mod_inv = 0;
mod_perfect = 0;
mod_speed = 1;
mod_safe = 0;
mod_bot = false;
mod_delay = 64;
mod_vdelay = 0;
vd_divisor = 1.125;

volume = 1;
vol_a = 0;
top_fps = 120;

opt_load();

goto = noone;
go_trans = false;
on_trans = false;
transition_y = s_h * 2;

white = 0;
maxw = 80;

cursor_load = 0;
cur[0] = cr_size_nesw;
cur[1] = cr_size_we;
cur[2] = cr_size_nwse;
cur[3] = cr_size_ns;

#macro fnt_combo font_add_sprite_ext(spr_numfnt,"1234567890",1,0)
#macro fnt_stars font_add_sprite_ext(spr_stars,"*+1234567890.c",1,0)
depth = -300;
song_list = ds_map_create();
songs = 0;
song_file[0] = "";
song_name = ds_list_create();

scores = ds_map_create();
load_scores();

rsc = ds_map_create();
charts = ds_map_create();
load_rsc();
load_charts();

#region example chart
rsc[? "pico"] = "0";
charts[? "pico_philly"] = "0";
ini_open("c_0_pico_philly.ini");
ini_write_string("details", "res_folder", "r_0_pico");
ini_close();
#endregion

assets = ds_map_create();
re_index = ds_map_create();

global.ars = noone;

game_ver = "1.3";
expected_ver = game_ver;
get_ver = http_get("https://itch.io/api/1/x/wharf/latest?target=srperez/funkinfanworks&channel_name=windows");
up_state = -1;
up_s = 1;
up_x = 0;
up_y = 0;
up_a = 1;
up_timer = 0;

banana = true;
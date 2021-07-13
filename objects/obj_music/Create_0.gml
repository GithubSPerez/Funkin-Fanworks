audio_stop_all();
file_name = sys.file_name;
ini_open("lloaded");
ini_write_string("details", "file", sys.file_name);
ini_close();

bpm = 150;
track_off = 0;
song_name = "Song";
song = mus_spookeez_inst;
song_vc = mus_spookeez_vc;
song_full = mus_spookeez;
lvl_multi = 1;
author = "someone";
composer = "someone";
silence = false;
stars = 3;
res_folder = "";
menu_anim = 0.22;

#region visual data
enum vs
{
	bg_x, bg_y, bg_s, p_halves, p_pace, en_halves, en_pace, p_spd, en_spd, top_x, top_y, p_icon, en_icon, bott_x, bott_y, cam_s, p_jx, p_jy, en_jx, en_jy, gf_jx, gf_jy, p_sing_spd, en_sing_spd, p_loop, en_loop, p_alts, en_alts
}
enum vst
{
	bg, p_idle, p_left, p_down, p_up, p_right, p_miss, en_idle, en_left, en_down, en_up, en_right, p_lost, p_icon, en_icon
}
vdata[vs.bg_x] = -100;
vdata[vs.bg_y] = -150;
vdata[vs.bg_s] = 1;

vdata[vs.top_x] = 0;
vdata[vs.top_y] = 0;
vdata[vs.bott_x] = room_width;
vdata[vs.bott_y] = room_height;

vdata[vs.p_halves] = 1;
vdata[vs.p_pace] = 0.5;
vdata[vs.p_spd] = 0.22;
vdata[vs.p_sing_spd] = 1;
vdata[vs.p_loop] = 0;

vdata[vs.en_halves] = 1;
vdata[vs.en_pace] = 0.5;
vdata[vs.en_spd] = 0.22;
vdata[vs.en_sing_spd] = 1;
vdata[vs.en_loop] = 0;

vdata[vs.p_icon] = 0;
vdata[vs.en_icon] = 1;

vdata[vs.cam_s] = 1;

vdata[vs.p_jx] = 0;
vdata[vs.p_jy] = 0;
vdata[vs.en_jx] = 0;
vdata[vs.en_jy] = 0;
vdata[vs.gf_jx] = 0;
vdata[vs.gf_jy] = 0;

vdata[vs.p_alts] = 1;
vdata[vs.en_alts] = 1;

//strings
vtdata[vst.bg][0] = "bg_spooky";

vtdata[vst.p_idle][0] = "spr_bf_idle";
vtdata[vst.p_left][0] = "spr_bf_l";
vtdata[vst.p_down][0] = "spr_bf_d";
vtdata[vst.p_up][0] = "spr_bf_u";
vtdata[vst.p_right][0] = "spr_bf_r";
vtdata[vst.p_miss][0] = "spr_bf_miss";

vtdata[vst.en_idle][0] = "spr_testchar";
vtdata[vst.en_left][0] = "spr_testchar_l";
vtdata[vst.en_down][0] = "spr_testchar_d";
vtdata[vst.en_up][0] = "spr_testchar_u";
vtdata[vst.en_right][0] = "spr_testchar_r";

vtdata[vst.p_lost][0] = "spr_bf_lost";
vtdata[vst.p_icon][0] = "spr_icon_face";
vtdata[vst.en_icon][0] = "spr_icon_face";

vs_num = array_length(vdata);
vst_num = array_length(vtdata);;

vdesc[0] = "idle sprite"
vdesc[1] = "left press sprite"
vdesc[2] = "down press sprite"
vdesc[3] = "up press sprite"
vdesc[4] = "right press sprite"
vdesc[5] = "miss press sprite"
vdesc[6] = "anim. cycles"
vdesc[7] = "anim. pace scale"
vdesc[8] = "anim. speed"
vdesc[9] = "sing anim. speed"
vdesc[10] = "loop frames"

vedit[0][0] = vst.p_idle;
vedit[0][1] = vst.en_idle;
vedit[1][0] = vst.p_left;
vedit[1][1] = vst.en_left;
vedit[2][0] = vst.p_down;
vedit[2][1] = vst.en_down;
vedit[3][0] = vst.p_up;
vedit[3][1] = vst.en_up;
vedit[4][0] = vst.p_right;
vedit[4][1] = vst.en_right;
vedit[5][0] = vst.p_miss;
vedit[5][1] = vst.en_idle;
vedit[6][0] = vs.p_halves;
vedit[6][1] = vs.en_halves;
vedit[7][0] = vs.p_pace;
vedit[7][1] = vs.en_pace;
vedit[8][0] = vs.p_spd;
vedit[8][1] = vs.en_spd;
vedit[9][0] = vs.p_sing_spd;
vedit[9][1] = vs.en_sing_spd;
vedit[10][0] = vs.p_loop;
vedit[10][1] = vs.en_loop;

alt[0] = 0;
alt[1] = 0;
sprites_set = false;
#endregion

started = false;
playing = noone;
play_vc = noone;
put_ind = 0;
pause = false;
pause_opt = 0;
popt_multi = 0;
popt_selected = 0;
unpause = false;
won = false;
win_mus = noone;
lost_menu = false;
highs = false;
highp = false;
vc_vol = 1;
lvc_vol = vc_vol;
max_pregame = 100;
pregame = max_pregame;
max_go = 30;
artist = "";

restart = false;

back_pos = 0;

depth = -100;
instance_create_depth(0, 0, depth - 1, obj_cam);
instance_create_depth(0, 0, depth - 1, obj_game);
editing = sys.editor;
sys.editor = false;
subsec = 4;

zoom = 2;

load_song(file_name); //el mapa notas se crea dentro de este script

if (sys.set_res != "")
{
	res_folder = sys.set_res;
	sys.set_res = "";
}

global.track_pos = -track_off;
count = -track_off;

mus_spd = (bpm) / 60;

soff = track_off + 4;

actmode = 0;

prev_play = noone;
prev_time = 0;

level = sys.level;
lvl_start = 0.5;
lvl_add = 0.5;

lvl_spd[0] = 0.5;
lvl_spd[1] = 0.75;
lvl_spd[2] = 1;
lvl_spd[3] = 1.15;

max_pulse = 10;
pulse[0] = 0;
pulse[1] = 0;
pulse[2] = 0;
pulse[3] = 0;

max_splash = 14;
splash[0] = 0;
splash[1] = 0;
splash[2] = 0;
splash[3] = 0;

perf[0] = false;
perf[1] = false;
perf[2] = false;
perf[3] = false;

acol[0] = c_purple;
acol[1] = c_aqua;
acol[2] = c_lime;
acol[3] = c_red;

aang[0] = 180;
aang[1] = 270;
aang[2] = 90;
aang[3] = 0;

visual_mode = false;
cam_mode = false;
bg_mode = false;
slist_return = false;
song_return = noone;

bge_index = -1;

corner = 0;
music_pulse = false;
music_beats = 0;

maxstat = 50;
stat = 0;
stat_type = 0;

lwf = true;

last_cmd = "";

arrow_flow = 0;
ar_to_f = 0;
arrow_fx_spd = 1;

gpu_set_texfilter(true);

global.ars = surface_create(sys.s_w, sys.s_h);
ars = global.ars;

monc_x = 0;
monc_y = 0;
monc_side = -4;

click_x = 0;
click_y = 0;

au_list = ds_list_create();
sp_list = ds_list_create();
bg_list = ds_list_create();

draw_list = false;
list_to_draw = au_list;
side_to_draw = 1;

sel_ystart = 0;
sel_xstart = 0;
clip = ds_list_create();
lclip = ds_list_create();

function path_mus_list(Dir, List, Ext)
{
	var f = file_find_first(Dir + "/*" + Ext, 0);
	ds_list_clear(List)
	while (f != "")
	{
		ds_list_add(List, f);
		f = file_find_next();
	}
	file_find_close();
}

if (res_folder != "")
{
	path_mus_list(res_folder + "/audio", au_list, ".ogg");
	path_mus_list(res_folder + "/sprites", sp_list, ".png");
	path_mus_list(res_folder + "/bg", bg_list, ".png");
}

function ex_add_get()
{
	ex_add = (sys.mod_delay/1000) * !editing
	ex_add_f = ex_add * mus_spd * lvl_multi * lvl_spd[level] * 60;
}
ex_add_get();
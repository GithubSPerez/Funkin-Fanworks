function seconds()
{
	//show_message_async(ex_add);
	return((global.track_pos + track_off) / bpm);
}
var sep = (60) / subsec;
var sh_p = keyboard_check(vk_shift);

if (editing) won = false
if (song == mus_flower_inst)
{
	silence = true;
}
switch (floor(won))
{
	case (1):
		if (!silence)
		{
			audio_stop_sound(playing);
			audio_stop_sound(play_vc);
		}
		var reg = file_name + ":" + string(sys.level);
		var skey = reg + ":score";
		var pkey = reg + ":percent";
		var mkey = reg + ":misses";
		var write_s = false;
		var write_p = false;
		var write_m = false;
		if (ds_map_exists(sys.scores, skey))
		{
			if (obj_game.points > sys.scores[? skey])
			{
				write_s = true;
				highs = true;
			}
		}
		else
		{
			write_s = true;
		}
		if (ds_map_exists(sys.scores, pkey))
		{
			if (obj_game.percent > sys.scores[? pkey])
			{
				write_p = true;
				highp = true;
			}
		}
		else
		{
			write_p = true;
		}
		if (ds_map_exists(sys.scores, mkey))
		{
			if (obj_game.misses < sys.scores[? mkey])
			write_m = true
		}
		else
		{
			write_m = true;
		}
		if (!sys.valid_score)
		{
			write_p = false;
			write_s = false;
			write_m = false
		}
		if (write_s) sys.scores[? skey] = obj_game.points;
		if (write_p) sys.scores[? pkey] = obj_game.percent;
		if (write_m) sys.scores[? mkey] = obj_game.misses;
		save_scores();
		won = 2;
	break;
	case (2):
		if (!audio_is_playing(snd_win) and !audio_is_playing(win_mus))
		{
			win_mus = audio_play_sound(mus_win, 1, true);
		}
		if (key_press("start"))
		{
			sound_play(snd_select);
			audio_sound_gain(win_mus, 0, 900);
			audio_sound_gain(snd_win, 0, 900);
			won = 3;
		}
	break;
	case (3):
		won += 0.02
	break;
	case (4):
		sys.goto = rm_menu;
		sys.go_trans = true;
		won = 5;
	break;
}

#region setting visuals
if (!sprites_set)
{
	with (obj_char)
	{
		if (side == 1)
		{
			for (var i = 0; i < other.vdata[vs.p_alts]; i ++)
			{
				idle_spr = asset_load(other.res_folder, other.vtdata[vst.p_idle][0], 1);
		
				dir_spr[0][i] = asset_load(other.res_folder, other.vtdata[vst.p_left][i], 1);
				dir_spr[1][i] = asset_load(other.res_folder, other.vtdata[vst.p_down][i], 1);
				dir_spr[2][i] = asset_load(other.res_folder, other.vtdata[vst.p_up][i], 1);
				dir_spr[3][i] = asset_load(other.res_folder, other.vtdata[vst.p_right][i], 1);
		
				dir_spr[4][i] = asset_load(other.res_folder, other.vtdata[vst.p_miss][i], 1);
			}
			lost_spr = asset_load(other.res_folder, other.vtdata[vst.p_lost][0], 1);
		
			halves = other.vdata[vs.p_halves];
			pace = other.vdata[vs.p_pace];
			spd = other.vdata[vs.p_spd];
			sing_spd = other.vdata[vs.p_sing_spd];
			loop = other.vdata[vs.p_loop];
		}
		else if (side == -1)
		{
			for (var i = 0; i < other.vdata[vs.en_alts]; i ++)
			{
				idle_spr = asset_load(other.res_folder, other.vtdata[vst.en_idle][0], 1);
		
				dir_spr[0][i] = asset_load(other.res_folder, other.vtdata[vst.en_left][i], 1);
				dir_spr[1][i] = asset_load(other.res_folder, other.vtdata[vst.en_down][i], 1);
				dir_spr[2][i] = asset_load(other.res_folder, other.vtdata[vst.en_up][i], 1);
				dir_spr[3][i] = asset_load(other.res_folder, other.vtdata[vst.en_right][i], 1);
			}
		
			halves = other.vdata[vs.en_halves];
			pace = other.vdata[vs.en_pace];
			spd = other.vdata[vs.en_spd];
			sing_spd = other.vdata[vs.en_sing_spd];
			loop = other.vdata[vs.en_loop];
		}
	}
	sprites_set = true;
}
#endregion

#region "countdown"
if (pregame > 0)
{
	pregame --;
	if (pregame == max_go)
	{
		audio_play_sound(snd_go, 1, false);
	}
	exit;
}
#endregion
///if the game hasn't started yet don't continue

//setting values and playing song when starting the game
if (!started and pregame == 0 and !pause)
{
	audio_stop_sound(song);
	audio_stop_sound(song_vc);
	playing = audio_play_sound(song, 1, false);
	play_vc = audio_play_sound(song_vc, 1, false);
	audio_sound_pitch(playing, sys.mod_speed);
	audio_sound_pitch(play_vc, sys.mod_speed);
	global.track_pos = -track_off;
	count = -track_off;
	audio_sound_set_track_position(playing, seconds());
	audio_sound_set_track_position(play_vc, seconds());
	started = true;
	level = sys.level;
}

if (obj_game.hp == 0)
{
	audio_stop_sound(playing);
	audio_stop_sound(play_vc);
	exit;
}

music_pulse = false;
if (!pause and !won)
{
	//advancing the song
	global.track_pos += mus_spd * sys.adv;
	count += mus_spd * sys.adv;
	
	//every beat do this
	music_beats = floor(global.track_pos/60);
	while (count > 60)
	{
		music_pulse = true;
		count -= 60;
		if (editing)
		{
			audio_stop_sound(snd_beat);
			audio_play_sound(snd_beat, 1, false);
			audio_sound_set_track_position(playing, seconds());
			audio_sound_set_track_position(play_vc, seconds());
		}
		//show_message_async(audio_sound_get_track_position(playing));
		//show_message_async(seconds());
	}
}

//change between editor and game
var ed_change = keyboard_check_pressed(ord("7"));
if (ed_change)
{
	save_song(file_name);
	editing = !editing;
	gpu_set_texfilter(!editing);
	global.track_pos = -track_off;
	count = -track_off;
	started = false;
	pause = false;
	with (obj_char)
	{
		reached = 0;
	}
	with (obj_marker)
	{
		state = 0;
		time = 0;
		out = false;
	}
}
if (vc_vol != lvc_vol)
{
	var vtime = 0;
	if (vc_vol = 0)
	{
		vtime = 100;
	}
	audio_sound_gain(play_vc, vc_vol, vtime);
}
lvc_vol = vc_vol;

var wf = window_has_focus();
var f_change = !wf and lwf and !pause;
if (((key_press("jump") and editing) or ((key_press("start") or key_press("back")) and !pause) or unpause or f_change) and !won)
{
	pause ++;
	pause %= 2;
	if (f_change)
	{
		pause = true;
	}
	if (unpause)
	{
		pause = false;
		unpause = false;
	}
	if (pause)
	{
		audio_pause_sound(playing);
		audio_pause_sound(play_vc);
		audio_play_sound(mus_pause, 1, true);
		audio_sound_gain(mus_pause, 0, 0);
		audio_sound_gain(mus_pause, 1, 1000);
	}
	else
	{
		audio_resume_sound(playing);
		audio_resume_sound(play_vc);
		audio_sound_set_track_position(playing, seconds());
		audio_sound_set_track_position(play_vc, seconds());
	}
}
if (!pause or editing)
{
	audio_stop_sound(mus_pause);
	popt_multi = 0;
	popt_selected = -1;
}
else
{
	popt_multi += (1 - popt_multi) / 6;
	if (popt_selected == 0)
	{
		var opchange = (key_press("down") - key_press("up"));
		if (opchange != 0)
		{
			sound_play(snd_menu_move);
			pause_opt += opchange;
			if (pause_opt < 0) pause_opt = 2;
			if (pause_opt > 2) pause_opt = 0;
		}
		if (key_press("start"))
		{
			popt_selected = 1;
			audio_sound_gain(mus_pause, 0, 800);
			sound_play(snd_select);
		}
	}
	else
	{
		popt_selected ++;
		if (popt_selected == 40)
		{
			switch (pause_opt)
			{
				case (0):
					unpause = true;
				break;
				case (1):
				case (2):
					sys.go_trans = true;
					sys.goto = rm_gogame;
					if (pause_opt == 2)
					{
						sys.goto = rm_menu;
					}
				break;
			}
		}
	}
}
lwf = wf;

if (!editing)
{
	exit;
}

#region editing
if (keyboard_check_pressed(ord("9")) or keyboard_check_pressed(ord("7")) or mouse_check_button_released(mb_left))
{
	save_song(file_name);
}

obj_game.preview = visual_mode;
if (!cam_mode and !bg_mode and keyboard_check_pressed(ord("V")))
{
	visual_mode = !visual_mode;
}
if (cam_mode)
{
	if (corner == 0)
	{
		vdata[vs.top_x] += (keyboard_check(vk_right) - keyboard_check(vk_left)) * 3;
		vdata[vs.top_y] += (keyboard_check(vk_down) - keyboard_check(vk_up)) * 3;
	}
	else
	{
		vdata[vs.bott_x] += (keyboard_check(vk_right) - keyboard_check(vk_left)) * 3;
		vdata[vs.bott_y] += (keyboard_check(vk_down) - keyboard_check(vk_up)) * 3;
	}
}
if (visual_mode and !cam_mode and !bg_mode)
{
	vdata[vs.bg_x] += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 3;
	vdata[vs.bg_y] += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 3;
	vdata[vs.bg_s] += (keyboard_check(ord("K")) - keyboard_check(ord("J"))) * 0.1;
	if (keyboard_check_pressed(ord("L")))
	{
		vdata[vs.bg_s] = 1;
	}
	sprites_set = false;
	exit;
}
menu_anim = vdata[vs.en_spd];
///nothing will be executed from this point on if editing visuals

if (keyboard_check_pressed(vk_enter) or restart)
{
	global.track_pos = -track_off;
	audio_stop_all();
	started = false;
	restart = false;
}
if (pause)
{
	var l = global.track_pos;
	var tmove = 0;
	if (!keyboard_check(vk_alt))
	{
		tmove = (keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"))) * sep;
		tmove += (keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"))) * sep * 20;
	}
	if (!sh_p and !keyboard_check(vk_alt))
	{
		tmove -= (mouse_wheel_up() - mouse_wheel_down()) * sep;
	}
	if (tmove != 0)
	{
		global.track_pos = round((global.track_pos) / sep) * sep;
		global.track_pos += tmove
	}
	if (global.track_pos != l)
	{
		audio_stop_sound(prev_play);
		prev_play = audio_play_sound(song_full, 1, false);
		audio_sound_set_track_position(prev_play, seconds() - 6/bpm);
		prev_time = floor(sep / 2.2);
	}
	count = global.track_pos;
}
if (prev_time > 0)
{
	prev_time --;
}
else
{
	audio_stop_sound(prev_play);
}
if (sh_p)
{
	zoom += mouse_wheel_up() - mouse_wheel_down();
	zoom = clamp(zoom, 1, 8);
}
if (keyboard_check(vk_alt))
{
	back_pos += (mouse_wheel_up() - mouse_wheel_down()) * sep;
	back_pos += (keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S"))) * sep;
	back_pos += (keyboard_check_pressed(ord("A")) - keyboard_check_pressed(ord("D"))) * sep * 20;
}

//change actmode
if (keyboard_check_pressed(ord("1")))
{
	actmode ++;
	actmode %= 3;
}
subsec += keyboard_check_pressed(ord("P")) - keyboard_check_pressed(ord("O"));
subsec = clamp(subsec, 1, subsec + 1);
#endregion
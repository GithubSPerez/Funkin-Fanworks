function draw_text_vis(xx, yy, txt, sh_d)
{
	var lcol = draw_get_color();
	draw_set_color(c_black);
	draw_text(xx + sh_d, yy + sh_d, txt);
	draw_set_color(lcol);
	draw_text(xx, yy, txt);
}

var xright = room_width;
var xhalf = room_width / 2;
var ybottom = room_height;
var yhalf = room_height / 2;
time = audio_sound_get_track_position(men_mus) * 60;
beat = (time / (60 * (60 / 102)));

var mp = 70;
var mb = 50;
if (key_press("start") and pressed == -1 and backed == -1)
{
	pressed = mp;
	sound_play(snd_select);
}
if (key_press("back") and backed == -1 and sys.go_trans == false)
{
	if (pressed == -1)
	{
		backed = mb;
	}
	else
	{
		pressed = -1;
	}
	sound_play(snd_menu_back);
}
var tap = (pressed == mp);
var btap = (backed == mb);
if (pressed > 0)
{
	pressed --;
}
if (backed > 0)
{
	backed --;
}
var movslow = 14;

function draw_text_time(yy, txt, s_t, e_t)
{
	if (time >= s_t and time <= e_t)
	{
		draw_text(room_width / 2, room_height / 2 + yy, txt);
	}
}
switch (state)
{
	#region credits
	case (mst.credits):
		//show_message_async(st_time);
		if (st_time == 0)
		{
			audio_sound_gain(men_mus, 1, 2000);
		}
		draw_set_font(fnt_credits);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		var word = "fangame";
		if (sys.banana) word = "mod";
		draw_text_time(-64, word + " by", 3, 144);
		draw_text_time(64, "perez", 108, 144);
		
		draw_text_time(-250, "original game by", 144, 285);
		
		draw_text_time(-120, "Ninjamuffin99", 178, 285);
		draw_text_time(-40, "Phantom Arcade", 205, 285);
		draw_text_time(40, "evilsk8r", 205, 285);
		draw_text_time(120, "Kawai Sprite", 249, 285);
		
		draw_text_time(-64, rline[line][0], 285, 426);
		draw_text_time(64, rline[line][1], 355, 426);
		
		draw_text_time(-120, "Friday", 426, 600);
		draw_text_time(-40, "Night", 460, 600);
		draw_text_time(40, "Funkin'", 495, 600);
		draw_text_time(120, "Fanworks", 528, 600);
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_def);
		var musend = 9.456
		if (time >= musend * 60 or tap or btap)
		{
			state = mst.title;
			white = maxw;
			audio_sound_set_track_position(men_mus, musend)
			audio_stop_sound(snd_select);
			audio_stop_sound(snd_menu_back);
			pressed = -1;
		}
	break;
	#endregion
	
	#region title
	case (mst.title):
		#region draw bg effect
		var lcol = merge_color(c_black, c_dkgray, 0.3);
		var sep = 600;
		var slow = 6;
		for (var i = -1; i < 4; i ++)
		{
			var bx = i * sep + (sep/slow * (beat%slow))
			draw_sprite_ext(spr_square, 0, bx, 0, 4, 20, 5 + (bx) / 100, lcol, 1);
		}
		#endregion
		
		#region DEBUG borrar despues
		if (keyboard_check_pressed(ord("O"))) state = mst.rsc_list;
		#endregion
		
		#region draw gf
		var num = sprite_get_number(spr_gf_idle);
		var gi = beat / 2 * num;
		var gx = xhalf * 1.4;
		var gy = ybottom - 10;
		var col1 = merge_color(c_blue, c_white, 0.25);
		var col2 = merge_color(merge_color(c_red, c_purple, 0.5), c_white, 0.25);
		var cmerge = clamp((1 - beat % 1) / 2 - 0.15, 0, 1);
		col1 = merge_color(col1, c_white, cmerge);
		col2 = merge_color(col2, c_white, cmerge);
		var pos_alter = dsin(90 * (beat % 1)) * 5;
		var ojx = -4;
		var ojy = 4;
		shader_set(sh_only_outline);
		draw_sprite_ext(spr_gf_idle, gi, gx + ojx * 3 - pos_alter * 2, gy + ojy * 2.5 + pos_alter * 2, 1, 1, 0, col1, 1);
		draw_sprite_ext(spr_gf_idle, gi, gx + ojx - pos_alter, gy + ojy + pos_alter, 1, 1, 0, col2, 1);
		shader_reset();
		draw_sprite(spr_gf_idle, gi, gx, gy);
		#endregion
		
		#region draw press enter
		var col = merge_color(c_aqua, c_purple, 0.5 - dcos(beat * 90) / 2);
		var i = 0;
		if (pressed > -1)
		{
			i = (time % 4) / 2;
			col = c_white;
		}
		draw_sprite_ext(spr_press, i, 30, ybottom - 10, 1, 1, 0, col, 1);
		#endregion
		
		#region draw title
		var s = 1 + dcos((beat%1) * 600) * clamp(1 - (beat%1) * 1.8, 0, 1) * 0.03;
		draw_sprite_ext(spr_title, 0, 350, 270, s, s, 0, c_white, 1);
		#endregion
		
		#region exiting when loading sprites
		if (!loaded)
		{
			draw_set_color(c_black);
			draw_rectangle(0, 0, 2000, 2000, false)
			draw_set_color(c_white);
			loaded = true;
			state = mst.credits;
			audio_sound_set_track_position(men_mus, 0);
		}
		else if (tap)
		{
			white = maxw;
		}
		#endregion
		
		#region exiting titlescreen
		audio_stop_sound(snd_menu_back);
		backed = -1;
		if (pressed == 20)
		{
			sys.go_trans = true;
		}
		if (sys.on_trans)
		{
			state = mst.main;
			pressed = -1;
		}
		#endregion
	break;
	#endregion
	
	#region main menu
	case (mst.main):
		#region draw bg
		var bi = 0;
		if (pressed > -1)
		{
			bi = (pressed / 9) % 2;
		}
		draw_sprite_ext(bg_menu, bi, 0, y, 1.1, 1.1, 0, c_white, 1);
		#endregion
		
		#region version & update
		var vertxt = "FunkinFanworks v" + sys.game_ver;
		if (sys.banana) vertxt = "FunkinFanworks [GameBanana build] v" + sys.game_ver
		if (sys.needs_update)
		{
			opt[4] = "update";
			if (sys.up_state == -1) sys.up_state = 0;
			if (sys.up_timer > 0) men_vol = 0;
			else men_vol += (1 - men_vol) / 10;
			vertxt += "  (outdated, latest is v" + sys.expected_ver + ")";
		}
		draw_set_color(c_black);
		draw_text(6, sys.s_h - 24, vertxt);
		draw_set_color(c_white);
		#endregion
		
		#region draw menu
		draw_set_font(fnt_menu);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		var opts = array_length(opt);
		for (var i = 0; i < opts; i ++)
		{
			var o_y = 120;
			var o_j = 150;
			if (sys.needs_update)
			{
				o_y = 100;
				o_j = 120;
			}
			var rain_col = c_white;
			
			if ((i == 4) and sys.needs_update)
			{
				rain_col = make_color_hsv((time * 2) % 255, 255, 255);
			}
			
			var tx = sys.s_w / 2;
			var ty = o_y + o_j*i - y/4;
			if (select == i)
			{
				if (pressed == -1 or time % 8 >= 4)
				{
					draw_opt(tx, ty, opt[i], rain_col, c_black, true);
				}
			}
			else
			{
				var a = 1;
				if (pressed > -1)
				{
					a = 1 - (1 - (pressed / mp)) * 4
				}
				draw_set_alpha(a);
				draw_opt(tx, ty, opt[i], c_black, rain_col, false);
				draw_set_alpha(1);
			}
		}
		
		draw_set_font(fnt_def);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		#endregion
		
		#region changing option
		var selmov = (key_press("down") - key_press("up"))
		if (selmov != 0 and pressed == -1)
		{
			select += selmov;
			if (select > opts - 1) select = 0;
			if (select < 0) select = opts - 1;
			sound_play(snd_menu_move);
		}
		if (btap and pressed == -1)
		{
			select = 3;
			backed = -1;
		}
		toy = -select * 30 / (opts / 4);
		#endregion
		
		#region selecting option
		if (tap)
		{
			//sys.goto = rm_gogame;
		}
		if (pressed == 20)
		{
			sys.go_trans = true;
		}
		if (sys.on_trans)
		{
			switch (select)
			{
				case (0):
					state = mst.play;
					audio_sound_gain(men_mus, 0, 1000);
				break;
				case (1):
					state = mst.create;
				break;
				case (2):
					state = mst.keys;
				break;
				case (3):
					game_end();
				break;
				case (4):
					url_open("https://srperez.itch.io/funkinfanworks");
				break;
			}
			pressed = -1;
		}
		#endregion
	break;
	#endregion
	
	#region select song menu
	case (mst.play):
		if (!songs_loaded)
		{
			songs_get();
			song = sys.song_n;
			songs_loaded = true;
		}
		movslow = 8;
		var rdis = 5;
		draw_sprite_ext(bg_menu, 2, rdis*dcos(sys.time) - rdis, rdis*dsin(sys.time) - rdis, 1.1, 1.1, 0, c_white, 0.9);
		
		var vis_w = 330;
		var violet = make_color_rgb(146, 113, 253);
		draw_sprite_ext(spr_square, 1, -200, 0, 5.5, 30, 10, violet, 0.8);
		draw_sprite_ext(spr_square, 1, vis_w, 0, 0.5, 30, 10, c_black, 1);
		
		for (var i = 1; i < 6; i ++)
		{
			draw_mod(i, 400 + (i - 1) * 40, 42, 2);
		}
		
		var i_s = 2;// + abs(dcos(time * 6)) * 0.2;
		gpu_set_tex_filter(false);
		draw_sprite_ext(spr_mod_indicator, 0, 416, 20, i_s, i_s, 0, c_white, 1);
		gpu_set_tex_filter(true);
		
		draw_set_font(fnt_info);
		draw_text_vis(438, 6, "mods and options", 2);
		draw_set_font(fnt_def);
		
		var en_spr = sys.song_list[? sys.song_file[song] + ":en_spr"];
		/*
		shader_set(sh_only_outline);
		if (en_spr == spr_among_idle)
		{
			shader_reset();
			shader_set(sh_amogus);
		}
		*/
		shader_set(sh_gray_scale);
		
		var sf = sys.song_file[song];
		
		draw_sprite_ext(en_spr, sys.time * sys.song_list[? sf + ":anim"] * 0.8, 200, sys.s_h - 100, 0.5, 0.5, 0, violet, 1);
		shader_reset();
		
		draw_set_font(fnt_info)
		var inf_x = 10;
		var inf_y = 24;
		var inf_jy = 64;
		
		var stroke = 1.5;
		if (sys.song_list[? sf + ":author"] != "[hide]")
		{
			draw_text_vis(inf_x, inf_y, "Chart by:\n" + sys.song_list[? sf + ":author"], stroke);
		}
		
		var hs = 0;
		var ma = 0;
		var mss = -1;
		var cr = 0;
		var geth = sf + ":" + string(sys.level) + ":score";
		var geta = sf + ":" + string(sys.level) + ":percent";
		var getm = sf + ":" + string(sys.level) + ":misses";
		if (ds_map_exists(sys.scores, geth)) hs = sys.scores[? geth];
		if (ds_map_exists(sys.scores, geta)) ma = sys.scores[? geta];
		if (ds_map_exists(sys.scores, getm))
		{
			mss = sys.scores[? getm];
			cr ++;
			if (sys.scores[? getm] <= 0) cr ++;
			if (sys.scores[? geta] >= 100) cr ++;
		}
		
		draw_text_vis(inf_x, inf_y + inf_jy, "Highscore: " + string(hs), stroke);
		if (ma < 100)
		{
			draw_text_vis(inf_x, inf_y + 2*inf_jy, "Max accuracy: " + string(ma) + "%", stroke);
		}
		else
		{
			draw_set_color(c_yellow);
			draw_text_vis(inf_x, inf_y + 2*inf_jy, "Perfect 100%", stroke);
			draw_set_color(c_white);
		}
		if (mss != -1)
		{
			if (mss != 0)
			{
				draw_text_vis(inf_x, inf_y + 1.5 * inf_jy, "Misses: " + string(mss), stroke);
			}
			else
			{
				draw_set_color(c_yellow);
				draw_text_vis(inf_x, inf_y + 1.5 * inf_jy, "Full Combo", stroke);
				draw_set_color(c_white);
			}
		}
		
		draw_set_font(fnt_stars);
		var strs = "";
		var ammo = sys.song_list[? sf + ":stars"];
		for (var i = 0; i < floor(ammo); i ++)
		{
			strs += "*";
		}
		if (floor(ammo) != ammo)
		{
			strs += "+";
		}
		strs += string(ammo);
		strs = string_replace(strs, ".50", ".5")
		draw_text_vis(inf_x, inf_y + 2*inf_jy + 30, strs, 2);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		var lv_x = 220;
		var lv_y = sys.s_h - 48;
		var lv = sys.lname[sys.level];
		
		draw_set_font(fnt_stars);
		var c_str = "";
		repeat (cr) c_str += "c";
		draw_text_vis(lv_x, lv_y - 48, c_str, 2);
		draw_set_font(fnt_list);
		
		draw_set_color(sys.lv_col[sys.level]);
		draw_text_vis(lv_x, lv_y, lv, 3);
		draw_set_color(c_white);
		draw_sprite_ext(spr_lvl_change, 0, lv_x + 3, lv_y - 4 + 3, lvc_s, 1, 0, c_black, 1);
		draw_sprite_ext(spr_lvl_change, 0, lv_x, lv_y - 4, lvc_s, 1, 0, c_white, 1);
		lvc_s += (1 - lvc_s) / 6;
		
		draw_set_halign(fa_right);
		draw_set_valign(fa_center);
		
		var songs = sys.songs;
		var selmov = (key_press("down") - key_press("up"))
		if (selmov != 0 and pressed == -1)
		{
			song += selmov;
			if (song > songs - 1) song = 0;
			if (song < 0) song = songs - 1;
			sound_play(snd_menu_move);
			audio_stop_sound(prev);
		}
		var lvmov = (key_press("right") - key_press("left"))
		if (lvmov != 0 and pressed == -1)
		{
			sys.level += lvmov;
			if (sys.level > sys.levels - 1) sys.level = 0;
			if (sys.level < 0) sys.level = sys.levels - 1;
			sound_play(snd_menu_move);
			lvc_s = 1.1;
		}
		
		if (!audio_is_playing(prev) or prev = noone)
		{
			prev = audio_play_sound(sys.song_list[? sys.song_file[song] + ":audio"], 1, true);
			audio_sound_gain(prev, 0, 0);
			audio_sound_gain(prev, 1, 1000);
		}
		
		var nsep = 110;
		toy = song * nsep;
		for (var i = 0; i < sys.songs; i ++)
		{
			var t = sys.song_list[? sys.song_file[i] + ":name"];
			var tx = sys.s_w - 10;
			var ty = sys.s_h / 2 + nsep*i - y;
			var sd = 4;
			draw_set_alpha(1 - (song != i) / 2)
			
			if (pressed > -1)
			{
				if (i == song)
				{
					draw_set_alpha(floor(pressed / 6) % 2);
				}
				else
				{
					draw_set_alpha((1 - (1 - (pressed / mp)) * 4) * 0.5);
				}
			}
			draw_set_color(c_black);
			draw_text(tx + sd, ty + sd, t);
			draw_set_color(c_white);
			draw_text(tx, ty, t);
			
			draw_set_font(fnt_score);
			draw_text_vis(tx, ty + 40, sys.song_list[? sys.song_file[i] + ":composer"], 2);
			var ar = sys.song_list[? sys.song_file[i] + ":art"];
			if (ar != "" and i == song)
			{
				draw_set_color(c_yellow);
				draw_text_vis(tx, ty - 44, "Art by " + ar, 2);
				draw_set_color(c_white);
			}
			draw_set_font(fnt_list);
			
			draw_set_alpha(1);
		}
		draw_set_font(fnt_def);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		if (!qtrans)
		{
			if (tap)
			{
				sys.goto = rm_gogame;
				sys.file_name = sys.song_file[song];
			}
			if (pressed == 20)
			{
				sys.go_trans = true;
				audio_sound_gain(prev, 0, 900);
			}
			if (btap)
			{
				sys.go_trans = true;
				audio_sound_gain(prev, 0, 900);
			}
			if (sys.on_trans and backed > -1)
			{
				state = mst.main;
				audio_stop_sound(prev);
				backed = -1;
				y = 0;
				toy = 0;
			}
		}
		if (keyboard_check_pressed(ord("Q")) and backed == -1 and pressed == -1)
		{
			pressed = 0;
			backed = 0;
			sys.go_trans = true;
			qtrans = true;
		}
		if (qtrans and sys.on_trans)
		{
			state = mst.mods;
			pressed = -1;
			backed = -1;
			qtrans = false;
		}
	break;
	#endregion
	
	#region key config
	case (mst.keys):
		#region draw bg
		var bi = 0;
		draw_sprite_ext(bg_menu, 1, 0, y, 1.1, 1.1, 0, c_white, 1);
		#endregion
		
		#region drawing active or not
		draw_set_font(fnt_list);
		var inf_x = 10;
		var inf_y = 24;
		var inf_jy = 64;
		
		var stroke = 2;
		tf[0] = "default";
		tf[1] = "custom";
		draw_text_vis(inf_x, inf_y, "keybinds: <" + tf[sys.cus_keys] + ">" , stroke);
		
		
		#endregion
		
		#region drawing arrows and keys
		var arr_y = 150;
		var arr_jy = 120;
		draw_set_valign(fa_center);
		defk[0] = "a / left";
		defk[1] = "s / down";
		defk[2] = "w / up";
		defk[3] = "d / right";
		
		for (var i = 0; i < 4; i ++)
		{
			var sc = 0.65;
			if (sys.cus_keys)
			{
				var ktxt = chr(sys.cus[i]);
				if (kc_setting)
				{
					ktxt = "";
					if (i = kc_opt)
					{
						ktxt = "press a key";
					}
				}
				draw_text_vis(138, arr_y + arr_jy * i, ktxt, 2);
				if (i = kc_opt) sc = 0.75 + dcos(time * 10) * 0.1;
			}
			else
			{
				draw_text_vis(138, arr_y + arr_jy * i, defk[i] , 2);
			}
			draw_sprite_ext(spr_arrow, i, 70, arr_y + arr_jy*i, sc, sc, 0, c_white, 1);
		}
		draw_set_font(fnt_def);
		draw_set_valign(fa_top);
		#endregion
		
		#region changing
		if (!kc_setting)
		{
			var xm = key_press("right") - key_press("left");
			if (xm != 0)
			{
				sys.cus_keys += abs(xm);
				sys.cus_keys %= 2;
				sound_play(snd_menu_move);
			}
			
			var ym = key_press("down") - key_press("up");
			
			if (sys.cus_keys)
			{
				if (ym != 0)
				{
					kc_opt += ym;
					if (kc_opt == -1) kc_opt = 3;
					kc_opt %= 4;
					sound_play(snd_menu_move);
				}
				if (key_press("start"))
				{
					kc_setting = true;
					pressed = -1;
					audio_stop_sound(snd_select);
				}
			}
			else
			{
				if (key_press("start"))
				{
					pressed = -1;
					audio_stop_sound(snd_select);
				}
			}
		}
		else
		{
			if (keyboard_check_pressed(vk_anykey))
			{
				if !(key_press("back"))
				{
					sys.cus[kc_opt] = keyboard_key;
					sound_play(snd_select);
					kc_setting = false;
				}
				else
				{
					kc_setting = false;
					backed = -1;
					exit;
				}
			}
		}
		#endregion
		
		#region going back
		if (btap and !kc_setting)
		{
			sys.go_trans = true;
			audio_sound_gain(prev, 0, 900);
			with (sys)
			{
				opt_save();
			}
		}
		if (sys.on_trans and backed > -1)
		{
			state = mst.main;
			audio_stop_sound(prev);
			backed = -1;
		}
		#endregion
	break;
	#endregion
	
	#region mods
	case (mst.mods):
		y = 0;
		#region draw bg
		var bi = 0;
		draw_sprite_ext(bg_menu, 1, 0, y, 1.1, 1.1, 0, c_gray, 1);
		#endregion
		
		draw_set_font(fnt_info);
		
		var bdx = 48;
		var bdy = 20;
		
		mod_txt[0] = "scroll direction"
		mod_txt[1] = "song speed"
		mod_txt[2] = "accuracy"
		mod_txt[3] = "arrow visibility"
		mod_txt[4] = "safety net"
		mod_txt[5] = "automatic bot"
		mod_txt[6] = "audio delay"
		mod_txt[7] = "visual delay"
		
		mod_edit[0] = sys.scroll_dir;
		mod_edit[1] = sys.mod_speed;
		mod_edit[2] = sys.mod_perfect;
		mod_edit[3] = sys.mod_inv;
		mod_edit[4] = sys.mod_safe;
		mod_edit[5] = sys.mod_bot;
		mod_edit[6] = sys.mod_delay;
		mod_edit[7] = sys.mod_vdelay;
		
		var mod_num = array_length(mod_edit);
		
		mod_ostr[0][0] = "upwards";
		mod_ostr[0][1] = "downwards";
		mod_ostr[2][0] = "normal";
		mod_ostr[2][1] = "no misses";
		mod_ostr[2][2] = "only perfect";
		mod_ostr[3][0] = "normal";
		mod_ostr[3][1] = "fading";
		mod_ostr[3][2] = "invisible";
		mod_ostr[4][0] = "none";
		mod_ostr[4][1] = "half damage";
		mod_ostr[4][2] = "can't lose";
		mod_ostr[5][0] = "deactivated";
		mod_ostr[5][1] = "activated";
		
		draw_text_vis(bdx, bdy, "gameplay modifiers and options", 2);
		if (!sys.valid_score)
		{
			draw_set_color(c_orange);
			draw_text_vis(bdx, bdy + 350, "Score and accuracy won't be saved", 2);
			draw_set_color(c_white);
		}
		//draw_text_vis(bdx, bdy, "gameplay modifiers");
		
		var m_y = 30;
		var m_jy = 38;
		for (var i = 0; i < mod_num; i ++)
		{
			if (i == 0)
			{
				var optxt = mod_ostr[i][0];
				if (mod_edit[i] == -1)
				{
					optxt = mod_ostr[i][1];
				}
			}
			else if (i == 1)
			{
				optxt = "x" + string(mod_edit[i]);
			}
			else if (i == 6 or i == 7)
			{
				optxt = string(mod_edit[i]) + "ms"
			}
			else
			{
				var optxt = mod_ostr[i][mod_edit[i]];
			}
			draw_set_color(c_gray);
			if (i = mod_opt) draw_set_color(c_yellow);
			
			var txy = bdy + m_y + m_jy*i;
			draw_text_vis(bdx, txy, mod_txt[i] + ": <" + optxt + ">", 2);
			
			draw_set_color(c_white);
			
			draw_mod(i, bdx - 38, txy, 2);
		}
		draw_set_font(fnt_def);
		
		#region changing
		var ym = key_press("down") - key_press("up");
		if (ym != 0)
		{
			mod_opt += ym;
			if (mod_opt < 0) mod_opt = mod_num - 1;
			mod_opt %= mod_num;
			sound_play(snd_menu_move);
		}
		
		var xm = key_press("right") - key_press("left");
		var xs = key("right") - key("left");
		if (calc_delay)
		{
			xs = 0;
			xm = 0;
		}
		if (xm != 0)
		{
			switch (mod_opt)
			{
				case (0):
					if (mod_edit[mod_opt] == 1) mod_edit[mod_opt] = -1;
					else mod_edit[mod_opt] = 1;
				break;
				case (1):
					mod_edit[mod_opt] += 0.25*xm;
					mod_edit[mod_opt] = clamp(mod_edit[mod_opt], 0.5, 2);
				break;
				case (6):
				case (7):
					//nada xd
				break;
				default:
					mod_edit[mod_opt] += xm;
					if (mod_edit[mod_opt] < 0) mod_edit[mod_opt] = array_length(mod_ostr[mod_opt]) - 1;
					mod_edit[mod_opt] %= array_length(mod_ostr[mod_opt]);
				break;
			}
			var sn = sound_play(snd_menu_move);
			audio_sound_pitch(sn, 1.1);
		}
		if (xs != 0)
		{
			switch (mod_opt)
			{
				case (6):
				case (7):
					ms_t --;
					if (ms_t < 0) ms_t = 0;
					if (ms_t == 0)
					{
						mod_edit[mod_opt] += xs;
						mod_edit[mod_opt] = clamp(mod_edit[mod_opt], -1000, 1000);
						ms_up -= 5;
						ms_up = clamp(ms_up, 3, 600);
						ms_t = ms_up;
						
						if (ms_up != 0)
						{
							var sn = sound_play(snd_menu_move);
							audio_sound_pitch(sn, 1.1);
						}
					}
				break;
			}
		}
		else
		{
			ms_up = 30;
			ms_t = 0;
		}
		#endregion
		
		sys.scroll_dir = mod_edit[0];
		sys.mod_speed = mod_edit[1];
		sys.mod_perfect = mod_edit[2];
		sys.mod_inv = mod_edit[3];
		sys.mod_safe = mod_edit[4];
		sys.mod_bot = mod_edit[5];
		sys.mod_delay = mod_edit[6];
		sys.mod_vdelay = mod_edit[7];
		
		var de_reset = false;
		if (mod_opt == 6)
		{
			if (key_press("jump") and !calc_delay)
			{
				calc_delay = true;
				exit;
			}
			if (calc_delay)
			{
				audio_sound_gain(prev, 0, 0);
				var onbeat = (de_maxtime / 4) * 3;
				var stime = de_time;
				if (de_time % (de_maxtime / 4) == 0)
				{
					var s = sound_play(snd_beat);
					audio_sound_pitch(s, 0.9);
					if (de_time % de_maxtime == onbeat)
					{
						audio_sound_pitch(s, 1);
					}
				}
				de_time ++;
				
				var ar_x = 700;
				var ar_y = 100;
				var ar_s = 0.6;
				draw_sprite_ext(spr_arrow_bg, 2 - 2*key_press("d"), ar_x, ar_y, ar_s, ar_s, 0, c_white, 1);
				
				var ar_spd = 4.5;
				if (mod_opt = 7)
				{
					for (var ii = 0; ii < 5; ii ++)
					{
						draw_sprite_ext(spr_arrow, 3, ar_x, ar_y + (onbeat - (de_time % de_maxtime)) * ar_spd + de_maxtime*ar_spd*ii, ar_s, ar_s, 0, c_white, 1);
					}
				}
				else
				{
					var val = 3 - floor(((de_time % de_maxtime) / de_maxtime) * 4);
					var txt = val;
					if (val == 0) txt = "now"
					draw_text_vis(ar_x, ar_y, txt, 1);
				}
				
				if (key_press("d"))
				{
					ds_list_add(de_val_list, round((de_time % de_maxtime - onbeat) / 60 * 1000));
					
					de_aprox = 0;
					var lsize = ds_list_size(de_val_list);
					for (var j = 0; j < lsize; j ++)
					{
						de_aprox += de_val_list[| j];
					}
					de_aprox /= lsize;
					if (lsize == de_presses)
					{
						de_reset = true;
					}
				}
				lsize = ds_list_size(de_val_list);
				var ms = string(de_aprox);
				if (mod_opt == 7)
				{
					ms = string(sys.mod_delay) + "ms" + " - " + string(de_aprox);
				}
				draw_text_vis(ar_x, ar_y + 60, ms + "ms" + "\nPress "+string(de_presses - lsize)+" more", 1);
			}
			else
			{
				draw_text_vis(450, 290, "Press space to configure latency", 1);
			}
		}
		else
		{
			if (calc_delay)
			{
				de_reset = true;
			}
		}
		if (de_reset)
		{
			audio_sound_gain(prev, 1, 0);
			de_time = 0;
			calc_delay = false;
			if (mod_opt == 6)
			{
				sys.mod_delay = de_aprox;
				sys.mod_vdelay = round(de_aprox / sys.vd_divisor);
			}
			else
			{
				sys.mod_vdelay = sys.mod_delay - de_aprox;
			}
			de_aprox = 0;
			ds_list_clear(de_val_list);
		}
		
		#region going back
		if (btap)
		{
			sys.go_trans = true;
			with (sys)
			{
				opt_save();
			}
		}
		if (sys.on_trans and backed > -1)
		{
			state = mst.play;
			backed = -1;
			pressed = -1;
		}
		if (tap)
		{
			pressed = -1;
			audio_stop_sound(snd_select);
		}
		#endregion
	break;
	#endregion
	
	#region rsc list
	case (mst.rsc_list):
		if (!instance_exists(obj_resource_creator)) instance_create_depth(0, 0, -2, obj_resource_creator);
	break;
	#endregion
	
	#region create screen
	case (mst.create):
		var m_ind = mouse_y > sys.s_h / 2;
		
		draw_set_color(c_dkgray);
		draw_rectangle(0, 0, 2000, 2000, false);
		draw_set_color(c_white);
		
		draw_set_font(fnt_list);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		if (m_ind == 0) draw_set_color(c_yellow);
		draw_text(sys.s_w / 2, sys.s_h / 4, "resource folder");
		draw_set_color(c_white);
		if (m_ind == 1) draw_set_color(c_yellow);
		draw_text(sys.s_w / 2, sys.s_h / 4 * 3, "chart");
		draw_set_color(c_white);
		draw_line(0, sys.s_h / 2, 2000, sys.s_h / 2);
		draw_set_font(fnt_def);
		
		var jy = 60;
		draw_text(sys.s_w / 2, sys.s_h / 4 + jy, "Folder that contains audio, sprites and backgrounds.\nCan be used by one or more charts.")
		draw_text(sys.s_w / 2, sys.s_h / 4 * 3 + jy, "");
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		if (mouse_check_button_released(mb_left))
		{
			if (m_ind == 0)
			{
				state = mst.rsc_list;
			}
			else
			{
				if (ds_map_empty(sys.rsc))
				{
					show_message("You don't have any resource folders yet!");
				}
				else
				{
					state = mst.chart_setup;
				}
			}
		}
		
		#region going back
		if (btap)
		{
			sys.go_trans = true;
		}
		if (sys.on_trans and backed > -1)
		{
			state = mst.main;
			backed = -1;
		}
		#endregion
	break;
	#endregion
	
	case (mst.chart_setup):
		if (!instance_exists(obj_resource_creator))
		{
			var r = instance_create_depth(0, 0, -2, obj_resource_creator);
			r.state = 10;
		}
	break;
}
if (state != mst.credits and state != mst.play and state != mst.mods)
{
	audio_sound_gain(men_mus, men_vol, 0);
}
if (white > 0)
{
	draw_set_alpha(white / maxw);
	draw_rectangle(0, 0, 2000, 2000, false)
	draw_set_alpha(1);
	white --;
}

y += (toy - y) / movslow;
st_time += sys.adv;

if (lstate != state)
{
	st_time = 0;
}
lstate = state;

sys.menu = state;
sys.song_n = song;
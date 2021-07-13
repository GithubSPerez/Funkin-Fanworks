function get_data(str, def, type)
{
	var ret = get_string(str, def);
	if (ret != "")
	{
		if (floor(type) == 0) //asset
		{
			var ass = asset_load(res_folder, ret, type * 10)
			if (ass != -1 and ass != undefined)
			{
				return(ret);
			}
			else
			{
				show_message("asset doesn't exist");
			}
		}
		else if (type == 1) //real
		{
			return(ret);
		}
		else if (type == 2) //string
		{
			return(ret);
		}
	}
	return(def);
}
function draw_asset_list(Side, List)
{
	if (res_folder != "")
	{
		var xx = obj_cam.cam_x - obj_cam.cam_w / 2;
		var yy = obj_cam.cam_y - obj_cam.cam_h / 2;
		if (draw_list and !bg_mode)
		{
			xx = vdata[vs.top_x];
			yy = vdata[vs.top_y];
		}
		var rsx = sys.s_w / 2 + 120;
		var rsize = 300;
	
		if (Side == -1)
		{
			rsx = sys.s_w / 2 - 120;
			draw_set_halign(fa_right);
		}
		draw_set_alpha(0.75);
		draw_set_color(c_black);
		draw_rectangle(xx + rsx, yy, xx + rsx + rsize * Side, yy + 2000, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		for (var i = 0; i < ds_list_size(List); i ++)
		{
			draw_text(xx + rsx + 2 * Side, yy + 50 + 20*i, List[| i]);
		}
		draw_set_halign(fa_left);
	}
}
function draw_text_s(xx, yy, str)
{
	var lcol = draw_get_color();
	if (lcol != c_black)
	{
		draw_set_color(c_black);
		draw_text(xx + 1.5, yy + 1.5, str);
	}
	draw_set_color(lcol);
	draw_text(xx, yy, str);
}
function btt_press(Bttx, Btty, Btt_img)
{
	draw_sprite(spr_button, Btt_img, Bttx, Btty);
	if (mouse_check_button_pressed(mb_left))
	{
		if (point_distance(mouse_x, mouse_y, Bttx, Btty) < 20)
		{
			return(true);
		}
	}
	return(false);
}
function btt_hover(Bttx, Btty)
{
	if (point_distance(mouse_x, mouse_y, Bttx, Btty) < 25)
	{
		return(true);
	}
	return(false);
}

var cur_pos = (global.track_pos) * zoom;
var draw_pos = cur_pos;
var sep = (60 / subsec) * zoom;

var xoff = 64;
var yoff = 256;
postprev_x = 526 + 18;

var m_x = mouse_x - xoff;
var m_y = mouse_y - yoff;

if (!editing)
{
	exit;
}
gpu_set_texfilter(!editing);
if (obj_cam.cam_w != sys.s_w) gpu_set_texfilter(true);

#region editor
var top_x = vdata[vs.top_x];
var top_y = vdata[vs.top_y];

var cw = obj_cam.cam_w;
var ch = obj_cam.cam_h;
var cx = obj_cam.cam_x - cw / 2;
var cy = obj_cam.cam_y - ch / 2;

var cr = cx + cw;
var cd = cy + ch;

#region selecting a song
if (slist_return)
{
	draw_set_color(c_dkgray);
	draw_rectangle(0, 0, 2000, 2000, false);
	if (ds_list_empty(sys.song_name))
	{
		songs_get();
	}
	
	draw_set_color(c_white);
	
	var j = 0;
	var jx = 24;
	var m_ind = floor(mouse_y / jx);
	var on_file = "";
	for (var i = 0; i < sys.songs; i ++)
	{
		var sfile = sys.song_file[i];
		ini_open(sfile + ".ini");
		var resfol = ini_read_string("details", "res_folder", "");
		ini_close();
		
		if (resfol == "" or resfol == res_folder)
		{
			var col = c_white;
			var txt = sys.song_list[? sfile + ":" + "name"];
			
			if (resfol == res_folder and res_folder != "") col = c_aqua;
			
			draw_set_color(col);
			if (m_ind == j)
			{
				draw_set_color(c_yellow);
				on_file = sys.song_file[i];
			}
			draw_text_s(0, jx*j, txt);
			draw_set_color(c_white);
			j ++;
		}
	}
	draw_text_s(sys.s_w / 2, 0, "Can import only from base game charts\n& charts with shared folders.")
	if (btt_press(sys.s_w - 40, 40, 7))
	{
		slist_return = false;
	}
	if (mouse_check_button_pressed(mb_left))
	{
		if (mouse_x < sys.s_w / 2)
		{
			if (on_file != "")
			{
				song_return = on_file;
				slist_return = false;
			}
		}
	}
	
	exit;
}
#endregion
#region bg mode
if (bg_mode)
{
	var list_x = cx + 80;
	var list_y = cy + 64;
	var l_jy = 35;
	var bt_jx = 30;
	var lbtt_x = list_x - bt_jx*2;
	
	if (btt_press(lbtt_x, list_y - l_jy, 17))
	{
		var new_name = get_string("Type a name for the new element", "");
		if (new_name != "")
		{
			if (!bge_exists(new_name))
			{
				bge_add(new_name);
				var ins = instance_create_depth(0, 0, 0, obj_bg_element);
				ins.e_id = new_name;
				bge_index = bge_number() - 1;
			}
			else
			{
				show_message("Element name already exists! choose another one.");
			}
		}
	}
	if (btt_press(lbtt_x + bt_jx, list_y - l_jy, 7))
	{
		bg_mode = false;
		bge_index = -1;
	}
	if (btt_press(lbtt_x + bt_jx * 3, list_y - l_jy, 19))
	{
		slist_return = true;
	}
	if (song_return != noone)
	{
		var f = song_return;
		var doit = get_string("Are you sure you want to import " + sys.song_list[? f + ":" + "name"] + "'s bg elements?\nThe current elements will be replaced. (y/n)", "");
		if (doit == "y")
		{
			ini_open(song_return + ".ini");
			load_song_real(vs.bg_x);
			load_song_real(vs.bg_y);
			load_song_real(vs.bg_s);
			load_song_string(vst.bg);
			ini_close();
			song_read_bge(f);
			save_song(file_name);
			instance_destroy(obj_bg_element);
			load_song(file_name);
		}
		song_return = noone;
	}
	draw_set_valign(fa_center);
	for (var i = 0; i < bge_number(); i ++)
	{
		draw_text_s(list_x, list_y + l_jy * i, bge_get_name(i));
		if (btt_press(lbtt_x, list_y + l_jy * i, 14 * (bge_index == i)))
		{
			bge_index = i;
		}
		if (btt_press(lbtt_x + bt_jx, list_y + l_jy * i, 18))
		{
			if (get_string("Are you sure you want to delete \"" + bge_get_name(i) + "\"? (y/n)", "") == "y")
			{
				bge_delete(i);
			}
		}
	}
	draw_set_halign(fa_center);
	draw_text_s(cx + cw / 2, cy + 15, "Use the arrow keys to look around");
	draw_set_halign(fa_right);
	if (bge_index == clamp(bge_index, 0, bge_number() - 1) and bge_number() > 0)
	{
		draw_set_halign(fa_center);
		draw_text_s(cx + cw / 2, cy + 40, "Use the mouse to move the element");
		draw_set_halign(fa_right);
		
		ebtt_x = cr - 32;
		ebtt_y = cy + 32;
		ebtt_jy = 32;
		ebtt_jx = 32;
		
		var curname = bge_get_name(bge_index);
		
		function butt_xd(Name, Prop, By, Imsg, Smsg, Bimg)
		{
			var is_asset = (Prop == "sprite");
			var imtype = 0;
			
			var sdef = filename_name(bgep_get(Name, Prop));
			if (!is_asset)
			{
				sdef = bgep_get(Name, Prop);
			}
			if (Prop == "hdir")
			{
				imtype = 1;
			}
			
			draw_text_s(ebtt_x, ebtt_y + ebtt_jy * By, Smsg + ": "+ string(sdef) + "    ");
			if (btt_press(ebtt_x, ebtt_y + ebtt_jy * By, Bimg))
			{
				if (!is_asset)
				{
					switch (imtype)
					{
						case (0):
							bgep_set(Name, Prop, real(get_data(Imsg, sdef, 1)));
						break;
						case (1):
							bgep_set(Name, Prop, bgep_get(Name, Prop) * -1);
						break;
					}
				}
				else
				{
					bgep_set(Name, Prop, get_data(Imsg, sdef, 0));
				}
			}
		}
		butt_xd(curname, "sprite", 0, "Type sprite asset/file name", "Sprite", 0);
		butt_xd(curname, "x", 1, "Type X position", "X", 0);
		butt_xd(curname, "y", 2, "Type y position", "Y", 0);
		butt_xd(curname, "img_speed", 3, "Type speed factor (automatically adjusted with song beat)", "Anim speed", 0);
		butt_xd(curname, "scale", 4, "Type sprite scale", "Scale", 0);
		butt_xd(curname, "scroll_factor", 5, "Type scroll factor", "Scroll factor", 0);
		butt_xd(curname, "depth", 6, "Type depth (greater value means further behind) (positive values are background and negative values are foreground)", "Depth", 0);
		butt_xd(curname, "angle", 7, "Type rotation angle", "Rotation", 0);
		butt_xd(curname, "alpha", 8, "Type image opacity", "Opacity", 0);
		butt_xd(curname, "hdir", 9, "", "Hor. direction", 20);
		
		if (btt_hover(ebtt_x, ebtt_y))
		{
			draw_list = true;
			list_to_draw = sp_list;
			side_to_draw = 1;
		}
		
		if (mouse_check_button(mb_left))
		{
			bgep_set(curname, "x", bgep_get(curname, "x") + mouse_x - click_x);
			bgep_set(curname, "y", bgep_get(curname, "y") + mouse_y - click_y);
		}
	}
	click_x = mouse_x;
	click_y = mouse_y;
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	if (draw_list)
	{
		draw_asset_list(side_to_draw, list_to_draw)
		draw_list = false;
	}
	exit;
}
#endregion
//nothing will be executed from this point on if bg mode is active

#region cam mode
if (cam_mode)
{
	var bttx = obj_cam.cam_x;
	var btty = obj_cam.cam_y - obj_cam.cam_h / 2 + 20;
	draw_sprite(spr_button, 1, bttx, btty);
	draw_sprite(spr_button, 7, bttx + 100, btty);
	
	var cor_txt = "top and left";
	
	if (corner == 1)
	{
		cor_txt = "bottom and right";
	}
	draw_set_halign(fa_center);
	draw_text_s(bttx, btty + 20, "editing corners: " + cor_txt);
	draw_text_s(obj_cam.cam_x, obj_cam.cam_y - 15, "use the arrow keys to adjust camera limits");
	draw_text_s(obj_cam.cam_x, obj_cam.cam_y + sys.s_h / 2 - 30, "change camera zoom (press X/Z): " + string(1 / vdata[vs.cam_s]));
	draw_set_halign(fa_left);
	
	if (mouse_check_button_pressed(mb_left))
	{
		if (point_distance(mouse_x, mouse_y, bttx, btty) < 25)
		{
			corner ++;
			corner %= 2;
		}
		if (point_distance(mouse_x, mouse_y, bttx + 100, btty) < 25) cam_mode = false;
	}
	vdata[vs.cam_s] += 0.1 * (keyboard_check_pressed(ord("Z")) - keyboard_check_pressed(ord("X")))
	vdata[vs.cam_s] = clamp(vdata[vs.cam_s], 1, 4);
	
	oPlayer = noone
	oEnemy = noone
	oGf = noone
	with (obj_char)
	{
		if (side == 1) other.oPlayer = id;
		else if (side == -1) other.oEnemy = id;
		else if (side == 0) other.oGf = id;
	}
	draw_set_color(c_black);
	draw_line(oPlayer.xstart + 1, oPlayer.ystart + 1, oPlayer.x + 1, oPlayer.y + 1)
	draw_set_color(c_blue);
	draw_line(oPlayer.xstart, oPlayer.ystart, oPlayer.x, oPlayer.y)
	
	draw_set_color(c_black);
	draw_line(oEnemy.xstart + 1, oEnemy.ystart + 1, oEnemy.x + 1, oEnemy.y + 1)
	draw_set_color(c_blue);
	draw_line(oEnemy.xstart, oEnemy.ystart, oEnemy.x, oEnemy.y)
	
	draw_set_color(c_black);
	draw_line(oGf.xstart + 1, oGf.ystart + 1, oGf.x + 1, oGf.y + 1)
	draw_set_color(c_blue);
	draw_line(oGf.xstart, oGf.ystart, oGf.x, oGf.y)
	
	if (btt_press(bttx - 64, btty, 19))
	{
		slist_return = true;
	}
	if (song_return != noone)
	{
		if (get_string("Are you sure you want to import " + sys.song_list[? song_return + ":" + "name"] + "'s camera data?\ncurrent data will be replaced. (y/n)", "") == "y")
		{
			ini_open(song_return + ".ini");
			load_song_real(vs.top_x);
			load_song_real(vs.top_y);
			load_song_real(vs.bott_x);
			load_song_real(vs.bott_y);
			load_song_real(vs.p_jx);
			load_song_real(vs.p_jy);
			load_song_real(vs.en_jx);
			load_song_real(vs.en_jy);
			load_song_real(vs.gf_jx);
			load_song_real(vs.gf_jy);
			load_song_real(vs.cam_s);
			ini_close();
		}
		song_return = noone;
	}
	if (mouse_y > btty + 40)
	{
		if (mouse_check_button_pressed(mb_left))
		{
			monc_x = mouse_x;
			monc_y = mouse_y;
			monc_side = -4;
			with (obj_char)
			{
				if (mouse_x > bbox_left and mouse_x < bbox_right and mouse_y > bbox_top and mouse_y < bbox_bottom)
				{
					other.monc_side = side;
				}
			}
		}
		if (mouse_check_button(mb_left))
		{
			if (monc_side == 1)
			{
				var monc_xedit = vs.p_jx;
				var monc_yedit = vs.p_jy;
			}
			if (monc_side = -1)
			{
				monc_xedit = vs.en_jx;
				monc_yedit = vs.en_jy;
			}
			else if (monc_side = 0)
			{
				monc_xedit = vs.gf_jx;
				monc_yedit = vs.gf_jy;
			}
			if (monc_side != -4)
			{
				vdata[monc_xedit] += mouse_x - monc_x;
				vdata[monc_yedit] += mouse_y - monc_y;
				monc_x = mouse_x;
				monc_y = mouse_y;
			}
		}
	}
	exit;
}
#endregion
//nothing will be executed from this point on if cam mode is active

#region visual mode
if (visual_mode)
{
	var btt_x = top_x + 32;
	var btt_y = top_y + 32;
	var btt_jy = 32;
	var btt_r = top_x*2 + sys.s_w - btt_x;
	var totald = 11;
	var totals = 6;
	for (var j = 0; j < 2; j ++)
	{
		var al_dir = 1 - (2 * (j == 0))
		var al_jx = 260;
		var al_y = top_y + 0;
		var al_x = btt_x + al_jx;
		if (al_dir == -1) al_x = btt_r - al_jx;
		
		draw_set_halign(fa_center);
		draw_text_s(al_x, al_y, "alt:\n" + string(alt[j]));
		draw_set_halign(fa_left);
		
		var altvs = vs.p_alts;
		if (j == 1) altvs = vs.en_alts;
		var alts = vdata[altvs];
		var h_ab = 40;
		var v_ab = 30;
		if (alt[j] > 0)
		{
			if (btt_press(al_x - h_ab, al_y + v_ab, 16)) alt[j] --;
		}
		if (alt[j] < alts - 1)
		{
			if (btt_press(al_x + h_ab, al_y + v_ab, 15)) alt[j] ++;
		}
		var greater = vdata[altvs] > 1;
		var addp = btt_press(al_x + 18 * (greater), al_y + 70, 17);
		var delp = btt_press(al_x - 18, al_y + 70 - 200 * (!greater), 18);
		if (addp and !delp)
		{
			if (j == 0)
			{
				vtdata[vst.p_right][vdata[altvs]] = "spr_testchar_r";
				vtdata[vst.p_left][vdata[altvs]] = "spr_testchar_l";
				vtdata[vst.p_up][vdata[altvs]] = "spr_testchar_u";
				vtdata[vst.p_down][vdata[altvs]] = "spr_testchar_d";
				vtdata[vst.p_miss][vdata[altvs]] = "spr_bf_miss";
			}
			else
			{
				vtdata[vst.en_right][vdata[altvs]] = "spr_testchar_r";
				vtdata[vst.en_left][vdata[altvs]] = "spr_testchar_l";
				vtdata[vst.en_up][vdata[altvs]] = "spr_testchar_u";
				vtdata[vst.en_down][vdata[altvs]] = "spr_testchar_d";
			}
			vdata[altvs] ++;
		}
		if (delp and !addp)
		{
			vdata[altvs] --;
			vdata[altvs] = clamp(vdata[altvs], 1, vdata[altvs] + 1);
		}
		
		alt[j] = clamp(alt[j], 0, alts - 1);
		
		
		for (var i = 0; i < totald; i ++)
		{
			var skip = false;
			if (alt[!j] != 0 and (i == 0 or i > 5))
			{
				skip = true;
			}
			if (i == 5 and j == 0)
			{
				skip = true;
			}
			if (!skip)
			{
				var dx = btt_x;
				var tx = btt_x + 24;
				var dy = btt_y + btt_jy * i;
				if (j == 1)
				{
					dx = btt_r;
					tx = btt_r - 24;
					draw_set_halign(fa_right);
				}
				draw_sprite(spr_button, 0, dx, dy);
				draw_text_s(tx, dy - 16, vdesc[i]);
				
				if (mouse_x > dx - 25 and mouse_x < dx + 25)
				{
					var sid = 1;
					if (j == 0) sid = -1;
					draw_list = true;
					list_to_draw = sp_list;
					side_to_draw = sid;
				}
			
				draw_set_halign(fa_left);
			}
		}
		
		var copy_x = btt_r;
		if (j == 1) copy_x = btt_x;
		if (btt_press(copy_x, btt_y + 380, 19))
		{
			slist_return = true;
			im_side = j;
		}
	}
	//import from other charts
	if (song_return != noone)
	{
		var typ = "player";
		if (im_side == 1) typ = "enemy"
		if (get_string("Are you sure you want to import " + sys.song_list[? song_return + ":" + "name"] + "'s " + typ + " data?\ncurrent data will be replaced. (y/n)", "") == "y")
		{
			ini_open(song_return + ".ini");
			if (im_side == 0)
			{
				load_song_real(vs.p_spd);
				load_song_real(vs.p_halves);
				load_song_real(vs.p_icon);
				load_song_real(vs.p_loop);
				load_song_real(vs.p_pace);
				load_song_real(vs.p_sing_spd);
				load_song_real(vs.p_alts);
					
				load_song_string(vst.p_down);
				load_song_string(vst.p_up);
				load_song_string(vst.p_right);
				load_song_string(vst.p_left);
				load_song_string(vst.p_icon);
				load_song_string(vst.p_lost);
				load_song_string(vst.p_miss);
				load_song_string(vst.p_idle);
			}
			else
			{
				load_song_real(vs.en_spd);
				load_song_real(vs.en_halves);
				load_song_real(vs.en_icon);
				load_song_real(vs.en_loop);
				load_song_real(vs.en_pace);
				load_song_real(vs.en_sing_spd);
				load_song_real(vs.en_alts);
					
				load_song_string(vst.en_down);
				load_song_string(vst.en_up);
				load_song_string(vst.en_right);
				load_song_string(vst.en_left);
				load_song_string(vst.en_icon);
				load_song_string(vst.en_idle);
			}
			ini_close();
		}
		song_return = noone;
	}
	if (mouse_check_button_pressed(mb_left))
	{
		var ind = clamp(floor((mouse_y - btt_y + (btt_jy / 2)) / btt_jy), 0, totald - 1);
		var tocheck = 1;
		var pass = true;
		if (mouse_x > btt_r - 24)
		{
			tocheck = 0;
		}
		else if (mouse_x > btt_x + 24)
		{
			pass = false;
		}
		if (mouse_y > btt_y + btt_jy * totald)
		{
			pass = false;
		}
		if (tocheck = 1 and ind == 5)
		{
			pass = false;
		}
		if (alt[tocheck] != 0 and (ind == 0 or ind > 5))
		{
			pass = false;
		}
		if (pass)
		{
			var setind = vedit[ind][tocheck];
			if (ind < totals)
			{
				vtdata[setind][alt[tocheck]] = get_data(vdesc[ind], vtdata[setind][alt[tocheck]], 0.1);
			}
			else
			{
				var msg = vdesc[ind];
				if (ind == 10) msg = vdesc[ind] + " (frames at the ending of idle animation that will loop after every cycle)";
				vdata[setind] = real(get_data(msg, vdata[setind], 1));
			}
			save_song(file_name);
		}
	}
	if (keyboard_check_pressed(vk_up)) alt[0] = !alt[0];
	
	
	//changing icons
	var icn_x = top_x + 75;
	var icn_y = top_y + sys.s_h - 150;
	var icn_l = top_x*2 + sys.s_w - icn_x;
	var icn_editx = 100;
	draw_sprite_ext(asset_load(res_folder, vtdata[vst.en_icon][0], 1), vdata[vs.p_icon] * 2, icn_l, icn_y, -1, 1, 0, c_white, 1);
	draw_sprite(asset_load(res_folder, vtdata[vst.p_icon][0], 1), vdata[vs.en_icon] * 2, icn_x, icn_y);
	
	draw_sprite(spr_button, 0, icn_x + icn_editx, icn_y)
	draw_sprite(spr_button, 0, icn_l - icn_editx, icn_y)
	
	var bgbtt_x = top_x + sys.s_w / 2;
	var bgbtt_y = top_y + sys.s_h - 20;
	var cambtt_y = top_y + 20;
	draw_sprite(spr_button, 0, bgbtt_x, bgbtt_y);
	draw_sprite(spr_button, 6, bgbtt_x, cambtt_y);
	
	var lose_y = -170;
	
	draw_set_halign(fa_right);
	if (alt[0] == 0)
	{
		draw_sprite(spr_button, 0, icn_l, icn_y + lose_y);
		draw_text_s(icn_l - 22, icn_y + lose_y - 10, "lose sprite");
	}
	draw_text_s(top_x + sys.s_w - 4, top_y + sys.s_h - 60, "Use WASD to move bg, use JKL to rescale it\nPress V to edit chart")
	
	draw_set_halign(fa_center);
	draw_text_s(bgbtt_x, bgbtt_y - 40, "change bg");
	draw_text_s(bgbtt_x, cambtt_y + 20, "edit camera limits\n& character positions");
	draw_set_halign(fa_left);
	
	var onbgbtt =  point_distance(mouse_x, mouse_y, bgbtt_x, bgbtt_y) < 25;
	var on_p_icon = point_distance(mouse_x, mouse_y, icn_x + icn_editx, icn_y) < 25;
	var on_en_icon = point_distance(mouse_x, mouse_y, icn_l - icn_editx, icn_y) < 25;
	if (point_distance(mouse_x, mouse_y, icn_l, icn_y + lose_y) < 25 or onbgbtt or on_p_icon or on_en_icon)
	{
		draw_list = true;
		list_to_draw = sp_list;
		side_to_draw = 1;
		if (onbgbtt) list_to_draw = bg_list;
		if (on_p_icon) side_to_draw = -1;
	}
	draw_text(bgbtt_x + 64 + 20, bgbtt_y - 15, "edit bg elements")
	if (btt_press(bgbtt_x + 64, bgbtt_y, 14))
	{
		bg_mode = true;
	}
	if (mouse_check_button_pressed(mb_left))
	{
		if (point_distance(mouse_x, mouse_y, icn_x, icn_y) < 75)
		{
			vdata[vs.en_icon] ++;
			vdata[vs.en_icon] %= sprite_get_number(spr_icon_face);
		}
		if (point_distance(mouse_x, mouse_y, icn_l, icn_y) < 75)
		{
			vdata[vs.p_icon] ++;
			vdata[vs.p_icon] %= floor(sprite_get_number(spr_icon_face) / 2);
		}
		if (on_p_icon)
		{
			vtdata[vst.p_icon][0] = get_data("enter sprite file name / asset name", filename_name(vtdata[vst.p_icon][0]), 0.1);
		}
		if (on_en_icon)
		{
			vtdata[vst.en_icon][0] = get_data("enter sprite file name / asset name", filename_name(vtdata[vst.en_icon][0]), 0.1);
		}
		if (point_distance(mouse_x, mouse_y, icn_l, icn_y + lose_y) < 25 and alt[0] == 0)
		{
			vtdata[vst.p_lost][0] = get_data("enter sprite file name / asset name", filename_name(vtdata[vst.p_lost][0]), 0.1);
		}
		if (onbgbtt)
		{
			vtdata[vst.bg][0] = get_data("enter stage asset", vtdata[vst.bg][0], 0.2);
		}
		if (point_distance(mouse_x, mouse_y, bgbtt_x, cambtt_y) < 25)
		{
			cam_mode = true;
		}
		save_song(file_name);
	}
	
	if (draw_list)
	{
		draw_asset_list(side_to_draw, list_to_draw)
		draw_list = false;
	}
	exit;
}
#endregion
//nothing will be executed from this point on if editing visuals

//grid
draw_sprite_tiled_ext(spr_grid, 0, xoff, yoff -draw_pos - sep / 2, 1, sep / 32, c_white, 1);
//boundries
draw_set_color(c_dkgray);
draw_rectangle(0, 0, xoff + 31, room_height, false);
draw_rectangle(xoff + postprev_x, 0, xoff + postprev_x + 32, room_height, false);
draw_set_color(c_white);

//lines at the side
for (var i = -32; i < 64; i ++)
{
	var pos = yoff -(draw_pos % (60 * zoom)) + i * sep;
	draw_sprite(spr_line, 0, xoff, pos);
	var num = (i * sep + floor(draw_pos / (60 * zoom)) * (60 * zoom)) / (sep * subsec) * 2; //wtffff
	if (floor(num) == num)
	{
		draw_text_s(xoff, pos, num);
	}
}
//mouse track positions
rput_ind = (round((m_y + cur_pos) / sep) * sep) / zoom;
put_ind = rput_ind - cur_pos;
dput_ind = round((m_y + draw_pos) / sep) * sep - draw_pos;
draw_sprite_ext(spr_line, 0, xoff + 32, yoff, 30, 1, 0, c_white, 0.75);
draw_sprite_ext(spr_line, 0, xoff + 32, yoff + dput_ind, 30, 1, 0, c_white, 0.75);

//draw item on mouse
var cl_s = ds_list_size(clip);
form = clamp(floor(m_x / 32) - 1, 0, 15);
var xs = 1;
var ys = 1;
if (actmode >= 1)
{
	xs = 0.4;
	if (actmode == 2) ys = 0.4;
}
draw_sprite_ext(spr_edit_mark, form, xoff +  (form + 1) * 32 + 16, yoff + dput_ind, xs, ys, 0, c_white, 0.5 - (cl_s > 0));

#region drawing, selecting, copying and pasting
var mpress = false;
if (cl_s > 0)
{
	mpress = mouse_check_button_pressed(mb_left);
	if (mpress)
	{
		with (obj_marker) selected = false;
	}
	for (var i = 0; i < cl_s; i ++)
	{
		var t = clip[| i];
		var c_dir = read_till(t, ",");
		t = string_replace(t, c_dir + ",", "");
		var c_act = read_till(t, ",");
		t = string_replace(t, c_act + ",", "");
		var c_pos = t;
		
		var d_dir = (form + real(c_dir) - clip_minx) % sprite_get_number(spr_mark);
		var d_act = real(c_act);
		var d_pos = real(rput_ind + real(c_pos) - clip_miny);
		
		var xs = 1;
		var ys = 1;
		if (d_act >= 1)
		{
			xs = 0.4;
			if (d_act == 2) ys = 0.4;
		}
		draw_sprite_ext(spr_edit_mark, d_dir, xoff +  (d_dir + 1) * 32 + 16, yoff + d_pos * zoom - draw_pos, xs, ys, 0, c_white, 0.5);
		
		if (mpress)
		{
			var save_key = string(d_dir) + "," + string(d_act) + "," + string(d_pos);
			if (ds_map_exists(notes, save_key))
			{
				instance_destroy(notes[? save_key]);
			}
			
			var ins = instance_create_depth(d_pos, 0, -4, obj_marker);
			ins.track_pos = d_pos;
			ins.dir = d_dir;
			ins.actmode = d_act;
			ins.selected = true;
			/*
			if (is_cmd)
			{
				last_cmd = get_string("Input command", last_cmd);
				ins.command = last_cmd;
				note_cmd[? save_key] = last_cmd;
			}
			*/
			notes[? save_key] = ins;
		}
	}
	if (mpress)
	{
		ds_list_clear(clip);
	}
}

if (mouse_check_button_pressed(mb_right))
{
	sel_xstart = form;
	sel_ystart = rput_ind;
	sel_dstart = m_y + draw_pos;
}
if (mouse_check_button_released(mb_right))
{
	with (obj_marker)
	{
		if (!keyboard_check(vk_shift)) selected = false;
		var miny = other.sel_ystart;
		var maxy = other.rput_ind;
		if (miny > maxy)
		{
			miny = maxy;
			maxy = other.sel_ystart;
		}
		var minx = other.sel_xstart;
		var maxx = other.form;
		if (minx > maxx)
		{
			minx = maxx;
			maxx = other.sel_xstart;
		}
		if (track_pos >= miny and track_pos <= maxy and dir >= minx and dir <= maxx)
		{
			selected = true;
		}
	}
}
xkey = keyboard_check_pressed(ord("X"));
if (keyboard_check_pressed(ord("C")) or xkey)
{
	ds_list_destroy(clip)
	clip = ds_list_create();
	clip_miny = noone;
	clip_minx = 20;
	with (obj_marker)
	{
		if (selected)
		{
			var save_key = string(dir) + "," + string(actmode) + "," + string(track_pos);
			if (other.clip_miny = noone or track_pos < other.clip_miny)
			{
				other.clip_miny = track_pos;
			}
			if (dir < other.clip_minx)
			{
				other.clip_minx = dir;
			}
			ds_list_add(other.clip, save_key);
			selected = false;
			if (other.xkey)
			{
				ds_map_delete(other.notes, save_key);
				instance_destroy();
			}
		}
	}
	ds_list_read(lclip, ds_list_write(clip))
}
if (keyboard_check_pressed(ord("B")))
{
	ds_list_read(clip, ds_list_write(lclip));
}
if (keyboard_check_pressed(vk_backspace) or keyboard_check_pressed(vk_delete))
{
	with (obj_marker)
	{
		if (selected)
		{
			var save_key = string(dir) + "," + string(actmode) + "," + string(track_pos);
			ds_map_delete(other.notes, save_key);
			instance_destroy();
		}
	}
}
if (mouse_check_button(mb_right))
{
	draw_set_color(c_blue);
	draw_rectangle(xoff + (sel_xstart + 1) * 32 + 16, yoff + sel_ystart * zoom - (draw_pos), xoff + (form + 1) * 32 + 16, yoff + dput_ind, true);
	draw_set_color(c_white);
}
#endregion
with (obj_marker)
{
	var xs = 1;
	var ys = 1;
	if (actmode >= 1)
	{
		xs = 0.4;
		if (actmode == 2) ys = 0.4;
	}
	draw_sprite_ext(spr_edit_mark, dir, xoff + (dir + 1) * 32 + 16, yoff + (track_pos - global.track_pos) * other.zoom, xs, ys, 0, image_blend, 1);
	draw_sprite_ext(spr_edit_mark, dir, xoff + (dir + 1) * 32 + 16 + other.postprev_x, yoff + (track_pos - global.track_pos + other.back_pos) * other.zoom, xs, ys, 0, image_blend, 1);
}

//putting down notes
var is_cmd = (form == 10 or form == 11)
var save_key = string(form) + "," + string(actmode) + "," + string(rput_ind);

if (is_cmd)
{
	if (ds_map_exists(notes, save_key))
	{
		draw_set_color(c_black);
		draw_text(mouse_x, mouse_y + 30, notes[? save_key].command);
		draw_set_color(c_white);
	}
}
if (mouse_check_button_pressed(mb_left) and !mpress and mouse_x < sys.s_w - 128 and mouse_x > 40)
{
	
	//show_message(save_key);
	if (!ds_map_exists(notes, save_key))
	{
		var ins = instance_create_depth(rput_ind, 0, -4, obj_marker);
		ins.track_pos = rput_ind;
		ins.dir = form;
		ins.actmode = actmode;
		if (is_cmd)
		{
			last_cmd = get_string("Input command", last_cmd);
			ins.command = last_cmd;
			note_cmd[? save_key] = last_cmd;
		}
		notes[? save_key] = ins;
	}
	else
	{
		var nins = notes[? save_key];
		if (nins.dir == 10 or nins.dir == 11)
		{
			last_cmd = nins.command;
		}
		instance_destroy(nins);
		ds_map_delete(notes, save_key);
		if (ds_map_exists(note_cmd, save_key)) ds_map_delete(note_cmd, save_key);
	}
}

//draw properties
draw_set_halign(fa_right);
draw_set_color(c_black);
var opt_y = 64;
var opt_x = sys.s_w - 20;
var opt_jy = 32;

disp[0] = "file name: " + file_name;
disp[1] = "song name: " + song_name;
disp[2] = "bpm: " + string(bpm);
disp[3] = "instrumental asset: " + filename_name(res_get_name(song, 0));
disp[4] = "voice asset: " + filename_name(res_get_name(song_vc, 0));
disp[5] = "song asset: " + filename_name(res_get_name(song_full, 0));
disp[6] = "song offset in frames: " + string(track_off);
disp[7] = "arrow speed factor: " + string(lvl_multi);
disp[8] = "map author: " + author;
disp[9] = "song composer: " + composer;
disp[10] = "difficulty: " + string(stars);
disp[11] = "artists ";

if (res_folder != "") disp[0] = "reload";
for (var i = 0; i < 12; i ++)
{
	var yy = opt_y + opt_jy * i
	draw_sprite(spr_button, i == 0, opt_x, yy);
	draw_text_s(opt_x - 32, yy - 16, disp[i]);
}
draw_text_s(sys.s_w - 4, sys.s_h - 40, "Press V to edit visual data")
draw_set_halign(fa_left);

draw_text_s(sys.s_w / 2 + 20, 5, "hold ALT to scroll side view");
draw_text_s(100, 5, "press 7 to play");

draw_set_color(c_white);

//clicking and editing them
if (mouse_x > opt_x - 15)
{
	var mind = floor((mouse_y - opt_y + 15) / opt_jy);
	mind = clamp(mind, 0, 11);
	
	if (mind >= 3 and mind <= 5)
	{
		draw_asset_list(1, au_list);
	}
	if (mouse_check_button_pressed(mb_left))
	{
		switch (mind)
		{
			case (0):
				if (res_folder == "")
				{
					sys.file_name = get_data("enter file name to load", file_name, 2);
					room_goto(rm_gogame);
				}
				else
				{
					room_goto(rm_gogame);
				}
				exit;
			break;
			case (1):
				song_name = get_data("enter song name", song_name, 2);
			break;
			case (2):
				bpm = real(get_data("enter bpm", bpm, 1));
			break;
			case (3):
				song = asset_load(res_folder, get_data("Instrumental audio file name or asset name", filename_name(res_get_name(song, 0)), 0), 0);
				restart = true;
			break;
			case (4):
				song_vc = asset_load(res_folder, get_data("Voices audio file name or asset name", filename_name(res_get_name(song_vc, 0)), 0), 0);
				restart = true;
			break;
			case (5):
				song_full = asset_load(res_folder, get_data("Complete song audio file name or asset name", filename_name(res_get_name(song_full, 0)), 0), 0);
				restart = true;
			break;
			case (6):
				track_off = real(get_data("Enter time offset of the song in frames\n(positive values make the song start later and negative values make it start sooner)", track_off, 1));
			break;
			case (7):
				lvl_multi = real(get_data("Enter arrow speed multiplication factor", lvl_multi, 1));
			break;
			case (8):
				author = get_data("Enter author name(s)", author, 2);
			break;
			case (9):
				composer = get_data("Enter song composer(s)", composer, 2);
			break;
			case (10):
				stars = get_data("Enter estimated difficulty", stars, 1);
			break;
			case (11):
				artist = get_data("Enter artist(s) names", artist, 2);
			break;
		}
		save_song(file_name);
	}
}

var it_x = 18;
var it_y = 200;
var it_jy = 35;
function op_btt(xx, yy, Img, Str)
{
	draw_sprite(spr_button, Img, xx, yy);
	draw_text_s(xx + 20, yy - 10, Str);
	if (mouse_check_button_pressed(mb_left) and point_distance(mouse_x, mouse_y, xx, yy) < 25)
	{
		return(true);
	}
}
if (op_btt(it_x, it_y, 8, "[1]"))
{
	actmode ++;
	actmode %= 3;
}
if (op_btt(it_x, it_y + it_jy, 3, "[P]"))
{
	subsec ++;
}
if (op_btt(it_x, it_y + it_jy*2, 2, "[O]"))
{
	subsec --;
}

if (btt_hover(it_x, it_y + it_jy*3))
{
	draw_set_color(c_black);
	draw_text(mouse_x + 32, mouse_y + 20, "Difficulties below hard won't\nshow all the notes in gameplay");
	draw_set_color(c_white);
}
if (op_btt(it_x, it_y + it_jy*3, 10 + sys.level, ""))
{
	sys.level ++;
	sys.level %= 4;
	level = sys.level;
	with (obj_marker)
	{
		state = 0;
		out = false;
		time = 0;
	}
}
if (op_btt(it_x, it_y + it_jy*4, 9, ""))
{
	show_message("W, S: go forwards and backwards\nA, D: jump forwards and backwards\nSpace bar: play/pause song\nReturn: jump to the beginning\nLeft click: select region (shift to add)\nC: copy selection\nDelete: delete selected\nB: reload previous clipboard");
}
draw_sprite_ext(spr_arrow_prev, actmode, it_x, it_y, 0.15, 0.15, 0, c_white, 1);
#endregion
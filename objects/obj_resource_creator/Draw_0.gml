function path_list(Dir, List, Ext)
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
function btt(X, Y, Img)
{
	draw_sprite(spr_small_btt, Img, X, Y);
	if (mouse_check_button_released(mb_left))
	{
		if (mouse_x > X - 20 and mouse_x < X and mouse_y > Y and mouse_y < Y + 20)
		{
			return(true);
		}
	}
	return(false);
}
function sure(Fname)
{
	var del = get_string("Are you sure you want to delete \""+Fname+"\"? (y/n)", "");
	if (del == "y" or del == "yes")
	{
		return(true);
	}
	else
	{
		return(false);
	}
}

var s_w = room_width;
var s_h = room_height;

draw_set_color(c_dkgray);
draw_rectangle(0, 0, 2000, 2000, false);
draw_set_color(c_white);

var b_bord = 6;

switch (state)
{
	//going back
	case (-1):
		if (sys.on_trans)
		{
			obj_menu.state = mst.create;
			obj_menu.pressed = -1;
			obj_menu.backed = -1;
			instance_destroy();
		}
	break;
	//folder list
	case (0):
		var t_y = 80;
		var t_jy = 25;
		
		var m_xlimit = room_width - 100;
		var m_ind = floor((mouse_y - t_y) / t_jy);
		if (mouse_x > m_xlimit)
		{
			m_ind = -1;
		}
		for (var i = 0; i < array_length(r_folders); i ++)
		{
			if (m_ind = i)
			{
				draw_set_color(c_yellow);
			}
			draw_text(20, t_y + t_jy*i, r_folders[i]);
			draw_set_color(c_white);
		}
		draw_text(20, t_y - t_jy * 1.2, "Add a resource folder");
		if (btt(250, t_y - t_jy * 1.2, 0))
		{
			var name = get_string("Enter resource folder name", "");
			if (name != "")
			{
				if (ds_map_exists(sys.rsc, name))
				{
					show_message("Resource folder name already exists, choose another one");
					exit;
				}
				var code = code_generate();
				sys.rsc[? name] = code;
				var dir_name = "r_" + code + "_" + name;
				load_folders();
				directory_create(dir_name);
				directory_create(dir_name + "/sprites");
				directory_create(dir_name + "/bg");
				directory_create(dir_name + "/audio");
				with (sys)
				{
					save_rsc();
				}
			}
		}
		if (m_ind >= 0 and m_ind <= array_length(r_folders) - 1)
		{
			if (mouse_check_button_released(mb_left))
			{
				r_edit = m_ind;
				state = 1;
				load = true;
			}
		}
		if (btt(s_w - b_bord, b_bord, 3))
		{
			state = -1;
			sys.go_trans = true;
		}
	break;
	//resources list
	case (1):
		var dir_name = "r_" + sys.rsc[? r_folders[r_edit]] + "_" + r_folders[r_edit];
		
		if (load or sys.just_focus)
		{
			path_list(dir_name + "/audio", flist_au, ".ogg");
			path_list(dir_name + "/sprites", flist_sp, ".png");
			path_list(dir_name + "/bg", flist_bg, ".png");
			load = false;
		}
		
		var bord_x = 40;
		var jx = 300;
		var bord_y = 70;
		var jy = 30;
		var titlesep = jy * 1.2;
		
		draw_text(bord_x, bord_y - titlesep, "Audio");
		draw_text(bord_x + jx, bord_y - titlesep, "Sprites");
		draw_text(bord_x + 2*jx, bord_y - titlesep, "Backgrounds");
		
		for (var i = 0; i < ds_list_size(flist_au); i ++)
		{
			var fn = ds_list_find_value(flist_au, i);
			draw_text(bord_x, bord_y + i*jy, fn);
			
			if (btt(bord_x - 2, bord_y + i*jy, 1))
			{
				if (sure(fn))
				{
					file_delete(dir_name + "/audio/" + fn)
					path_list(dir_name + "/audio", flist_au, ".ogg");
				}
			}
		}
		for (var i = 0; i < ds_list_size(flist_sp); i ++)
		{
			var fn = ds_list_find_value(flist_sp, i);
			draw_text(bord_x + jx, bord_y + i*jy, fn);
			
			if (btt(bord_x + jx - 2, bord_y + i*jy, 1))
			{
				if (sure(fn))
				{
					file_delete(dir_name + "/sprites/" + fn)
					path_list(dir_name + "/sprites", flist_sp, ".png");
				}
			}
			if (btt(bord_x + jx - 2 - 20, bord_y + i*jy, 6))
			{
				recenter_spr = asset_load(dir_name, fn, 1);
				rec_name = fn;
				rec_xoff = sprite_get_xoffset(recenter_spr);
				rec_yoff = sprite_get_yoffset(recenter_spr);
				click_x = mouse_x;
				click_y = mouse_y;
				state = 1.5;
			}
		}
		for (var i = 0; i < ds_list_size(flist_bg); i ++)
		{
			var fn = ds_list_find_value(flist_bg, i);
			draw_text(bord_x + 2*jx, bord_y + i*jy, fn);
			if (btt(bord_x + 2*jx - 2, bord_y + i*jy, 1))
			{
				if (sure(fn))
				{
					file_delete(dir_name + "/bg/" + fn)
					path_list(dir_name + "/bg", flist_bg, ".png");
				}
			}
		}
		if (btt(bord_x - 2, bord_y - titlesep, 0))
		{
			var o = get_open_filename("ogg audio file|*.ogg", "");
			if (o != "")
			{
				file_copy(o, dir_name + "/audio/" + filename_name(o));
				path_list(dir_name + "/audio", flist_au, ".ogg");
			}
		}
		if (btt(bord_x + jx*2 - 2, bord_y - titlesep, 0))
		{
			var o = get_open_filename("png image|*.png", "");
			if (o != "")
			{
				file_copy(o, dir_name + "/bg/" + filename_name(o));
				path_list(dir_name + "/bg", flist_bg, ".png");
			}
		}
		if (btt(bord_x + jx - 2, bord_y - titlesep, 0))
		{
			state = 2;
			import_screen = 0;
		}
		
		if (btt(s_w - b_bord, b_bord, 3))
		{
			state = 0;
		}
	break;
	case (1.5):
		var dir_name = "r_" + sys.rsc[? r_folders[r_edit]] + "_" + r_folders[r_edit];
		var s = recenter_spr;
		var sc = 1;
		var sw = sprite_get_width(s);
		var sh = sprite_get_height(s);
		
		if (sw > room_width)
		{
			sc = room_width / sw;
		}
		if (sh > room_height)
		{
			sc = room_height / sh;
			//show_message("big");
		}
		sc -= 0.1;
		
		var sx = room_width / 2 + (sprite_get_xoffset(s) - sw / 2) * sc;
		var sy = room_height / 2 + (sprite_get_yoffset(s) - sh / 2) * sc;
		
		if (mouse_check_button(mb_left)) and (mouse_x == clamp(mouse_x, sys.s_w / 2 - sw / 2, sys.s_w / 2 + sw / 2))
		{
			rec_xoff += (mouse_x - click_x) / sc;
			rec_yoff += (mouse_y - click_y) / sc;
		}
		click_x = mouse_x;
		click_y = mouse_y;
		
		var cx = sys.s_w / 2 - (sw / 2) * sc + rec_xoff * sc;
		var cy = sys.s_h / 2 - (sh / 2) * sc + rec_yoff * sc;
		draw_sprite_ext(s, sys.time / 3, sx, sy, sc, sc, 0, c_white, 1);
		draw_sprite(spr_cross, 0, cx, cy);
		
		var btt_x = sys.s_w - 4;
		var btt_y = 2;
		var btt_jy = 24;
		
		draw_set_halign(fa_right);
		draw_text(btt_x - 30, btt_y, "Cancel");
		draw_text(btt_x - 30, btt_y + btt_jy, "Set");
		draw_set_halign(fa_left);
		if (btt(btt_x, btt_y, 3))
		{
			png_unload(dir_name + "/sprites/" + rec_name);
			state = 1;
		}
		if (btt(btt_x, btt_y + btt_jy, 2))
		{
			state = 1;
			ini_open(dir_name + "/sprites/" + rec_name + ".prop");
			ini_write_real("prop", "center", 2);
			ini_write_real("prop", "xoff", round(rec_xoff));
			ini_write_real("prop", "yoff", round(rec_yoff));
			ini_close();
			png_unload(dir_name + "/sprites/" + rec_name);
		}
	break;
	//importing sprites
	case (2):
		var dir_name = "r_" + sys.rsc[? r_folders[r_edit]] + "_" + r_folders[r_edit];
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		switch (import_screen)
		{
			//enemy o player
			case (0):
				import_p = (mouse_x > s_w / 2);
				if (mouse_y > s_h / 4 * 3) import_p = 2;
				
				draw_text(s_w / 2, 40, "Import sprite of what type?")
				draw_line(s_w / 2, 64, s_w / 2, s_h / 4 * 3);
				draw_set_font(fnt_list);
				
				if (import_p == 0) draw_set_color(c_yellow);
				draw_text(s_w / 4, s_h / 2, "enemy");
				draw_set_color(c_white);
				if (import_p == 1) draw_set_color(c_yellow);
				draw_text(s_w / 4 * 3, s_h / 2, "player");
				draw_set_color(c_white);
				if (import_p == 2) draw_set_color(c_yellow);
				draw_text(s_w / 2, s_h / 5 * 4 + 16, "bg element");
				draw_set_color(c_white);
				
				draw_set_font(fnt_def);
				
				if (mouse_check_button_released(mb_left))
				{
					import_screen = 1;
					if (import_p == 2)
					{
						import_screen = 2;
						import_type = 5;
					}
				}
			break;
			//sprite type
			case (1):
				draw_text(s_w / 2, 40, "What type of sprite");
				
				draw_set_font(fnt_list);
				var sy = 130;
				var jy = 85;
				
				var m_ind = floor((mouse_y - sy - jy/2) / jy) + 1;
				if (m_ind < 0 or m_ind >= 3 + (2*import_p)) m_ind = -1;
				
				if (m_ind != -1)
				{
					draw_set_alpha(0.25);
					draw_rectangle(0, sy + m_ind*jy - jy/2, 2000, sy + m_ind*jy + jy / 2, false);
					draw_set_alpha(1);
				}
				
				draw_text(s_w / 2, sy, "idle");
				draw_text(s_w / 2, sy + jy, "direction");
				draw_text(s_w / 2, sy + jy * 2, "icon");
				if (import_p)
				{
					draw_text(s_w / 2, sy + jy * 3, "miss");
					draw_text(s_w / 2, sy + jy * 4, "lose");
				}
				draw_set_font(fnt_def);
				
				if (mouse_check_button_released(mb_left))
				{
					import_type = m_ind;
					import_screen = 2;
				}
			break;
			//examples
			case (2):
				switch (import_type)
				{
					case (0):
						draw_text(s_w / 2, 50, "Animation which starts in a tense pose and transitions\nto a relaxed pose")
						draw_sprite(spr_ex_e_idle, import_p, s_w / 2, 235 - 50);
						draw_text(s_w / 2, s_h / 2 - 50, "Can also have equally spaced cycles");
						draw_sprite(spr_ex_idle_spk, 0, s_w / 2, s_h / 2 + 20 - 50);
					break;
					case (1):
						draw_text(s_w / 2, 50, "Animation which has 1 extrame frame emphasizing the direction and transitions\nto a less extreme pose")
						draw_sprite(spr_ex_dir, import_p, s_w / 2, 235 - 50);
						draw_text(s_w / 2, s_h / 2 - 50, "The extreme must be 1 frame but the transition can be any number");
						draw_sprite(spr_ex_dir_long, 0, s_w / 2, s_h / 2 + 20 - 50);
					break;
					case (2):
						draw_text(s_w / 2, 50, "Sprite that has 2 images: a normal face and a losing face.\nGets mirrored horizontally when assigned to the player.")
						draw_sprite(spr_ex_icon, import_p, s_w / 2, 235 - 50);
					break;
					case (3):
						draw_text(s_w / 2, 50, "Animation which has 1 extrame frame emphasizing the miss and transitions\nto a less extreme pose")
						draw_sprite(spr_ex_miss, 0, s_w / 2, 235 - 50);
						draw_text(s_w / 2, s_h / 2 - 50, "The extreme must be 1 frame but the transition can be any number");
					break;
					case (4):
						draw_text(s_w / 2, 50, "Animation which has an even number of frames, half of them have\nthe microphone falling (first frame on hand) and the other half have the microphone on the ground")
						draw_sprite(spr_ex_lose, 0, s_w / 2, 235 - 50);
					break;
					case (5):
						draw_text(s_w / 2, 50, "Still image or animation that goes to the beat.");
					break;
				}
				
				var m_xind = (mouse_x > s_w / 2);
				if (mouse_y < s_h - 140)
				{
					m_xind = 2;
				}
				if (mouse_y < s_h - 170)
				{
					m_xind = -1;
				}
				
				draw_set_font(fnt_list);
				if (m_xind == 0) draw_set_color(c_yellow);
				draw_text(s_w / 4, s_h - 80, "import\nstrip image");
				draw_set_color(c_white);
				if (m_xind == 1) draw_set_color(c_yellow);
				draw_text(s_w / 4 * 3, s_h - 80, "import\nindividual frames");
				draw_set_color(c_white);
				
				draw_set_font(fnt_info);
				if (m_xind == 2) draw_set_color(c_yellow);
				draw_text(s_w / 2, s_h - 150, "IMPORT .XML ATLAS");
				draw_set_color(c_white);
				draw_set_font(fnt_def);
				
				if (mouse_check_button_released(mb_left))
				{
					if (m_xind == 0)
					{
						var o = get_open_filename("horizontal strip image|*.png", "");
						if (o != "")
						{
							if (import_type == 2)
							{
								n = "2";
							}
							else
							{
								var n = get_string("Number of frames this strip has:", "");
							}
							if (n != "")
							{
								if (string_digits(n) != n)
								{
									show_message("Invalid frame number.");
								}
								else
								{
									var sname = dir_name + "/sprites/" + filename_name(o);
									file_copy(o, sname);
									sprop_save(sname, real(n), (import_type == 2 or import_type == 5));
									path_list(dir_name + "/sprites", flist_sp, ".png");
									state = 1;
								}
							}
						}
					}
					else if (m_xind == 1)
					{
						import_screen = 2.9;
					}
					else if (m_xind == 2)
					{
						var img_f = get_open_filename("image|*.png", "");
						if (!file_exists(img_f))
						{
							exit;
						}
						var xml_f = get_open_filename("xml atlas|*.xml", "");
						if (!file_exists(xml_f))
						{
							exit;
						}
						var sname = dir_name + "/sprites/";
						var done = convert_atlas(xml_f, img_f, sname);
						if (done != 0)
						{
							path_list(dir_name + "/sprites", flist_sp, ".png");
							state = 1;
						}
					}
				}
			break;
			case(2.9):
				ds_list_clear(strip);
				import_screen = 3;
				s_xsize = -1;
				s_ysize = 0;
			break;
			//individual frames
			case(3):
				var lsize = ds_list_size(strip);
				
				draw_set_color(c_gray);
				draw_rectangle(0, 0, 2000, 2000, false)
				draw_set_color(c_white);
				
				var opt_x = 60;
				var opt_y = 30;
				var opt_jx = 320;
				
				draw_set_halign(fa_left)
				draw_set_valign(fa_top)
				draw_text(opt_x, opt_y, "Cancel");
				draw_text(opt_x + opt_jx, opt_y, "Add a frame (press N)");
				draw_text(opt_x + opt_jx * 2, opt_y, "Done");
				draw_set_halign(fa_center)
				draw_set_valign(fa_center)
				
				if (btt(opt_x - 2, opt_y, 1))
				{
					for (var i = 0; i < lsize; i ++)
					{
						sprite_delete(strip[| i]);
					}
					ds_list_clear(strip);
					import_screen = 2;
					exit;
				}
				if (btt(opt_x - 2 + opt_jx, opt_y, 0) or keyboard_check_pressed(ord("N")))
				{
					var o = get_open_filename("png image|*.png", "");
					if (o != "")
					{
						var ns = sprite_add(o, 1, false, false, 0, 0)
						if (s_xsize != -1)
						{
							if (sprite_get_width(ns) != s_xsize or sprite_get_height(ns) != s_ysize)
							{
								show_message("Image not valid.\nAll individual images have to have the same dimensions.")
								sprite_delete(ns);
							}
						}
						else
						{
							s_xsize = sprite_get_width(ns);
							s_ysize = sprite_get_height(ns);
						}
						if (sprite_exists(ns))
						{
							ds_list_add(strip, ns);
						}
					}
				}
				var s = 1;
				if (lsize > 1)
				{
					s = 1 / lsize * 1.5;
				}
				for (var i = 0; i < lsize; i ++)
				{
					draw_sprite_ext(strip[| i], 0, 10 + s_xsize * s * i, 30, s, s, 0, c_white, 1)
				}
				if (btt(opt_x - 2 + opt_jx * 2, opt_y, 2))
				{
					var fname = get_string("Type a file name for the sprite (excluding the extension)", "");
					if (fname != "")
					{
						var sur = surface_create(s_xsize * lsize, s_ysize);
						surface_set_target(sur);
						for (var i = 0; i < lsize; i ++)
						{
							draw_sprite(strip[| i], 0, s_xsize * i, 0);
						}
						surface_reset_target();
						
						//saving strip with pits property file
						var sname = dir_name + "/sprites/" + fname + ".png";
						surface_save(sur, sname);
						sprop_save(sname, lsize, (import_type == 2 or import_type == 5));
						path_list(dir_name + "/sprites", flist_sp, ".png");
						
						surface_free(sur);
						for (var i = 0; i < lsize; i ++)
						{
							sprite_delete(strip[| i]);
						}
						ds_list_clear(strip);
						state = 1;
					}
				}
			break;
		}
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		if (import_screen != 3)
		{
			if (btt(s_w - b_bord, b_bord, 3))
			{
				state = 1;
			}
		}
	break;
	
	//songs
	case (10):
		var t_y = 80;
		var t_jy = 25;
		
		var m_xlimit = room_width - 100;
		var m_ind = floor((mouse_y - t_y) / t_jy);
		if (mouse_x > m_xlimit)
		{
			m_ind = -1;
		}
		for (var i = 0; i < array_length(r_charts); i ++)
		{
			if (r_charts[i] != -1)
			{
				if (m_ind = i and mouse_x < s_w / 2.5)
				{
					draw_set_color(c_yellow);
				}
				draw_text(30, t_y + t_jy*i, r_charts[i]);
				draw_set_color(c_white);
			
				if (!exporting)
				{
					if (btt(20, t_y + t_jy*i, 1))
					{
						if (sure(r_charts[i]))
						{
							var c_name = "c_" + sys.charts[? r_charts[m_ind]] + "_" + r_charts[m_ind];
							file_delete(c_name + ".ini");
							file_delete(c_name + ".txt");
							file_delete(c_name + ".exmap");
							ds_map_delete(sys.charts, r_charts[i]);
							cargar_charts();
							with (sys) save_charts();
						}
					}
				}
			}
			else
			{
				m_ind = -1;
			}
		}
		draw_text(30, t_y - t_jy * 1.2, "Create a new chart");
		if (btt(260, t_y - t_jy * 1.2, 0))
		{
			state = 11;
		}
		if (m_ind >= 0 and m_ind <= array_length(r_charts) - 1 and mouse_x < s_w / 2.5 and mouse_x > 30)
		{
			if (mouse_check_button_released(mb_left))
			{
				if (!exporting)
				{
					var c_name = "c_" + sys.charts[? r_charts[m_ind]] + "_" + r_charts[m_ind];
					sys.file_name = c_name;
					sys.level = 2;
					room_goto(rm_gogame);
					sys.editor = true;
				}
				else
				{
					var k = r_charts[m_ind];
					if (!ds_map_exists(export_list, k))
					{
						export_list[? k] = true;
					}
					else
					{
						ds_map_delete(export_list, k);
					}
				}
			}
		}
		
		var e_x = s_w / 2 - 20;
		var e_y = 20;
		
		//EXPORTING -----------------------------------------------
		if (exporting)
		{
			var tercio = s_w/3 * 2
			draw_text(tercio, 20, "Exporting:");
			var k = ds_map_find_first(export_list);
			for (var i = 0; i < ds_map_size(export_list); i++)
			{
				draw_text(tercio, 40 + 20*i, k);
				k = ds_map_find_next(export_list, k);
			}
			draw_text(e_x + 20, e_y, "Cancel");
		}
		else
		{
			draw_text(e_x + 20, e_y, "Export chart(s)");
		}
		if (ds_map_size(export_list) > 0)
		{
			draw_text(e_x + 20, e_y + 30, "Save .fnf file")
			if (btt(e_x, e_y + 30, 2))
			{
				show_message_async("Exporting, this might take a while.");
				cursor_pog(false);
				var z = zip_create(0);
				var k = ds_map_find_first(export_list);
				for (var i = 0; i < ds_map_size(export_list); i++)
				{
					var cname = "c_" + sys.charts[? k] + "_" + k;
					var iname = cname + ".ini";
					ini_open(iname)
					var resf = ini_read_string("details", "res_folder", "none");
					ini_close();
					
					zip_add_file(z, iname, iname);
					zip_add_file(z, cname + ".txt", cname + ".txt");
					if (file_exists(cname + ".exmap"))
					{
						zip_add_file(z, cname + ".exmap", cname + ".exmap");
					}
					cursor_pog(false);
					
					p_c[0] = resf + "/" + "audio" + "/";
					p_c[1] = resf + "/" + "sprites" + "/";
					p_c[2] = resf + "/" + "bg" + "/";
					
					for (var j = 0; j < 3; j ++)
					{
						var f = file_find_first(p_c[j] + "*", 0);
						while (f != "")
						{
							zip_add_file(z, p_c[j] + f, p_c[j] + f);
							var a = audio_play_sound(snd_beat, 1, false);
							audio_sound_gain(a, 0.4, 0);
							f = file_find_next();
							cursor_pog(false);
						}
						file_find_close();
					}
					
					k = ds_map_find_next(export_list, k);
				}
				cursor_pog(true);
				zip_save(z, get_save_filename("Funkin Fanworks mod package|*.fnf", "mymod"));
				zip_destroy(z);
			}
		}
		//--------------------------------------------------
		if (btt(e_x, e_y, 1 + 4*!exporting))
		{
			exporting ++;
			exporting %= 2;
		}
		if (btt(s_w - b_bord, b_bord, 3))
		{
			state = -1;
			sys.go_trans = true;
		}
	break;
	//creating a song
	case (11):
		var sx = 80;
		var sy = 80;
		var jy = 20;
		
		draw_text(sx, sy - jy*1.3, "Select the resource folder that the chart is gonna use:")
		var m_ind = floor((mouse_y - sy) / jy);
		if (m_ind > array_length(r_folders) - 1) m_ind = -1;
		for (var i = 0; i < array_length(r_folders); i ++)
		{
			if (m_ind == i) draw_set_color(c_yellow);
			draw_text(sx, sy + jy*i, r_folders[i]);
			draw_set_color(c_white);
		}
		if (mouse_check_button_released(mb_left) and m_ind != -1)
		{
			var name = get_string("Enter chart name", "");
			if (name != "")
			{
				var code = code_generate();
				if (ds_map_exists(sys.charts, name))
				{
					show_message("Chart name already exists, choose another one");
					exit;
				}
				sys.charts[? name] = code;
				var c_name = "c_" + code + "_" + name;
				cargar_charts();
				sys.file_name = c_name;
				
				var dir_name = "r_" + sys.rsc[? r_folders[m_ind]] + "_" + r_folders[m_ind];
				sys.set_res = dir_name;
				
				with (sys)
				{
					save_charts();
					level = 2;
					editor = true;
				}
				room_goto(rm_gogame);
			}
		}
	break;
}
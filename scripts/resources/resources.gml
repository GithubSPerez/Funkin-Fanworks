// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cursor_pog(GoBack)
{
	if (GoBack)
	{
		window_set_cursor(cr_default);
	}
	else
	{
		window_set_cursor(sys.cur[sys.cursor_load]);
		sys.cursor_load ++;
		sys.cursor_load %= 4;
	}
}
function load_rsc()
{
	var f = "rsc_map";
	if (file_exists(f))
	{
		var o = file_text_open_read(f);
		ds_map_read(rsc, file_text_read_string(o));
		file_text_close(o);
	}
}
function save_rsc()
{
	var f = "rsc_map";
	var o = file_text_open_write(f);
	file_text_write_string(o, ds_map_write(rsc))
	file_text_close(o);
}

function load_charts()
{
	var f = "charts_map";
	if (file_exists(f))
	{
		var o = file_text_open_read(f);
		ds_map_read(charts, file_text_read_string(o));
		file_text_close(o);
	}
}
function save_charts()
{
	var f = "charts_map";
	var o = file_text_open_write(f);
	file_text_write_string(o, ds_map_write(charts))
	file_text_close(o);
}
function sprop_save(Fname, Img_num, Center)
{
	ini_open(Fname + ".prop");
	ini_write_real("prop", "img", Img_num);
	ini_write_real("prop", "center", Center);
	ini_close();
}
function asset_load(Rfolder, Name, Type)
{
	Name = filename_name(Name);
	if (string_replace(Name, ".", "-") == Name)
	{
		return(asset_get_index(Name));
	}
	else
	{
		var prevs = Rfolder + "/";
		posts[0] = "audio";
		posts[1] = "sprites";
		posts[2] = "bg";
		
		var k = prevs + posts[Type] + "/" + Name;
		
		var ret = noone;
		
		if (file_exists(k))
		{
			if (!ds_map_exists(sys.assets, k))
			{
				cursor_pog(false);
				if (Type >= 1)
				{
					png_load(k, !(Type - 1));
				}
				else
				{
					sys.assets[? k] = audio_create_stream(k);
					sys.re_index[? string(sys.assets[? k])] = k;
					//show_message(k + " assigned to " + string(sys.assets[? k]));
				}
				cursor_pog(true);
			}
			ret = (sys.assets[? k]);
		}
		else
		{
			//show_message(k + " not found")
			if (Type >= 1)
			{
				ret = (spr_missing);
			}
			else
			{
				ret = (snd_miss1);
			}
		}
		return(ret);
	}
}

function png_load(Fname, Off)
{
	var num = 1;
	if (Off)
	{
		ini_open(Fname + ".prop");
		var num = ini_read_real("prop", "img", 2);
		var center = ini_read_real("prop", "center", false);
		var xoff = ini_read_real("prop", "xoff", -1);
		var yoff = ini_read_real("prop", "yoff", -1);
		ini_close();
	}
	
	var s = sprite_add(Fname, num, false, false, 0, 0);
	if (Off)
	{
		var w = sprite_get_width(s);
		var h = sprite_get_height(s);
		sprite_set_offset(s, w / 2, h);
		
		if (center == 1)
		{
			sprite_set_offset(s, w / 2, h / 2);
		}
		if (center == 2)
		{
			sprite_set_offset(s, xoff, yoff);
		}
	}
	sys.assets[? Fname] = s;
	sys.re_index[? sprite_get_name(sys.assets[? Fname])] = Fname;
	
	//show_message(sprite_get_name(sys.assets[? Fname]) + " assigned to " + Fname);
}
function png_unload(Fname)
{
	var s = sys.assets[? Fname];
	ds_map_delete(sys.re_index, sprite_get_name(s));
	ds_map_delete(sys.assets, Fname);
	sprite_delete(s);
}
function res_get_name(Asset, Type)
{
	var AssName = "";
	if (Type == 0)
	{
		var aun = audio_get_name(Asset);
		if (aun != "<undefined>")
		{
			AssName = aun;
		}
		else
		{
			AssName = string(Asset);
		}
	}
	else if (Type == 1) AssName = sprite_get_name(Asset);
	
	if (ds_map_exists(sys.re_index, AssName))
	{
		return(sys.re_index[? AssName])
	}
	else
	{
		return(AssName);
	}
}

function convert_atlas(File, ImgFile, SavePath)
{
	var succ = true;
	var f = file_text_open_read(File);
	
	var d = ds_map_create();
	var nmap = ds_map_create();
	while (!file_text_eof(f))
	{
		var txt = file_text_readln(f);
		if (string_replace(txt, "<SubTexture", "") != txt)
		{
			var npos = string_pos("name=", txt);
			var rfrom = string_copy(txt, npos + 6, string_length(txt) - (npos + 6));
			var a_fname = read_till(rfrom, "\"");
			var a_name = string_copy(a_fname, 1, string_length(a_fname) - 4);
			var fnum = real(string_replace(a_fname, a_name, ""));
			var frame = a_name + "," + string(fnum);
			
			if (!ds_map_exists(nmap, a_name))
			{
				nmap[? a_name] = 0;
			}
			else
			{
				if (fnum > nmap[? a_name])
				{
					nmap[? a_name] = fnum;
				}
			}
			
			dat[0] = "x";
			dat[1] = "y";
			dat[2] = "width";
			dat[3] = "height";
			dat[4] = "frameX";
			dat[5] = "frameY";
			dat[6] = "frameWidth";
			dat[7] = "frameHeight";
			
			for (var i = 0; i < 8; i ++)
			{
				var found = string_pos(dat[i] + "=", txt);
				var npos = found + string_length(dat[i] + "=\"");
				
				var rfrom = string_copy(txt, npos, string_length(txt) - (npos));
				if (found != 0)
				{
					var a_value = read_till(rfrom, "\"");
				}
				else
				{
					a_value = 0;
					if (dat[i] == "frameWidth") a_value = dmap_get(d, a_name, fnum, "width");
					else
					if (dat[i] == "frameHeight") a_value = dmap_get(d, a_name, fnum, "height");
				}
				//show_message(frame + "," + dat[i] + " = " + string(a_value));
				d[? frame + "," + dat[i]] = real(a_value);
			}
		}
	}
	
	file_text_close(f);
	
	var news = sprite_add(ImgFile, 1, false, false, 0, 0);
	sound_play(snd_beat);
	show_message("Image loaded");
	
	var anim_list = "";
	var ral = ds_list_create();
	var ind = ds_map_find_first(nmap)
	while (ind != undefined)
	{
		anim_list += string(ind) + "\n";
		ds_list_add(ral, string(ind));
		ind = ds_map_find_next(nmap, ind);
	}
	var toload = get_string("This file contains these animations:\n" + anim_list + "\nWhich one(s) do you want to import? (separate by commas, type \"ALL\" to import every one, you can skip some while importing)", "");
	if (toload == "")
	{
		succ = 0;
		return(succ);
	}
	var ilist = ds_list_create();
	if (toload != "ALL")
	{
		while (string_replace(toload, ",", "") != toload)
		{
			var newa = read_till(toload, ",");
			ds_list_add(ilist, newa);
			toload = string_replace(toload, newa + ",", "");
		}
		ds_list_add(ilist, toload);
	}
	else
	{
		ilist = ral;
	}
	
	var lsi = ds_list_size(ilist);
	succ = lsi;
	for (var j = 0; j < lsi; j ++)
	{
		ind = ilist[| j];
		if (!ds_map_exists(nmap, ind))
		{
			succ --;
			show_message("animation \"" + ind + "\" doesn't exist.");
		}
		else
		{
			var im_f = nmap[? ind] + 1;
			var ww = dmap_get(d, ind, 0, "frameWidth");
			var hh = dmap_get(d, ind, 0, "frameHeight");
			var rep = 1;
		
			#region para usar cuando implemente import xml
			var draws = noone;
			for (var i = 0; i < im_f; i ++)
			{
				var s = surface_create(ww, hh);
				surface_set_target(s);
			
				draw_sprite_part(news, 0, dmap_get(d, ind, i, "x"),
				dmap_get(d, ind, i, "y"),
				dmap_get(d, ind, i, "width"),
				dmap_get(d, ind, i, "height"),
				-dmap_get(d, ind, i, "frameX"),
				-dmap_get(d, ind, i, "frameY"));
			
				surface_reset_target();
				if (draws == noone)
				{
					draws = sprite_create_from_surface(s, 0, 0, ww, hh, false, false, 0, 0);
				}
				else
				{
					sprite_add_from_surface(draws, s, 0, 0, ww, hh, false, false);
				}
				surface_free(s);
			}
			succ = im_f;
			
			var sd = sound_play(snd_beat);
			audio_sound_pitch(sd, 0.5 + sqrt(2) * j / lsi)
			var sfile = get_string("Choose a file name for \"" + ind + "\" (excluding the extension)\nPress cancel to skip", "");
			
			if (sfile == "")
			{
				show_message("Animation not imported.");
			}
			else
			{
				sfile = SavePath + sfile;
				sprite_save_strip(draws, sfile + ".png");
				sprop_save(sfile + ".png", im_f, (import_type == 2 or import_type == 5));
			}
			sprite_delete(draws);
			#endregion
			#region no usar en caso de añadir xml support
			/*
			while (ww/rep * im_f > 16000)
			{
				show_message("animation " + ind + " is too big! separating into " + string(rep + 1) + " rows...")
				hh *= 2;
				rep ++;
			}
			var ysize = hh / rep;
			var s = surface_create(ww * ceil(im_f / rep), hh)
		
			surface_set_target(s);
			for (var i = 0; i < im_f; i ++)
			{
				var jx = 0//(ww * rep - dmap_get(d, ind, i, "width")) / 2;
				var jy = 0//(ysize - dmap_get(d, ind, i, "height")) / 2;
				draw_sprite_part(news, 0, dmap_get(d, ind, i, "x"),
				dmap_get(d, ind, i, "y"),
				dmap_get(d, ind, i, "width"),
				dmap_get(d, ind, i, "height"),
				jx + (i * ww)%(ww *ceil(im_f / rep)) - dmap_get(d, ind, i, "frameX"),
				jy + floor((hh * (i/im_f))/(ysize)) * ysize -dmap_get(d, ind, i, "frameY"))
			}
			surface_reset_target();
			surface_save(s, SavePath + CharName + "_" + ind + ".png");
			surface_free(s);
			*/
			#endregion
		}
	}
	ds_list_destroy(ilist);
	ds_list_destroy(ral);
	return(succ);
}
function dmap_get(Map, Anim, Frame, Att)
{
	return(Map[? Anim + "," + string(Frame) + "," + Att])
}
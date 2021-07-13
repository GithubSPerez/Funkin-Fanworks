// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function read_till(str, char)
{
	/*
	var sz = string_length(str);
	var cc = string_copy(str, 1, 1);
	for (var i = 1; i < sz - 1 and cc != char; i ++)
	{
		var cc = string_copy(str, i, 1);
	}
	*/
	return(string_copy(str, 1, string_pos(char, str) - 1));
}
function save_scores()
{
	with (sys)
	{
		var f = file_text_open_write("info");
		file_text_write_string(f, ds_map_write(scores));
		file_text_close(f);
	}
}
function load_scores()
{
	with (sys)
	{
		var fname = "info"
		if (file_exists(fname))
		{
			var f = file_text_open_read(fname);
			ds_map_read(scores, file_text_read_string(f));
			file_text_close(f);
		}
	}
}
function save_song(name){
	var f = file_text_open_write(name + ".txt");
	file_text_write_string(f, ds_map_write(notes));
	file_text_close(f);
	
	ini_open(name + ".exmap");
	ini_write_string("maps", "note_commands", ds_map_write(note_cmd));
	ini_write_string("lists", "bg_elements", ds_list_write(bg_elements));
	ini_write_string("maps", "bg_data", ds_map_write(bg_data));
	ini_close();
	
	ini_open(name + ".ini");
	var sec = "details";
	ini_write_string(sec, "name", song_name);
	ini_write_real(sec, "bpm", bpm);
	ini_write_real(sec, "track_off", track_off);
	ini_write_string(sec, "song", res_get_name(song, 0));
	ini_write_string(sec, "song_vc", res_get_name(song_vc, 0));
	ini_write_string(sec, "song_full", res_get_name(song_full, 0));
	ini_write_real(sec, "lvl_multi", lvl_multi);
	ini_write_string(sec, "author", author);
	ini_write_string(sec, "composer", composer);
	ini_write_real(sec, "stars", stars);
	ini_write_string(sec, "res_folder", res_folder);
	ini_write_real(sec, "menu_anim", menu_anim);
	ini_write_string(sec, "art", artist);
	
	var vsec = "visuals";
	for (var i = 0; i < vs_num; i ++)
	{
		ini_write_real(vsec, "real" + string(i), vdata[i]);
	}
	for (var i = 0; i < vst_num; i ++)
	{
		if (!is_array(vtdata[i]))
		{
			ini_write_string(vsec, "string" + string(i), vtdata[i]);
		}
		else
		{
			ini_key_delete(vsec, "string" + string(i));
			for (var j = 0; j < array_length(vtdata[i]); j ++)
			{
				ini_write_string(vsec, "string" + string(i) + "," + string(j), vtdata[i][j]);
			}
		}
	}
	ini_close();
}
function load_song(name)
{
	var fname = name + ".txt";
	notes = ds_map_create();
	note_cmd = ds_map_create();
	bg_data = ds_map_create();
	bg_elements = ds_list_create();
	if (file_exists(fname))
	{
		var f = file_text_open_read(fname);
		ds_map_read(notes, file_text_read_string(f));
		file_text_close(f);
		
		var ncn = name + ".exmap"
		ini_open(ncn);
		var map_read = ini_read_string("maps", "note_commands", "");
		var bg_list_read = ini_read_string("lists", "bg_elements", "");
		var bg_map_read = ini_read_string("maps", "bg_data", "");
		
		ini_close();
		if (map_read != "") ds_map_read(note_cmd, map_read);
		if (bg_list_read != "") ds_list_read(bg_elements, bg_list_read);
		if (bg_map_read != "") ds_map_read(bg_data, bg_map_read);
		
		var ns = ds_map_size(notes);
		var key = "";
		for (var i = 0; i < ns; i ++)
		{
			if (i == 0)
			{
				key = ds_map_find_first(notes);
			}
			else
			{
				key = ds_map_find_next(notes, key);
			}
			var nkey = key;
			var dir = read_till(nkey, ",");
			nkey = string_replace(nkey, dir + ",", "");
			var acm = read_till(nkey, ",");
			nkey = string_replace(nkey, acm + ",", "");
			
			var pos = nkey;
			var command = "";
			
			if (real(dir) == 10 or real(dir) == 11)
			{
				if (ds_map_exists(note_cmd, key))
				{
					command = note_cmd[? key];
				}
				else
				{
					command = "cam_pos=2";
					if (real(dir) == 11)
					{
						command = "cam_pos=3";
					}
				}
			}
			
			var ins = instance_create_depth(0, 0, -5, obj_marker);
			ins.dir = real(dir);
			ins.actmode = real(acm);
			ins.track_pos = real(pos);
			ins.command = command;
			notes[? key] = ins;
		}
	}
	ini_open(name + ".ini");
	var sec = "details";
	
	res_folder = ini_read_string(sec, "res_folder", "");
	
	song_name = ini_read_string(sec, "name", song_name);
	bpm = ini_read_real(sec, "bpm", bpm);
	track_off = ini_read_real(sec, "track_off", track_off);
	song = asset_load(res_folder, ini_read_string(sec, "song", audio_get_name(song)), 0);
	song_vc = asset_load(res_folder, ini_read_string(sec, "song_vc", audio_get_name(song_vc)), 0);
	song_full = asset_load(res_folder, ini_read_string(sec, "song_full", audio_get_name(song_full)), 0);
	lvl_multi = ini_read_real(sec, "lvl_multi", lvl_multi);
	author = ini_read_string(sec, "author", "someone");
	composer = ini_read_string(sec, "composer", "someone");
	stars = ini_read_real(sec, "stars", 3);
	menu_anim = ini_read_real(sec, "menu_anim", 0.22);
	artist = ini_read_string(sec, "art", "");
	
	var vsec = "visuals";
	for (var i = 0; i < vs_num; i ++)
	{
		load_song_real(i);
	}
	for (var i = 0; i < vst_num; i ++)
	{
		load_song_string(i);
	}
	ini_close();
	
	//background elements
	instance_destroy(obj_bg_element);
	var ls = ds_list_size(bg_elements);
	for (var i = 0; i < ls; i ++)
	{
		var ins = instance_create_depth(0, 0, 0, obj_bg_element);
		ins.e_id = bg_elements[| i];
	}
}
function load_song_real(i)
{
	var vsec = "visuals";
	vdata[i] = ini_read_real(vsec, "real" + string(i), vdata[i]);
}
function load_song_string(i)
{
	var vsec = "visuals";
	var skey = "string" + string(i);
	if (!ini_key_exists(vsec, skey))
	{
		var j = 0;
		skey = "string" + string(i) + "," + string(j);
		while (ini_key_exists(vsec, skey))
		{
			vtdata[i][j] = ini_read_string(vsec, skey, "spr_missing");
			j ++;
			skey = "string" + string(i) + "," + string(j);
		}
	}
	else
	{
		vtdata[i][0] = ini_read_string(vsec, skey, vtdata[i][0]);
	}
}

function songs_get()
{
	with (sys)
	{
		var cur_song = file_find_first("*.ini", 0);
		ds_map_destroy(song_list);
		song_list = ds_map_create();
		ds_list_destroy(song_name)
		song_name = ds_list_create();
		songs = 0;
		var i = 0;
		while true
		{
			var fname = string_replace(cur_song, ".ini", "");
			if (fname != "options")
			{
				ini_open(cur_song);
				var name = string_lower(ini_read_string("details", "name", "song " + string(i)));
				var diff = ini_read_real("details", "stars", 3);
				var res = ini_read_string("details", "res_folder", "");
				
				var skip = false;
				if (sys.banana && name == "ugh") skip = true;
				
				if (skip)
				{
					ini_close();
				}
				else
				{
					ds_list_add(song_name, name + ":" + fname);
					song_list[? fname + ":name"] = name;
				
					var p_key = "string" + string(vst.p_idle);
					if (!ini_key_exists("visuals", p_key)) p_key = "string" + string(vst.p_idle) + "," + "0";
					var p_spr = ini_read_string("visuals", p_key, "spr_bf_idle");
				
					var en_key = "string" + string(vst.en_idle);
					if (!ini_key_exists("visuals", en_key)) en_key = "string" + string(vst.en_idle) + "," + "0";
					var en_spr = ini_read_string("visuals", en_key, "spr_testchar");
				
					ini_close();
				
					if (p_spr != "custom")
					{
						song_list[? fname + ":p_spr"] = asset_load(res, p_spr, 1);
					}
				
					if (en_spr != "custom")
					{
						song_list[? fname + ":en_spr"] = asset_load(res, en_spr, 1);
					}
				
					ini_open(cur_song);
					var ms = ini_read_string("details", "song", "mus_menu");
					ini_close();
				
					if (ms != "custom")
					{
						song_list[? fname + ":audio"] = asset_load(res, ms, 0);
					}
					ini_open(cur_song);
					song_list[? fname + ":author"] = ini_read_string("details", "author", "someone");
					song_list[? fname + ":composer"] = ini_read_string("details", "composer", "someone");
					song_list[? fname + ":stars"] = diff;
					song_list[? fname + ":anim"] = ini_read_real("details", "menu_anim", 0.22);
					song_list[? fname + ":art"] = ini_read_string("details", "art", "");
					ini_close();
					songs ++;
				}
			}
			cur_song = file_find_next();
			if (cur_song == "")
			{
				break;
			}
		}
		ds_list_sort(song_name, true);
		for (var i = 0; i < songs; i ++)
		{
			var str = ds_list_find_value(song_name, i)
			var f = string_replace(str, read_till(str, ":") + ":", "");
			if (f == file_name)
			{
				song_n = i;
			}
			song_file[i] = f;
		}
		file_find_close();
		//show_message(song_list);
	}
}
function songs_extract()
{
	var dir = program_directory + "/";
	file = file_find_first(dir + "*.fnf", 0);
	while (file_exists(file))
	{
		zip_unzip(file, working_directory);
		file = file_find_next();
	}
	file_find_close();
	
	dir = program_directory + "/Mods/";
	file = file_find_first(dir + "*.fnf", 0);
	while (file_exists(dir + file))
	{
		zip_unzip(dir + file, working_directory);
		file = file_find_next();
	}
	file_find_close();
	
	if (!file_exists("spookeez.ini"))
	{
		show_message("The file Main_charts.fnf that should be in the same folder as the executable is missing or corrupted. Try to extract/download the game again.")
	}
}
function song_read_bge(Name)
{
	var ncn = Name + ".exmap"
	ini_open(ncn);
	var bg_list_read = ini_read_string("lists", "bg_elements", "");
	var bg_map_read = ini_read_string("maps", "bg_data", "");
		
	ini_close();
	if (bg_list_read != "") ds_list_read(bg_elements, bg_list_read);
	if (bg_map_read != "") ds_map_read(bg_data, bg_map_read);
}
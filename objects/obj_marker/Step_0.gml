var m = obj_music;
time ++;

image_blend = c_white;
if (selected) image_blend = merge_color(c_aqua, c_blue, 0.5);

xdif = abs(x - lx);
lx = x;
var j = (m.lvl_start + m.level * m.lvl_add) * m.lvl_multi;
var preadd = 0;

if (m.pregame > 0)
{
	preadd = m.pregame;
}
frame_add = m.ex_add_f * (dir <= 3);
x = (track_pos - global.track_pos + preadd + frame_add) * j / (m.bpm / 150);
y = dir * 16;
image_index = dir;
if (actmode >= 1)
{
	image_yscale = 0.4;
	if (actmode == 2)
	{
		image_xscale = 0.4;
	}
}

#region difficulty adjust
if (state == 0)
{
	out = false;
}
if (dir <= 7 and m.level <= 1)
{
	if (actmode == 0)
	{
		if (time < 5 and m.level <= 1)
		{
			state = 0;
			out = false;
			if (track_pos % 30 >= 15)
			{
				var postkey = "," + "0" + "," + string(track_pos + 45)
				var diss = false;
				var ji = 0;
				if (dir >= 4) ji = 4;
				for (var i = 0; i < 4; i ++)
				{
					var ikey = string(i + ji) + postkey;
					if (ds_map_exists(m.notes, ikey))
					{
						if (!m.notes[? ikey].out)
						{
							diss = true;
							break;
						}
					}
				}
				if (diss)
				{
					state = 1;
					out = true;
				}
			}
			if (m.level == 0)
			{
				if (track_pos % 60 > 15)
				{
					state = 1;
					out = true;
				}
			}
		}
	}
	else
	{
		var jx = 0;
		var maxx = 240;
		if (time < 5)
		{
			var rep = true;
			while (rep)
			{
				var ins = collision_circle(x - jx + 8, y + 8, 7, obj_marker, true, false);
				rep = false;
				if (ins == noone) rep = true;
				else if (ins.actmode != 0)
				{
					rep = true;
					maxx += 240;
				}
				if (rep) jx += 8;
				if (jx > maxx) break;
			}
			par = ins;
		}
		if (instance_exists(par))
		{
			if (par.out)
			{
				state = 1;
				out = true;
			}
		}
	}
}
#endregion

if (x <= 4 and lx > 4)
{
	if (dir > 3 and dir <= 7 and !m.editing and !out)
	{
		with (obj_char)
		{
			if (side == -1)
			{
				dir = other.dir - 4;
				event_user(0);
			}
		}
	}
}
if (x <= 0 and lx > 0)
{
	if (dir <= 3)
	{
		if (m.editing)
		{
			audio_stop_sound(snd_beat);
			var s = audio_play_sound(snd_beat, 2, false);
			audio_sound_pitch(s, 1.4);
			if (actmode >= 1)
			{
				audio_sound_gain(s, 0.4, 0);
			}
		}
		else
		{
			if (actmode == 2)
			{
				state = 1;
			}
			if (state == 0)
			{
				m.vc_vol = 0;
			}
		}
	}
	else if (dir <= 7)
	{
		if (m.editing or sys.sound_mark)
		{
			audio_stop_sound(snd_beat);
			var s = audio_play_sound(snd_beat, 2, false);
			audio_sound_pitch(s, 1.2);
			if (actmode >= 1)
			{
				audio_sound_gain(s, 0.4, 0);
			}
		}
		state = 1;
		m.vc_vol = 1;
	}
	else if (dir <= 14)
	{
		if (dir != 10 and dir != 11)
		{
			with (obj_cam)
			{
				cam_at = other.dir - 8;
			}
		}
		else
		{
			command_execute(command)
		}
		//audio_stop_sound(s);
	}
	else
	{
		obj_music.won = true;
		var s = sound_play(snd_win);
		audio_sound_gain(snd_win, 1, 0);
		if (obj_music.silence)
		{
			audio_sound_gain(s, 0, 0);
		}
		obj_game.points = floor(obj_game.points);
		sys.white = sys.maxw;
		obj_cam.cam_at = 4;
	}
	
	if (sys.mod_bot)
	{
		if (dir >= 0 and dir <= 3)
		{
			var pr = 1;
			if (actmode != 0) pr = 0;
			obj_game.check[dir][pr] = true;
		}
	}
}
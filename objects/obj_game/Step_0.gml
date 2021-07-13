function miss_snd_play()
{
	if (combo > 0)
	{
		if (combo >= 10)
		{
			var ps = miss_snd[irandom_range(0, 2)]
			audio_stop_sound(ps);
			var s = audio_play_sound(ps, 1, false);
			audio_sound_gain(s, 0.6, 0);
		}
		combo = 0;
	}
}
var m = obj_music;
active = !m.editing;
if (!active)
{
	exit;
}
if (m.won or m.pause)
{
	exit;
}
if (lost)
{
	lost_time ++;
	if (lost_time == 120)
	{
		audio_play_sound(mus_lost, 1, true);
		obj_music.lost_menu = true;
	}
	if (lost_time >= 120 and !retried)
	{
		if (key("back"))
		{
			sys.go_trans = true;
			sys.goto = rm_menu;
			audio_stop_sound(mus_lost);
		}
		if (key("start") and !sys.go_trans)
		{
			audio_stop_all();
			sound_play(snd_retry);
			audio_sound_gain(snd_retry, 1, 0);
			retried = true;
			sys.white = sys.maxw;
			sys.goto = rm_gogame;
			lost_time = 121;
			exit;
		}
	}
	if (retried and sys.go_trans == false and (lost_time == 240 or key_press("start")))
	{
		sys.go_trans = true;
		audio_sound_gain(snd_retry, 0, 500);
	}
	exit;
}
function check_get(i, k)
{
	check[i][0] = key(k);
	check[i][1] = key_press(k);
	check[i][2] = key_release(k);
}
if (!sys.mod_bot)
{
	if (!sys.cus_keys)
	{
		check_get(0, "left");
		check_get(1, "down");
		check_get(2, "up");
		check_get(3, "right");
	}
	else
	{
		check_get(0, "a");
		check_get(1, "b");
		check_get(2, "c");
		check_get(3, "d");
	}
}

var r = 20;
var perf = 8;
var hp_add = 1;
var hp_hold = 0.4;
var hp_lose = 2;
pt_add = 350;
pt_hold = 10;
var pt_lose = 10;

if (sys.mod_safe == 1)
{
	hp_lose = 0.5;
}

//check if key being pressed
for (var i = 0; i < 4; i ++)
{
	var miss = true; //if this stays on true then it'll be a miss
	if (check[i][1] or check[i][0]) //if either pressed or held
	{
		var l = ds_list_create();
		var mks = collision_rectangle_list(-r, 0, r, 700, obj_marker, true, true, l, true); //check for touching markers
		var exec = check[i][1];
		
		for (var j = 0; j < mks; j ++)
		{
			var ins = ds_list_find_value(l, j);
			if (ins.state == 0)
			{
				if (ins.dir = i)
				{
					if ((ins.actmode == 0 and check[i][1]) or (ins.actmode == 1 and ins.x <= 1 and check[i][0])) //depending on if want to press or held, go on
					{
						exec = true;
						miss = false;
						ins.state = 1;
						if (sys.sound_mark)
						{
							audio_stop_sound(snd_beat);
							var s = audio_play_sound(snd_beat, 2, false);
							audio_sound_pitch(s, 1.4);
							if (ins.actmode >= 1)
							{
								audio_sound_gain(s, 0.4, 0);
							}
						}
						if (ins.actmode == 0)
						{
							combo ++;
							hp += hp_add;
							var p_multi = 1;
							var a_multi = 1;
							m.stat = m.maxstat;
							m.stat_type = 0;
							
							m.splash[ins.dir] = m.max_splash;
							m.perf[ins.dir] = true;
							if (ins.x > perf or ins.x < -perf)
							{
								m.perf[ins.dir] = false;
								var maxdis = r + 8 - perf;
								p_multi = 1 - ((abs(ins.x) - perf) / maxdis) * 0.5;
								a_multi = 1 - ((abs(ins.x) - perf) / maxdis) * 0.15;
								//show_message_async(p_multi)
								if (sys.mod_perfect == 2)
								{
									hp = 0;
								}
							}
							if (p_multi < 0.92)
							{
								m.stat_type = 1;
								if (p_multi < 0.85)
								{
									m.stat_type = 2;
									if (p_multi < 0.75)
									{
										m.stat_type = 3;
									}
								}
							}
							points += pt_add * p_multi;
							accuracy += 100 * a_multi;
						}
						else
						{
							hp += hp_hold;
							points += pt_hold;
							accuracy += 100;
						}
						notes_passed ++;
						m.vc_vol = 1;
						break;
					}
				}
			}
		}
		ds_list_destroy(l);
		if (exec)
		{
			obj_music.pulse[i] = obj_music.max_pulse * (1 - miss * 2);
			if (miss)
			{
				hp -= hp_lose * 0.8;
				points -= pt_lose;
				dir = 4;
				miss_snd_play();
				accuracy += 0.9 * percent;
				notes_passed ++;
				if (sys.mod_perfect > 0)
				{
					hp = 0;
				}
				misses ++;
			}
			else
			{
				dir = i;
			}
			with (obj_char)
			{
				if (side == 1)
				{
					dir = other.dir;
					event_user(0);
				}
			}
		}
	}
	var missline = -r * 3;
	var passed = collision_line(missline, 0, missline, 700, obj_marker, true, true);
	if (passed != noone)
	{
		if (passed.dir <= 3 and passed.state == 0)
		{
			passed.state = 1;
			hp -= hp_lose;
			miss_snd_play();
			misses ++;
			notes_passed ++;
			combo = 0;
			if (sys.mod_perfect > 0)
			{
				hp = 0;
			}
		}
	}
}
hp = clamp(hp, 0, maxhp);
if (sys.mod_safe == 2)
{
	hp = clamp(hp, 1, maxhp);
}

//count accuracy
if (notes_passed > 0)
{
	percent = accuracy / notes_passed;
}
if (tot_notes != instance_number(obj_marker))
{
	tot_points = 0;
	with (obj_marker)
	{
		if (dir <= 3)
		{
			if (actmode == 0)
			{
				other.tot_points += other.pt_add;
			}
			else if (actmode <= 2)
			{
				other.tot_points += other.pt_hold;
			}
		}
	}
	tot_notes = instance_number(obj_marker);
}

if (hp = 0 and !lost)
{
	lost = true;
	audio_play_sound(snd_lost, 1, false);
	with (obj_char)
	{
		if (side == 1)
		{
			anim = an.lost;
		}
		else
		{
			anim = an.invis
		}
	}
}

if (sys.mod_bot)
{
	for (var i = 0; i < 4; i ++)
	{
		check[i][0] = false;
		check[i][1] = false;
		check[i][2] = false;
	}
}
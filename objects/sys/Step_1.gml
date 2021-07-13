time ++;
input_get();

ww = window_get_width();
wh = window_get_height();

just_focus = false;
if (window_has_focus() and !lfoc)
{
	just_focus = true;
}
lfoc = window_has_focus();

if (!window_get_fullscreen())
{
	if (ww != l_ww or wh != l_wh)
	{
		/*
		var multi = ww / s_w;
	
		if (abs(wh - l_wh) > abs(ww - l_ww))
		{
			multi = wh / s_h;
		}
		ww = round(s_w * multi);
		wh = round(s_h * multi);
		window_set_size(ww, wh);
		*/
	}
	
	if (keyboard_check_pressed(vk_f4))
	{
		window_set_fullscreen(true);
	}
}
else
{
	if (keyboard_check_pressed(vk_f4))
	{
		window_set_fullscreen(false);
	}
}

l_ww = ww;
l_wh = wh;

valid_score = !mod_bot and (mod_speed >= 1) and mod_safe == 0;

if (room != rm_game)
{
	if (surface_exists(global.ars))
	{
		surface_free(global.ars);
	}
}
var v_change = (keyboard_check_pressed(vk_add) - keyboard_check_pressed(vk_subtract));
if (v_change != 0)
{
	volume += v_change * 0.1;
	vol_a = 3;
	volume = clamp(volume, 0, 1);
	volume = round(volume * 10) / 10;
	opt_save();
}
audio_master_gain(volume);
var draw_fps = true;
if (instance_exists(obj_music))
{
	if (obj_music.editing) draw_fps = false;
}
if (draw_fps)
{
	draw_text(4, 8, "FPS " + string(show_fps));
}
if (time % 5 == 0)
{
	show_fps = round(60 / adv);
}

if (white > 0)
{
	draw_set_alpha(white / maxw);
	draw_rectangle(0, 0, 2000, 2000, false)
	draw_set_alpha(1);
	white --;
}

if (go_trans == 1)
{
	go_trans = -1;
	transition_y = - s_h * 2;
}
on_trans = false;
if (transition_y < s_h * 2)
{
	transition_y += 30;
	if (transition_y > 0 and go_trans == -1)
	{
		go_trans = false;
		transition_y = 0;
		if (goto != noone)
		{
			room_goto(goto);
		}
		on_trans = true;
		goto = noone;
	}
	draw_set_color(c_black);
	draw_rectangle(0, transition_y, 2000, transition_y + s_h, false)
	draw_sprite(spr_gradient, 0, 0, transition_y + s_h);
	draw_sprite_ext(spr_gradient, 0, 0, transition_y, 1, -1, 0, c_black, 1);
	draw_set_color(c_white);
}

if (!debug) exit;

if (keyboard_check(vk_control) and keyboard_check(vk_shift))
{
	var xx = window_mouse_get_x();
	var yy = window_mouse_get_y();
	draw_line(0, yy, 2000, yy);
	draw_line(xx, 0, xx, 2000);
	clipboard_set_text(string(xx) + "," + string(yy));
}

draw_set_halign(fa_center);
draw_set_color(c_black);
draw_set_alpha(0.75 * vol_a)
var square_w = 30;
var square_h = 20;
draw_rectangle(s_w / 2 - square_w, 0, s_w / 2 + square_w, square_h, false);
draw_set_alpha(vol_a)
draw_set_color(c_white);
draw_text(s_w / 2, 2, string(volume * 100) + "%");
draw_set_alpha(1);
draw_set_halign(fa_left);

if (vol_a > 0) vol_a -= 0.05;

switch (up_state)
{
	case (0):
		up_s = 1.5;
		up_x = s_w / 2;
		up_y = s_h / 2;
		up_state = 1;
		up_timer = 90;
		sound_play(snd_update);
	break;
	case (1):
		up_s += (1 - up_s) / 10;
		up_timer --;
		if (up_timer == 0)
		{
			up_state = 2;
		}
	break;
	case (2):
		var tox = s_w - 210;
		var toy = s_h - 30;
		up_x += (tox - up_x) / 8;
		up_y += (toy - up_y) / 8;
		up_s += (0.5 - up_s) / 8;
		if (up_a > 0.4) up_a -= 0.05;
	break;
}
if (up_state != -1 and room != rm_game)
{
	draw_sprite_ext(spr_update, 0, up_x, up_y, up_s, up_s, 0, c_white, up_a);
}
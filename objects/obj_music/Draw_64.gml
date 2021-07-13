if (editing)
{
	exit;
}
if (obj_game.hp == 0)
{
	if (lost_menu)
	{
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_set_font(fnt_menu);
		draw_opt(sys.s_w / 2, 103, "retry?", c_black, c_white, 0.5 * !obj_game.retried);
		draw_set_font(fnt_def);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	exit;
}
ar_jx = 108;
as = 0.68;
a_x = 80;
a_y = 95;
a_rsx = sys.s_w - a_x - ar_jx * 3;
a_multi = (6 * lvl_spd[level] * lvl_multi) / (bpm / 150);

if (!surface_exists(ars))
{
	global.ars = surface_create(sys.s_w, sys.s_h);
	ars = global.ars;
}
surface_set_target(ars);
draw_clear_alpha(c_black, 0);
xd[0,0] = 1;
xd[1,0] = sys.scroll_dir;
xd[2,0] = sys.scroll_dir;
xd[3,0] = 1;
xd[0,1] = sys.scroll_dir;
xd[1,1] = 1;
xd[2,1] = 1;
xd[3,1] = sys.scroll_dir;


arrow_flow += (ar_to_f - arrow_flow) / 8;
ar_ang = global.track_pos/60 * 90 * arrow_fx_spd;
jx = dcos(ar_ang) * arrow_flow;

//enemy arrows
for(var i = 0; i < 4; i ++)
{
	draw_sprite_ext(spr_arrow_bg, 2, a_x + i * ar_jx, a_y, as * xd[i,0], as * xd[i,1], aang[i], c_white, 1);
}
//player arrows
for(var i = 0; i < 4; i ++)
{
	
	//pulse[i] -= sign(pulse[i]);
	pulse[i] += (0 - pulse[i]) / 3;
	if (pulse[i] <= 1 && sign(pulse[i]) >= 1) pulse[i] = 0;
	var ca_img = 2 - (clamp(pulse[i], 0, max_pulse) / max_pulse) * 2
	var ca_exs = 1 + (pulse[i] / max_pulse) * 0.5;
	var ca_col = merge_color(c_white, acol[i], abs(pulse[i]) / max_pulse);
	draw_sprite_ext(spr_arrow_bg, ca_img, a_rsx + i * ar_jx, a_y, as * ca_exs * xd[i,0], as * ca_exs * xd[i,1], aang[i], ca_col, 1);
}
if (!sys.banana)
{
	for (var i = 0; i < 4; i ++)
	{
		if (splash[i] >= 0 and perf[i])
		{
			splash[i] -= sign(splash[i]);
			var sp_img = 4 - (splash[i] / max_splash * 4);
		
			var splash_s = as + 0.15;
			draw_sprite_ext(spr_note_splash, sp_img, a_rsx + i * ar_jx, a_y, splash_s, splash_s, 0, acol[i], 1);
			draw_sprite_ext(spr_splash_white, sp_img, a_rsx + i * ar_jx, a_y, splash_s, splash_s, 0, c_white, 1);
		}
	}
}

//accuracy notices and combo counter
if (stat > 0)
{
	var nt_left = (maxstat - stat)
	var nt_s = (1 - (nt_left / maxstat) * 0.4) * 0.75;
	var nt_a = 1.5 - (nt_left / maxstat) * 1.5;
	var nt_x = a_rsx - 180;
	draw_sprite_ext(spr_acc, stat_type, nt_x, a_y, nt_s, nt_s * sys.scroll_dir, 0, c_white, nt_a);
	
	var g = obj_game;
	if (g.combo == 0 or g.combo >= 10)
	{
		draw_set_font(fnt_combo);
		draw_set_alpha(nt_a);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_text_transformed(nt_x, a_y + 100, string(g.combo), nt_s * 0.75, nt_s * 0.75 * sys.scroll_dir, 0);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_def);
		draw_set_alpha(1);
	}
	stat --;
}
with (obj_marker)
{
	if (x > -200 and x < sys.s_w)
	{
		var is_cmd = (dir == 10 or dir == 11);
		if (dir <= 7 or is_cmd)
		{
			var a = dir - 4;
			var sx = other.a_x;
			if (dir <= 3)
			{
				sx = other.a_rsx;
				a = dir;
			}
			if (state == 0)
			{
				var sp = spr_arrow;
				var ys = 1;
				var ydir = sys.scroll_dir;
				var op = 1;
				var img = 0;
				var jy = 0;
				if (actmode >= 1)
				{
					sp = spr_arrow_long;
					ys = 3.2 * other.a_multi / 5.5;
					op = 0.75;
					ydir = 1;
					if (actmode == 2)
					{
						jy = (ys / 2) * 22;
						ys = 1;
						img = 4;
					}
				}
				if (sys.mod_inv == 1)
				{
					var mul = other.lvl_spd[other.level]
					op *= (x - 50 * mul) / (80 * mul);
				}
				else if (sys.mod_inv == 2)
				{
					op = 0;
				}
				var ydel = (sys.mod_vdelay / 1000 * other.bpm * other.lvl_spd[other.level] * other.lvl_multi) * (dir <= 3);
				var dy = round(other.a_y + (track_pos - global.track_pos + other.pregame + frame_add / other.a_multi + ydel) * other.a_multi  - jy)
				if (is_cmd)
				{
					op = 0;
					if (command_get_func(command) = "fire_arrows")
					{
						sp = spr_fire_up;
						ydir = 1;
						sx = other.a_x;
						for (var ii = 0; ii < 4; ii ++)
						{
							draw_sprite_ext(sp, time / 2, sx + ii * other.ar_jx, round(other.a_y + (track_pos - global.track_pos + other.pregame) * other.a_multi - jy), other.as, other.as * ys * ydir, 0, c_white, 1);
						}
					}
				}
				draw_sprite_ext(sp, a + img, sx + a * other.ar_jx + dsin((other.a_y - dy) / 3) * other.jx, dy, other.as, other.as * ys * ydir, 0, c_white, op);
			}
		}
	}
}
surface_reset_target();

var c = obj_cam;
var s_w = sys.s_w;
var s_h = sys.s_h;
var sw = s_w + (s_w * vdata[vs.cam_s] - c.cam_w);
var sh = s_h + (s_h * vdata[vs.cam_s] - c.cam_h);
var ss = sw / s_w;
draw_surface_ext(ars, jx + s_w / 2 - sw / 2, s_h / 2 - (sh / 2) * sys.scroll_dir, ss, ss * sys.scroll_dir, 0, c_white, 1);

if (pregame > 0)
{
	var gi = 0;
	var gs = 1 - ((max_pregame - pregame) / pregame) * 0.08;
	var ga = 1;
	if (pregame <= max_go)
	{
		gi = 1;
		gs = 1 + (max_go - pregame) / max_go;
		ga = 2 - ((max_go - pregame) / max_go) * 2;
	}
	draw_sprite_ext(spr_ready, gi, sys.s_w / 2, sys.s_h / 2, gs * 0.75, gs * 0.75, 0, c_white, ga);
}

if (pause and !editing)
{
	draw_set_color(c_black);
	draw_set_alpha(0.4);
	draw_rectangle(0, 0, 2000, 2000, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	var opx = sys.s_w / 2;
	opy[0] = -sys.s_h / 4;
	opy[1] = 0;
	opy[2] = sys.s_h / 4;
	
	ptx[0] = "continue";
	ptx[1] = "retry";
	ptx[2] = "exit";
	draw_set_font(fnt_menu);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	for (var i = 0; i < 3; i ++)
	{
		var col1 = c_white;
		var col2 = c_black;
		var shk = 0.7;
		if (i != pause_opt)
		{
			col1 = c_black;
			col2 = c_white;
			shk = 0;
		}
		if (popt_selected > 0)
		{
			draw_set_alpha(0.5);
			if (i == pause_opt)
			{
				draw_set_alpha(floor(popt_selected / 6) % 2);
			}
		}
		draw_opt(opx, sys.s_h / 2 + opy[i]*popt_multi, ptx[i], col1, col2, shk);
		draw_set_alpha(1);
	}
	draw_set_font(fnt_def);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
if (won)
{
	var accx = sys.s_w / 4;
	var accy = sys.s_h / 2;
	var defy = 296;
	var exy = 421;
	var scx = sys.s_w / 4 * 3;
	
	var s_val = obj_game.points;
	var p_val = obj_game.percent;
	var s_ext = "";
	var p_ext = "";
	if (highs) s_ext = "highscore!";
	if (highp) p_ext = "new record!";
	if (p_val == 100) p_ext = "perfect!";
	
	draw_set_color(c_black);
	draw_set_alpha(0.4);
	draw_rectangle(0, 0, 2000, 2000, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_set_font(fnt_menu);
	draw_set_halign(fa_center);
	draw_opt(sys.s_w / 2, sys.s_h / 2 - 200, "complete!", merge_color(c_aqua, c_lime, 0.5), c_black, 0.3);
	draw_set_font(fnt_info);
	
	if (sys.valid_score)
	{
		draw_text_outline(accx, accy, string(p_val) + "%", 3);
		draw_text_outline(accx, defy, "accuracy:", 2);
		draw_set_color(c_lime);
		draw_text_outline(accx, exy, p_ext, 2);
	
		draw_set_color(c_yellow);
		draw_text_outline(scx, accy, string(s_val), 3);
		draw_text_outline(scx, defy, "score:", 2);
		draw_set_color(c_lime);
		draw_text_outline(scx, exy, s_ext, 2);
	}
	
	draw_set_color(c_white);
	draw_set_font(fnt_def);
	draw_set_halign(fa_left);
	
	if (floor(won) >= 3)
	{
		draw_set_alpha(won - 3)
		draw_rectangle(0, 0, 2000, 2000, false);
		draw_set_alpha(1);
	}
}
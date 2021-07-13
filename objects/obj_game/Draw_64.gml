if (!active)
{
	exit;
}
if (hp == 0)
{
	exit;
}
var m = obj_music;
var bar_x = sys.s_w / 2;
var bar_y = sys.s_h/2 + (sys.s_h/2 - 60) * sys.scroll_dir;
var bar_w = sprite_get_width(spr_hp);
var bar_h = sprite_get_height(spr_hp);
var bar_l = bar_x - bar_w / 2;
var lost = maxhp - hp;
draw_sprite_ext(spr_hp, 0, bar_x, bar_y, 1, 1, 0, c_red, 1);
var p_x = lost / maxhp * bar_w
draw_sprite_part_ext(spr_hp, 0, p_x, 0, hp / maxhp * bar_w, bar_h, bar_l + p_x, bar_y, 1, 1, c_lime, 1);
for (var i = 1; i < 6; i ++)
{
	draw_mod(i, bar_x - 440 - 38*(i - 1), bar_y, 2);
}

if (obj_music.music_pulse)
{
	f_pulse = f_maxpulse;
}
if (f_pulse > 0) f_pulse --;
var fs = 0.7 + (0.1 * (f_pulse/f_maxpulse));
var rfx = 32;
var lfx = 42;

var p_s = asset_load(m.res_folder, m.vtdata[vst.p_icon][0], 1);
var e_s = asset_load(m.res_folder, m.vtdata[vst.en_icon][0], 1);
draw_sprite_ext(e_s, m.vdata[vs.p_icon] * 2 + (hp < maxhp / 4), bar_l + p_x + rfx, bar_y + bar_h / 2, -fs, fs, 0, c_white, 1);
draw_sprite_ext(p_s, m.vdata[vs.en_icon] * 2 + (hp > maxhp / 4 * 3), bar_l + p_x - lfx, bar_y + bar_h / 2, fs, fs, 0, c_white, 1);

var tx_x = bar_x + 90;
var tx_y = bar_y + 32;
var tx_tx = "Score: " + string(round(points));
function draw_text_shadow(xx, yy, str)
{
	draw_set_font(fnt_score);
	draw_set_color(c_black);
	draw_text(xx + 1.5, yy + 1.5, str);
	draw_set_color(c_white);
	draw_text(xx, yy, str);
}
draw_text_shadow(tx_x, tx_y, tx_tx);

draw_text_shadow(tx_x, bar_y - 20, "Misses: " + string(misses));
if (notes_passed > 0)
{
	draw_text_shadow(bar_x + bar_w / 2 + 12, bar_y + 4, string(percent) + "%");
}
draw_set_font(fnt_def);
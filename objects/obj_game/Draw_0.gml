if (!active and !preview) exit;
var m = obj_music;

var bs = m.vdata[vs.bg_s];
var bg_col = c_white;
if (sp_shader == 1) bg_col = merge_color(c_black, c_white, sp_val);
draw_sprite_ext(asset_load(m.res_folder, m.vtdata[vst.bg][0], 2), 0, m.vdata[vs.bg_x], m.vdata[vs.bg_y], bs, bs, 0, bg_col, 1);

if (hp == 0)
{
	draw_set_color(c_black);
	draw_rectangle(-2, -2, 5000, 3000, false);
	draw_set_color(c_white);
}
if (e_id == "") exit;
if (!bge_exists(e_id))
{
	instance_destroy();
}
visible = obj_game.hp > 0;

var m = obj_music;
var c = obj_cam;

var sp = bgep_get(e_id, "sprite");
var xx = bgep_get(e_id, "x");
var yy = bgep_get(e_id, "y");
depth = bgep_get(e_id, "depth");
var sz = bgep_get(e_id, "scale");
var scr = bgep_get(e_id, "scroll_factor");
var img_spd = bgep_get(e_id, "img_speed");
var stills = bgep_get(e_id, "stills");
var hdir = bgep_get(e_id, "hdir");
image_angle = bgep_get(e_id, "angle");
image_alpha = bgep_get(e_id, "alpha");

sprite_index = asset_load(m.res_folder, sp, 1);
var img_num = sprite_get_number(sprite_index);

x = xx + (c.cam_x - c.cam_x * scr);
y = yy + (c.cam_y - c.cam_y * scr);

image_xscale = sz * hdir;
image_yscale = sz;

var d_img = ((global.track_pos / 60) * img_spd) % 1 * (img_num + stills)
image_index = clamp(d_img, 0, img_num - 1);
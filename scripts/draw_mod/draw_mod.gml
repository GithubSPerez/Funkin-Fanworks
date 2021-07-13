// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum MD
{
	scroll_dir, mod_speed, perfect, inv, safe, bot
}
function draw_mod(Mod_id, X, Y, Scale)
{
	var dit = false;
	var msp = spr_mod_spd;
	var mimg = 0;
	switch (Mod_id)
	{
		case(MD.mod_speed):
			if (sys.mod_speed != 1)
			{
				dit = true;
				if (sys.mod_speed < 1)
				{
					mimg = 1;
				}
			}
		break;
		case(MD.perfect):
			msp = spr_mod_perfect;
			if (sys.mod_perfect > 0)
			{
				dit = true;
				if (sys.mod_perfect == 2) mimg = 1;
			}
		break;
		case(MD.inv):
			msp = spr_mod_inv;
			if (sys.mod_inv > 0)
			{
				dit = true;
				if (sys.mod_inv == 2) mimg = 1;
			}
		break;
		case(MD.safe):
			msp = spr_mod_safe;
			if (sys.mod_safe > 0)
			{
				dit = true;
				if (sys.mod_safe == 2) mimg = 1;
			}
		break;
		case(MD.bot):
			msp = spr_mod_bot;
			if (sys.mod_bot != 0)
			{
				dit = true;
			}
		break;
	}
	if (dit)
	{
		gpu_set_tex_filter(false);
		draw_sprite_ext(msp, mimg, X, Y, Scale, Scale, 0, c_white, 1);
		draw_sprite_ext(spr_mod_fg, 0, X, Y, Scale, Scale, 0, c_white, 1);
		gpu_set_tex_filter(true);
	}
}
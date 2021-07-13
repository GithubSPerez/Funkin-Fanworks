switch (obj_game.sp_shader)
{
	case (0):
		draw_self();
	break;
	case (1):
		shader_set(sh_white);
		if (side == 0)
		{
			shader_reset();
			shader_set(sh_gf_white);
		}
		image_blend = merge_color(c_white, c_black, obj_game.sp_val);
		draw_self();
		shader_reset();
		image_blend = c_white;
	break;
}
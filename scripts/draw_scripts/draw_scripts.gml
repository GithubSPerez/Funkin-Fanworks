// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_opt(xx, yy, txt, tcol, ocol, shake)
{
	draw_set_color(ocol);
	if (shake == 0) shader_set(sh_no_alpha);
	if (draw_get_alpha() == 1)
	{
		for (var j = 0; j < 360; j += 2)
		{
			var d = 20 + random_range(-10, 5) * shake;
			if (shake == 0)
			{
				d = 12;
			}
			draw_text(xx + dcos(j) * d, yy - dsin(j) * d, txt);
		}
	}
	if (shake == 0) shader_reset();
	draw_set_color(tcol);
	draw_text(xx, yy, txt);
	draw_set_color(c_white);
}
function draw_text_outline(xx, yy, txt, sc)
{
	var ocol = draw_get_color();
	shader_set(sh_no_alpha);
	draw_set_color(c_black);
	for (var j = 0; j < 360; j += 90)
	{
		var d = sc;
		draw_text_transformed(xx + dcos(j) * d, yy - dsin(j) * d, txt, sc, sc, 0);
	}
	draw_set_color(ocol);
	draw_text_transformed(xx, yy, txt, sc, sc, 0);
	shader_reset();
}
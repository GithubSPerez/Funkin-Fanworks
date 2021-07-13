switch (anim)
{
	case (an.idle):
		visible = true;
		sprite_index = idle_spr;
		var numf = sprite_get_number(sprite_index);
		rimg += spd;//
		if ((global.track_pos + obj_music.track_off + obj_music.soff) > reached / pace)
		{
			reached += 60;
			half ++;
			half %= halves;
			if (half == 0)
			{
				rimg = 0;
			}
			lhalf = half;
		}
		var hnum = (numf / halves) * (half + 1);
		if (rimg > hnum - 0.1) rimg = hnum - 0.1 - loop;
		image_index = rimg;
	break;
	case (an.toot):
		event_user(0);
	break;
	case (an.sing):
		if (sing_time == 0)
		{
			rimg = 0;
		}
		sing_time ++;
		var lframe = floor(3 / (0.5 + sing_spd / 2));
		if (sing_time == lframe)
		{
			rimg = 1;
		}
		if (sing_time >= lframe)
		{
			rimg += sing_spd;
			rimg = clamp(rimg, 0, sprite_get_number(sprite_index) - 1);
		}
		if (sing_time > 29)
		{
			rimg = 0;
			anim = an.idle;
		}
		image_index = rimg;
	break;
	case (an.lost):
		sprite_index = lost_spr;
		lost_time ++;
		var topimg = sprite_get_number(lost_spr) - 1;
		image_speed = 0;
		
		if (lost_time < 50)
		{
			image_index = 0;
		}
		else
		{
			image_index += 0.22 * (sprite_get_number(lost_spr) / 6);
			if (image_index >= topimg)
			{
				image_index = topimg;
			}
		}
	break;
	case (an.invis):
		visible = false;
		if (obj_game.hp != 0)
		{
			anim = an.idle;
		}
	break;
}
var m = obj_music;
var jx = m.vdata[vs.p_jx];
var jy = m.vdata[vs.p_jy];

if (side == -1)
{
	jx = m.vdata[vs.en_jx];
	jy = m.vdata[vs.en_jy];
}
else if (side == 0)
{
	jx = m.vdata[vs.gf_jx];
	jy = m.vdata[vs.gf_jy];
}
x = xstart + jx;
y = ystart + jy;
var m = obj_music;

var xhalf = (m.vdata[vs.top_x] + m.vdata[vs.bott_x]) / 2;
var yhalf = (m.vdata[vs.top_y] + m.vdata[vs.bott_y]) / 2;

var tox = m.vdata[vs.top_x] + sys.s_w / 2;//room_width / 2 - cam_w / 2;
var toy = m.vdata[vs.top_y] + sys.s_h / 2;//room_height / 2 - cam_h / 2;

switch (cam_at)
{
	case (1):
		tox = m.vdata[vs.bott_x] - sys.s_w / 2;
		toy = m.vdata[vs.bott_y] - sys.s_h / 2;
	break;
	case (2):
		toy = m.vdata[vs.bott_y] - sys.s_h / 2;
	break;
	case (3):
		tox = m.vdata[vs.bott_x] - sys.s_w / 2;
	break;
	case (4):
		tox = xhalf;//780;
		toy = yhalf;//m.vdata[vs.top_y] + 383;
	break;
	case (5):
		tox = xhalf;//780;
		toy = m.vdata[vs.bott_y] - sys.s_h / 2;
	break;
	case (6):
		tox = xhalf;//780;
	break;
}
if (obj_game.hp == 0)
{
	point_to = noone;
	with (obj_char)
	{
		if (side = 1)
		{
			other.point_to = id;
		}
	}
	if (point_to != noone)
	{
		tox = point_to.x;
		toy = point_to.y - point_to.sprite_yoffset / 2;
	}
}
var slow = 30;

var tow = sys.s_w * m.vdata[vs.cam_s];
var toh = sys.s_h * m.vdata[vs.cam_s];
cam_w += (tow - cam_w) / slow;
cam_h += (toh - cam_h) / slow;

if (!setsize)
{
	cam_w = tow;
	cam_h = toh;
	setsize = true;
}

slow = 13;

var rtox = tox;
var rtoy = toy;
if (!m.editing)
{
	cam_x += (rtox - cam_x) / slow;
	cam_y += (rtoy - cam_y) / slow;
}

if (m.music_pulse and m.music_beats % 4 == 2)
{
	cam_w /= 1.02;
	cam_h /= 1.02;
}
if (obj_music.editing)
{
	if (!m.bg_mode)
	{
		cam_x = m.vdata[vs.top_x] + sys.s_w / 2;
		cam_y = m.vdata[vs.top_y] + sys.s_h / 2;
	}
	if (m.cam_mode and m.corner)
	{
		cam_x = m.vdata[vs.bott_x] - sys.s_w / 2;
		cam_y = m.vdata[vs.bott_y] - sys.s_h / 2;
	}
	cam_w = sys.s_w;
	cam_h = sys.s_h;
	if (m.cam_mode or m.bg_mode)
	{
		cam_w = tow;
		cam_h = toh;
		
		if (m.bg_mode)
		{
			var cam_spd = 4;
			cam_x += (key("right") - key("left")) * cam_spd * (cam_w / sys.s_w);
			cam_y += (key("down") - key("up")) * cam_spd * (cam_h / sys.s_h);
			
			var ct_x = m.vdata[vs.top_x] + sys.s_w / 2;
			var cb_x = m.vdata[vs.bott_x] - sys.s_w / 2;
			if (ct_x < cb_x) cam_x = clamp(cam_x, ct_x, cb_x);
			else cam_x = clamp(cam_x, cb_x, ct_x);
			
			var ct_y = m.vdata[vs.top_y] + sys.s_h / 2;
			var cb_y = m.vdata[vs.bott_y] - sys.s_h / 2;
			if (ct_y < cb_y) cam_y = clamp(cam_y, ct_y, cb_y);
			else cam_y = clamp(cam_y, cb_y, ct_y);
		}
	}
	
	if (!m.visual_mode)
	{
		cam_x = sys.s_w / 2;
		cam_y = sys.s_h / 2;
	}
	if (m.slist_return)
	{
		cam_x = sys.s_w / 2;
		cam_y = sys.s_h / 2;
		cam_w = sys.s_w;
		cam_h = sys.s_h;
	}
}
camera_set_view_pos(cam, cam_x - cam_w / 2, cam_y - cam_h / 2);
camera_set_view_size(cam, cam_w, cam_h);
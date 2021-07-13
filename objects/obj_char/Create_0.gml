anim = 0;
pace = 1;
spd = 0.22;
sing_spd = -1;
halves = 1;
half = 0;
lhalf = 0;
rimg = 0;
loop = 0;

reached = 60;

dir = 0;
idle_spr = spr_testchar;

side = 1;
alt = 0;

dir_spr[0][0] = spr_testchar_l;
dir_spr[1][0] = spr_testchar_d;
dir_spr[2][0] = spr_testchar_u;
dir_spr[3][0] = spr_testchar_r;
dir_spr[4][0] = spr_testchar_miss;

lost_spr = spr_bf_lost;
lost_time = 0;

enum an
{
	idle, toot, sing, lost, invis
}
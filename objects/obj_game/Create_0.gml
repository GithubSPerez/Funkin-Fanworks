active = true;
hp = 50;
maxhp = 100;

combo = 0;

miss_snd[0] = snd_miss1;
miss_snd[1] = snd_miss2;
miss_snd[2] = snd_miss3;

depth = 9;

preview = false;

f_pulse = 0;
f_maxpulse = 10;

lost = false;
lost_time = 0;
retried = false;

points = 0;

tot_notes = 0;
tot_points = 0;
notes_passed = 0;
accuracy = 0;
percent = 0;
misses = 0;

sp_shader = 0;
sp_val = 1;

for (var i = 0; i < 4; i ++)
{
	check[i][0] = false;
	check[i][1] = false;
	check[i][2] = false;
}
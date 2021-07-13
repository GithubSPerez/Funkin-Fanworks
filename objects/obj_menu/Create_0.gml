men_mus = audio_play_sound(mus_menu, 1, true);
audio_sound_gain(men_mus, 0, 0);
enum mst
{
	credits, title, main, play, keys, mods, create, rsc_list, chart_setup
}
state = sys.menu; //so it doesn't get stuck after credits
lstate = state
st_time = 0;
loaded = false;
songs_loaded = false;

white = 0;
maxw = 80;

select = 0;
opt[0] = "play";
opt[1] = "create";
opt[2] = "key config";
opt[3] = "quit";
men_vol = 1;

song = sys.song_n;
prev = noone;
lvc_s = 1;

toy = 0;

time = 0;
beat = 0;

x = 0;
y = 0;

pressed = -1;
backed = -1;

kc_opt = 0;
kc_setting = false;

mod_opt = 0;
ms_up = 30;
ms_t = 0;

qtrans = false;

calc_delay = false;
de_time = 0;
de_maxtime = 120;
de_aprox = noone;
de_val_list = ds_list_create();
de_presses = 12;

rline[0][0] = -1;

function rline_add(t1, t2)
{
	if (rline[0][0] == -1)
	{
		rline[0][0] = t1;
		rline[0][1] = t2;
	}
	else
	{
		var i = array_length(rline);
		rline[i][0] = t1;
		rline[i][1] = t2;
	}
}

rline_add("fonts are different", "i know");
rline_add("try to beat tricky", "with old input");
rline_add("song editor?", "already happened :D");
rline_add("favorite game", "of aweonaso gang");
rline_add("fnf girlfriend", "imagenes hot buscar");
rline_add("who designed this chart??", "actual trash.");
rline_add("f3", "no, I meant the mario one");
rline_add("evangelion mod", "my favorite too!");
rline_add("who named pico?", "el mismisimo ctm");
rline_add("I tripped", ":(");
rline_add("Rivals of Aether", "biggest inspiration");
rline_add("um...", "what's his name again?");
rline_add("the joke:", "");
rline_add("cval needs a girlfriend", "raise awareness");
rline_add("made with kade engine", "is what I would say but");

randomize();

line = irandom_range(0, array_length(rline) - 1);
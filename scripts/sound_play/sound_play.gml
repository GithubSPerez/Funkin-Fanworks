// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sound_play(s){
	audio_stop_sound(s);
	var ps = audio_play_sound(s, 1, false);
	return(ps);
}
mus_spd = (bpm / 60) * sys.mod_speed;
ex_add_get();
if (!won and !obj_game.lost)
{
	if (game_get_speed(gamespeed_fps) != sys.top_fps)
	game_set_speed(sys.top_fps, gamespeed_fps);
}
else
{
	if (game_get_speed(gamespeed_fps) != 60)
	game_set_speed(60, gamespeed_fps);
}
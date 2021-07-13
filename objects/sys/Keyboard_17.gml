if (!debug) exit;

if (key_press("right"))
{
	level ++;
}
if (key_press("left"))
{
	level --;
}
level = clamp(level, 0, 3);

if (keyboard_check_pressed(ord("G")))
{
	room_goto(rm_gogame);
}
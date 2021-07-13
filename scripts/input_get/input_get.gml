// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function input_ini()
{
	key_map = ds_map_create();
	cus[0] = ord("D");
	cus[1] = ord("F");
	cus[2] = ord("J");
	cus[3] = ord("K");
	
	key_name[0] = "right";
	key_name[1] = "left";
	key_name[2] = "down";
	key_name[3] = "up";
	key_name[4] = "jump";
	key_name[5] = "start";
	key_name[6] = "back";
	key_name[7] = "a";
	key_name[8] = "b";
	key_name[9] = "c";
	key_name[10] = "d";
	
	for (var i = 0; i < array_length(key_name); i ++;)
	{
		key_map[? key_name[i] + ",d"] = false;
		key_map[? key_name[i] + ",p"] = false;
		key_map[? key_name[i] + ",r"] = false;
		key_map[? key_name[i] + ",l"] = false;
	}
}
function key(key_name)
{
	return(sys.key_map[? key_name + ",d"]);
}
function key_press(key_name)
{
	return(sys.key_map[? key_name + ",p"]);
}
function key_release(key_name)
{
	return(sys.key_map[? key_name + ",r"]);
}
function input_get()
{
	var ctr = 4;
	key_map[? "right,d"] = keyboard_check(ord("D")) or keyboard_check(vk_right);
	key_map[? "left,d"] = keyboard_check(ord("A")) or keyboard_check(vk_left);
	key_map[? "down,d"] = keyboard_check(ord("S")) or keyboard_check(vk_down);
	key_map[? "up,d"] = keyboard_check(ord("W")) or keyboard_check(vk_up);
	key_map[? "jump,d"] = keyboard_check(vk_space);
	key_map[? "start,d"] = keyboard_check(vk_enter);
	key_map[? "back,d"] = (keyboard_check(vk_backspace) or keyboard_check(vk_escape));
	key_map[? "a,d"] = keyboard_check(cus[0]);
	key_map[? "b,d"] = keyboard_check(cus[1]);
	key_map[? "c,d"] = keyboard_check(cus[2]);
	key_map[? "d,d"] = keyboard_check(cus[3]);
	
	
	for (var i = 0; i < array_length(key_name); i ++;)
	{
		key_map[? key_name[i] + ",p"] = false;
		key_map[? key_name[i] + ",r"] = false;
		if (key(key_name[i]) and !key_map[? key_name[i] + ",l"])
		{
			key_map[? key_name[i] + ",p"] = true;
		}
		if (!key(key_name[i]) and key_map[? key_name[i] + ",l"])
		{
			key_map[? key_name[i] + ",r"] = true;
		}
		key_map[? key_name[i] + ",l"] = key(key_name[i]);
	}
}
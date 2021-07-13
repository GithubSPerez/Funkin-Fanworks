// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function opt_save()
{
	ini_open("game_opt.opt");
	var sec_k = "custom_keys";
	
	ini_write_real(sec_k, "active", cus_keys);
	ini_write_real(sec_k, "a", cus[0]);
	ini_write_real(sec_k, "b", cus[1]);
	ini_write_real(sec_k, "c", cus[2]);
	ini_write_real(sec_k, "d", cus[3]);
	
	var sec_m = "mods"
	
	ini_write_real(sec_m, "scroll_dir", scroll_dir);
	ini_write_real(sec_m, "speed", mod_speed);
	ini_write_real(sec_m, "perfect", mod_perfect);
	ini_write_real(sec_m, "inv", mod_inv);
	ini_write_real(sec_m, "safe", mod_safe);
	ini_write_real(sec_m, "bot", mod_bot);
	ini_write_real(sec_m, "delay", mod_delay);
	ini_write_real(sec_m, "vdelay", mod_vdelay);
	
	var sec_g = "general";
	ini_write_real(sec_g, "vol", volume);
	ini_write_real(sec_g, "fps", top_fps);
	
	ini_close();
}

function opt_load()
{
	ini_open("game_opt.opt");
	var sec_k = "custom_keys";
	
	cus_keys = ini_read_real(sec_k, "active", false);
	cus[0] = ini_read_real(sec_k, "a", ord("D"));
	cus[1] = ini_read_real(sec_k, "b", ord("F"));
	cus[2] = ini_read_real(sec_k, "c", ord("J"));
	cus[3] = ini_read_real(sec_k, "d", ord("K"));
	
	var sec_m = "mods"
	
	scroll_dir = ini_read_real(sec_m, "scroll_dir", 1);
	mod_speed = ini_read_real(sec_m, "speed", 1);
	mod_perfect = ini_read_real(sec_m, "perfect", 0);
	mod_inv = ini_read_real(sec_m, "inv", 0);
	mod_safe = ini_read_real(sec_m, "safe", 0);
	mod_bot = ini_read_real(sec_m, "bot", false);
	mod_delay = ini_read_real(sec_m, "delay", 50);
	mod_vdelay = ini_read_real(sec_m, "vdelay", mod_delay / vd_divisor);
	
	var sec_g = "general";
	
	volume = ini_read_real(sec_g, "vol", 1);
	top_fps = ini_read_real(sec_g, "fps", 60);
	ini_close();
}
track_pos = 0;
dir = 0;
actmode = 0;
command = "";

lx = x;
xdif = 0;

state = 0;
out = false;
par = "start";
time = 0;

frame_add = 0;

selected = false;

function command_get_func(Cmd)
{
	if (string_replace(Cmd, "=", "") = Cmd) return("");
	var exec = read_till(Cmd, "=");
	return(exec);
}
function command_execute(Cmd)
{
	if (string_replace(Cmd, "=", "") = Cmd) exit;
	var ret = 0;
	
	//show_message(Cmd);
	var exec = read_till(Cmd, "=");
	//show_message(exec);
	var val = string_replace(Cmd, exec + "=", "");
	//show_message(val);
	
	switch (exec)
	{
		#region cam position
		case ("cam_pos"):
			obj_cam.cam_at = real(val);
		break;
		#endregion
		
		#region fire arrows
		case ("fire_arrows"):
			if (val = "true" or val = "1")
			{
				ret = true;
			}
			with (obj_char)
			{
				if (side == -1)
				{
					dir = 2;
					event_user(0);
				}
			}
			state = 1;
		break;
		#endregion
		
		#region shader
		case ("shader"):
			switch (val)
			{
				case ("normal"):
					obj_game.sp_shader = 0;
				break;
				case ("bad_apple"):
					obj_game.sp_shader = 1;
				break;
			}
		break;
		#endregion
		
		#region shader value
		case ("shader_value"):
			obj_game.sp_val = real(val);
		break;
		#endregion
		
		#region flow fx
		case ("arrow_wave"):
			obj_music.ar_to_f = real(val);
		break;
		case ("arrow_wave_speed"):
			obj_music.arrow_fx_spd = real(val);
		break;
		case ("player_alt"):
			obj_bf.alt = real(val);
		break;
		case ("enemy_alt"):
			obj_spk.alt = real(val);
		break;
		#endregion
	}
	return(ret);
}
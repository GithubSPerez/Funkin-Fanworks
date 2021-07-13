// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function bge_add(Name){
	with (obj_music)
	{
		ds_list_add(bg_elements, Name);
		var n = Name;
		bgep_set(n, "x", 110);
		bgep_set(n, "y", 110);
		bgep_set(n, "sprite", "spr_element");
		bgep_set(n, "img_speed", 1);
		bgep_set(n, "scale", 1);
		bgep_set(n, "scroll_factor", 1);
		bgep_set(n, "depth", 3);
		bgep_set_default(n, "hdir");
		bgep_set_default(n, "stills");
		bgep_set_default(n, "angle");
		bgep_set_default(n, "alpha");
	}
}
function bgep_set(E_id, Prop, Val)
{
	with (obj_music)
	{
		bg_data[? string(E_id) + "," + Prop] = Val;
	}
}
function bgep_get(E_id, Prop)
{
	with (obj_music)
	{
		var pkey = string(E_id) + "," + Prop
		if (ds_map_exists(bg_data, pkey))
		{
			return(bg_data[? pkey])
		}
		else
		{
			bgep_set_default(E_id, Prop);
			return(bg_data[? pkey]);
		}
	}
}
function bge_number()
{
	return(ds_list_size(obj_music.bg_elements))
}
function bge_get_name(Index)
{
	return(obj_music.bg_elements[| Index]);
}
function bge_exists(E_id)
{
	return(ds_list_find_index(obj_music.bg_elements, E_id) != -1)
}
function bge_delete(Index)
{
	ds_list_delete(obj_music.bg_elements, Index);
}
function bgep_set_default(E_id, Prop)
{
	var val = 0;
	switch (Prop)
	{
		case ("x"):
		case ("y"):
			val = 110;
		break;
		case ("sprite"):
			val = "spr_element";
		break;
		case ("img_speed"):
		case ("scale"):
		case ("scroll_factor"):
		case ("hdir"):
		case ("alpha"):
			val = 1;
		break;
		case ("depth"):
			val = 3;
		break;
		case ("stills"):
		case ("angla"):
			val = 0;
		break;
	}
	bgep_set(E_id, Prop, val)
}
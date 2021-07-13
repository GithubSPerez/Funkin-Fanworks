state = 0;
r_folders[0] = -1;
r_charts[0] = -1;

function load_folders()
{
	var txt = ds_map_find_first(sys.rsc);
	var i = 0;
	while (txt != undefined)
	{
		r_folders[i] = txt;
		i ++;
		txt = ds_map_find_next(sys.rsc, txt);
	}
}
function cargar_charts()
{
	instance_destroy(obj_nothing);
	var n = instance_create_depth(0, 0, 0, obj_nothing)
	with (n) r_charts[0] = -1;
	r_charts = n.r_charts;
	var txt = ds_map_find_first(sys.charts);
	var i = 0;
	while (txt != undefined)
	{
		r_charts[i] = txt;
		i ++;
		txt = ds_map_find_next(sys.charts, txt);
	}
}
load_folders();
cargar_charts();

r_edit = noone;

flist_au = ds_list_create();
flist_bg = ds_list_create();
flist_sp = ds_list_create();

load = false;

import_screen = 0;

import_p = false;
import_type = 0;

exporting = false;
export_list = ds_map_create();

strip = ds_list_create();
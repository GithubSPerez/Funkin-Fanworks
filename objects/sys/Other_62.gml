var json = async_load[? "result"];
var map = json_decode(json);
if (map == -1) exit;
if (ds_map_exists(map, "latest"))
{
	expected_ver = map[? "latest"];
}
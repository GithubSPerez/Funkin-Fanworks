// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function code_generate(){
	return(string(current_time % 1000) + string(current_second) + string(current_minute) + string(current_day) + string(current_month) + string(current_year));
}
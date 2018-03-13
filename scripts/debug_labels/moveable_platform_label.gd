extends "res://scripts/debug_label.gd"


func _process(delta):
	var string = ""
	
	if(get_parent().last):
		string += "true"
	else:
		string += "false"
		
	text = string
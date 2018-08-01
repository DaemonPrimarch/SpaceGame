tool

extends StaticBody2D

export(Color) var on_color = Color(0, 1, 0)
export(Color) var off_color = Color(1, 0, 0)

func _ready():
	attempt_connection()
	if(not is_connected("tree_entered", self, "attempt_connection")):
		connect("tree_entered", self, "attempt_connection")
	if(not is_connected("tree_exiting", self, "attempt_connection_break")):
		connect("tree_exiting", self, "attempt_connection_break")

func attempt_connection_break():
	if(get_parent() and get_parent().is_in_group("switch")):
		get_parent().disconnect("switched_on", $Sprite, "set_modulate")
		get_parent().disconnect("switched_off", $Sprite, "set_modulate")

func attempt_connection():
	if(get_parent().is_in_group("switch")):
		if(not get_parent().is_connected("switched_on", $Sprite, "set_modulate")):
			get_parent().connect("switched_on", $Sprite, "set_modulate", [on_color])
		if(not get_parent().is_connected("switched_off", $Sprite, "set_modulate")):
			get_parent().connect("switched_off", $Sprite, "set_modulate", [off_color])
	else:
		print("PARENT OF BULLET SWITCH ELEMENT NOT SWITCH")
	
func _on_bullet_hit(bullet):
	if(get_parent().is_in_group("switch")):
		if(get_parent().is_toggleable()):
			get_parent().toggle()
		else:
			get_parent().set_state(true)
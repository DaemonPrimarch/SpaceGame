extends "res://addons/state_labels/debug_label.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _physics_process(delta):
	if(get_parent().is_invulnerable()):
		text = "INVULNERABLE"
	else:
		text = ""

extends "res://weapon.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func press_trigger():
	if(get_node("light").is_enabled()):
		get_node("light").set_enabled(false)
	else:
		get_node("light").set_enabled(true)
extends Node

export var property = ""

signal on_true
signal on_false

func _ready():
	if(get_node("/root/SAVE_MANAGER").get_property(property)):
		emit_signal("on_true")
	else:
		emit_signal("on_false")
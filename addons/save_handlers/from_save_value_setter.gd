extends Node

export (NodePath) var node_path
export var value = "value"

export var save_value = ""

export var auto_update = true

func update_value():
	if(SAVE_MANAGER.has_property(save_value)):
		get_node(node_path)[value] = SAVE_MANAGER.get_property(save_value)
	else:
		print("ERROR: Property: ", save_value, " not found in save!")
	
func on_save_changed(property):
	if(property == save_value):
		update_value()

func _ready():
	update_value()
	
	if(auto_update):
		SAVE_MANAGER.connect("save_changed", self, "on_save_changed")


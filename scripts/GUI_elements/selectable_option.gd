extends Control

func select():
	get_node("main/selected").visible = true

func deselect():
	get_node("main/selected").visible  = false
	
func set_option(option):
	get_node("main/Label").text = option
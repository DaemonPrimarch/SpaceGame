extends Control

func select():
	get_node("main/selected").set_visible(true)

func deselect():
	get_node("main/selected").set_visible(false)
	
func set_option(option):
	get_node("main/Label").text = option
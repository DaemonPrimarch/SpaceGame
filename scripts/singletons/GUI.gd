extends CanvasLayer

onready var HP_bar_handler = $HP_bar_handler

func get_layer():
	## DEPRECATED
	
	return self

func add_HP_bar(tracked_object):
	## DEPRECATED
	
	HP_bar_handler.add_HP_bar(tracked_object)

func remove_HP_bar(tracked_object):
	## DEPRECATED
	
	HP_bar_handler.remove_HP_bar(tracked_object)
	
func has_HP_bar(object):
	## DEPRECATED
		
	HP_bar_handler.has_HP_bar(object)

func reflow_HP_bars():
	## DEPRECATED
	
	HP_bar_handler.reflow_HP_bars()

func set_room_name(name):
	get_layer().get_node("room_label").text = name
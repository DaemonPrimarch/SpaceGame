extends Node

var layer

var hp_bars = {}

func _ready():
	#Add CanvasLayer to root
	layer = preload("res://nodes/GUI_elements/GUI_layer.tscn").instance()
	
	get_tree().get_root().call_deferred("add_child",layer)

func get_layer():
	return layer

#HP Bars:
func add_HP_bar(tracked_object):
	if(not has_HP_bar(tracked_object)):
		var new_bar = preload("res://nodes/GUI_elements/hp_bar.tscn").instance();
		new_bar.set_tracked_object(tracked_object)
		hp_bars[tracked_object] = new_bar
		GUI.get_layer().add_child(new_bar)
		call_deferred("reflow_HP_bars")
		
	reflow_HP_bars()

func remove_HP_bar(tracked_object):
	if(has_HP_bar(tracked_object)):
		
		var bar = hp_bars[tracked_object]
		hp_bars.erase(tracked_object)
		bar.destroy()
		reflow_HP_bars()
	
func has_HP_bar(object):
	return hp_bars.has(object)

func reflow_HP_bars():
	var i = 0
	for bar in hp_bars:
		hp_bars[bar].set_position(Vector2(hp_bars[bar].get_position().x, hp_bars[bar].get_size().y * i))
		i += 1
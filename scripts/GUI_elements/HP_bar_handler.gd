extends Control

var bars = {}

var bar_node = preload("res://nodes/GUI_elements/hp_bar.tscn")

func add_HP_bar(tracked_object):
	if(not has_HP_bar(tracked_object)):
		var new_bar = bar_node.instance();
		new_bar.set_tracked_object(tracked_object)
		bars[tracked_object] = new_bar
		
		get_parent().add_child(new_bar)
		
		call_deferred("reflow_HP_bars")
		
	reflow_HP_bars()

func remove_HP_bar(tracked_object):
	if(has_HP_bar(tracked_object)):
		var bar = bars[tracked_object]
		bars.erase(tracked_object)
		bar.destroy()
		reflow_HP_bars()
	
func has_HP_bar(object):
	return bars.has(object)

func reflow_HP_bars():
	var i = 0
	for bar in bars:
		bars[bar].set_position(Vector2(bars[bar].get_position().x, bars[bar].get_size().y * i))
		i += 1
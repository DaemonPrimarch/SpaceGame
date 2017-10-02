extends Node

var layer
var hp_bar_count = 0

var hp_bars = {}

func _ready():
	layer = CanvasLayer.new()
	layer.set_name("Layer")
	get_tree().get_root().call_deferred("add_child",layer)
	#call_deferred("do_stuff")


func do_stuff():
	var box = preload("res://nodes/option_select_box.tscn").instance()
	box.set_pos(Vector2(100, 100))
	box.set_options(["OPTION A", "OPTION B", "OPTION C", "OPTION D"])
	get_layer().add_child(box)
	box.display()
	
	var dialog_box = preload("res://nodes/dialog_box.tscn").instance()
	dialog_box.set_pos(Vector2(0, 400))
	dialog_box.set_total_text("Hello world, stan suckt balls!")
	get_layer().add_child(dialog_box)
	dialog_box.scrolling = true
	dialog_box.display()

func get_layer():
	return layer

#HP Bars:
func add_HP_bar(tracked_object):
	var new_bar = preload("res://nodes/hp_bar.tscn").instance();
	new_bar.set_tracked_object(tracked_object)
	hp_bars[tracked_object] = new_bar
	GUI.get_layer().add_child(new_bar)
	call_deferred("reflow_HP_bars")

func remove_HP_bar(tracked_object):
	var bar = hp_bars[tracked_object]
	hp_bars.erase(tracked_object)
	bar.destroy()
	reflow_HP_bars()
	
func reflow_HP_bars():
	var i = 0
	for bar in hp_bars:
		hp_bars[bar].set_pos(Vector2(hp_bars[bar].get_pos().x, hp_bars[bar].get_size().y * i))
		i += 1
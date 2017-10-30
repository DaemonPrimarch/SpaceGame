extends "res://scripts/hazard_area.gd"

export var height = 1
export var speed = 64

var start = false
var current_y_pos

func get_height():
	return height

func start(body):
	start = true
	current_y_pos = get_pos().y
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Goo Alert!!!"]))

func stop():
	start = false
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Stabilized."]))

func _fixed_process(delta):
	._fixed_process(delta)
	if(start):
		if(get_pos().y < current_y_pos + height*64):
			set_pos(get_pos() + Vector2(0,speed*delta))
		else:
			stop()

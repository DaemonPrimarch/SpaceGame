extends Node2D

export var has_cooldown = true 

onready var cooldown_timer = get_node("cooldown_timer")

const FRONT = "front"
const DOWN  = "down"
const UP = "up"
const FULL_DOWN = "full_down"
const FULL_UP = "full_up"
onready var barrel = get_node("barrel")



var current_point_name = FRONT

var holding = false

func get_current_name():
	return current_point_name

func get_current_point():
	return get_node(get_current_name())

func set_current_point(name):
	if(has_node(name)):
		current_point_name = name
		barrel.set_global_pos(get_current_point().get_global_pos())
		barrel.set_rot(get_current_point().get_rot())
	else:
		print("ERRORS POINT NOT FOUND")

func is_holding():
	return holding

func set_holding(boolean):
	holding = boolean

func has_cooldown_timer():
	return has_cooldown

func _ready():
	set_current_point(current_point_name)
	set_process(true)

func _process(delta):
	if(is_holding()):
		on_hold_trigger()

#functions for handling input (called through player)

func press_trigger():
	if(has_cooldown_timer()):
		if(not (cooldown_timer.get_time_left() > 0)):
			cooldown_timer.start()
			set_holding(true)
			on_trigger_press()
	else:
		set_holding(true)
		on_trigger_press()

func release_trigger():
	set_holding(false)
	on_trigger_release()

#Functions the child should call

func on_trigger_press():
	pass

func on_trigger_release():
	pass

func on_hold_trigger():
	pass

#Otherwise timer will restart automatically.
func _on_cooldown_timer_timeout():
	cooldown_timer.stop()
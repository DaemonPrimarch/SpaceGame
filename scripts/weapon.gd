extends Node2D

export var has_cooldown = true 

onready var cooldown_timer = get_node("cooldown_timer")
onready var front = get_node("front")
onready var down = get_node("down")
onready var up = get_node("up")
onready var full_down = get_node("full_down")
onready var full_up = get_node("full_up")
onready var barrel = get_node("barrel")
onready var current_point = front

enum ORIENTATION {FULL_UP, UP, FRONT, DOWN, FULL_DOWN}

var holding = false
var current_orientation = ORIENTATION.FRONT

func get_orientation():
	return current_orientation

func set_orientation(value):
	current_orientation = value

func set_aim_orientation(orientation):
	if(orientation == ORIENTATION.FULL_UP):
		set_orientation_position(full_up)
		current_orientation = ORIENTATION.FULL_UP
	elif(orientation == ORIENTATION.UP):
		set_orientation_position(up)
		current_orientation = ORIENTATION.UP
	elif(orientation == ORIENTATION.FRONT):
		set_orientation_position(front)
		current_orientation = ORIENTATION.FRONT
	elif(orientation == ORIENTATION.DOWN):
		set_orientation_position(down)
		current_orientation = ORIENTATION.DOWN
	elif(orientation == ORIENTATION.FULL_DOWN):
		set_orientation_position(full_down)
		current_orientation = ORIENTATION.FULL_DOWN

func get_current_point():
	return current_point

func set_current_point(point):
	current_point = point

func set_orientation_position(point):
	set_current_point(point)
	barrel.set_global_pos(point.get_global_pos())
	barrel.set_rot(point.get_rot())

func is_holding():
	return holding

func set_holding(boolean):
	holding = boolean

func has_cooldown_timer():
	return has_cooldown

func _ready():
	set_current_point(front)
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
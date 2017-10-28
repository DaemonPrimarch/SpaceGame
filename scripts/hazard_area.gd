extends Area2D

export var damage = 1 setget set_damage,get_damage
export var has_timer = false
export var push_time = 5 setget set_push_time, get_push_time
export var push_time_extended = 5 setget set_push_time_extended, get_push_time_extended
export var push_speed_x = 4*64 setget set_push_speed_x, get_push_speed_x
export var push_speed_y = 2*64 setget set_push_speed_y, get_push_speed_y
export var pushes = false

var timer_on
var timer_off

func pushes():
	return pushes

func set_push_speed_x(value):
	push_speed_x = value

func get_push_speed_x():
	return push_speed_x

func set_push_speed_y(value):
	push_speed_y = -value

func get_push_speed_y():
	return push_speed_y

func set_push_time(value):
	push_time = value

func get_push_time():
	return push_time

func set_push_time_extended(value):
	push_time_extended = value

func get_push_time_extended():
	return push_time_extended

func set_damage(value):
	damage = value

func get_damage():
	return damage

func has_timer():
	return has_timer

func start_timer_on():
	timer_off.stop()
	timer_on.start()

func start_timer_off():
	timer_on.stop()
	timer_off.start()

func _ready():
	if(has_timer()):
		timer_on = get_node("Timer_on")
		timer_off = get_node("Timer_off")
		start_timer_on()

func _on_Timer_on_timeout():
	set_hidden(not is_hidden())
	start_timer_off()

func _on_Timer_off_timeout():
	set_hidden(not is_hidden())
	start_timer_on()

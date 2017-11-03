extends "res://scripts/enemies/enemy.gd"

onready var player_finder = get_node("player_finder")

enum STATE {MOVING_UP, MOVING_DOWN, WAITING}

var state = STATE.WAITING

export var push_time = 5 setget set_push_time, get_push_time
export var push_time_extended = 5 setget set_push_time_extended, get_push_time_extended
export var push_speed_x = 4*64 setget set_push_speed_x, get_push_speed_x
export var push_speed_y = 2*64 setget set_push_speed_y, get_push_speed_y

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

func _ready():
	player_finder.add_exception(self)
	set_fixed_process(true)

func get_state():
	return state
	
func set_state(new_state):
	state = new_state

func _fixed_process(delta):
	if(get_state() == STATE.WAITING):
		if(player_finder.is_colliding()):
			print(player_finder.get_collider().get_name())
			if(player_finder.get_collider().is_in_group("player")):
				set_state(STATE.MOVING_DOWN)
				set_gravity_enabled(true)
	elif(get_state() == STATE.MOVING_UP):
		if(get_pos().y <= 0):
			set_state(STATE.WAITING)
		else:
			move(Vector2(0, -1) * get_movement_speed() * delta)
		

func _on_drop_down_spider_collision(info):
	if(get_state() == STATE.MOVING_DOWN):
		set_gravity_enabled(false)
		set_state(STATE.MOVING_UP)
	elif(get_state() == STATE.MOVING_UP):
		if(info.get_collider().is_in_group("terrain")):
			set_state(STATE.WAITING)
	
	if(info.get_collider().is_in_group("player")):
		info.get_collider().push(get_push_time(), get_push_time_extended(),Vector2(get_push_speed_x(),get_push_speed_y()))
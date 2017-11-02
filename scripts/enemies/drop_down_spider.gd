extends "res://scripts/enemies/enemy.gd"

onready var player_finder = get_node("player_finder")

enum STATE {MOVING_UP, MOVING_DOWN, WAITING}

var state = STATE.WAITING

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
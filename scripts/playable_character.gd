tool
extends "res://scripts/entity.gd"

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")
onready var animation_player = get_node("AnimationPlayer")
onready var gun = get_node("gun")

enum STATE {REGULAR_JUMPING, DOUBLE_JUMPING, WALL_JUMPING, WALL_SLIDING, GROUNDED, FALLING, CLIMBING, CRAWLING, CROUCHING, PUSHED}

var current_state = STATE.GROUNDED

var current_animation = "idle"

var jumped = false
var double_jumped = false
var wall_jumped = false

#cn = can
export var cn_jump = true
export var cn_double_jump = true
export var cn_wall_slide = true
export var cn_wall_jump = true

var time_jumping = 0
var time_double_jumping = 0
var time_wall_jumping = 0
var time_pushed = 0

export var jump_height = 64 * 4
export var double_jump_height = 64 * 2
export var climbing_speed = 64 * 4
export var crawl_speed = 64 * 2
export var wall_jump_height = 64 * 2
export var wall_jump_length = 64 * 4

var already_loaded = false

var push_speed
var push_time
var push_time_extended

var ladder = null

func _ready():
	if(not already_loaded):
		set_current_state(STATE.GROUNDED)
		
		if(not get_tree().is_editor_hint()):
			set_fixed_process(true)
		
		already_loaded = true
	
func get_ladder():
	return ladder
	
func is_inside_ladder():
	return (ladder != null)

func is_in_ladder():
	return is_inside_ladder()

func set_ladder(lad):
	ladder = lad

func get_crawl_speed():
	return crawl_speed

func get_current_animation():
	return current_animation

func play_or_continue_animation(animation):
	if(get_current_animation() != animation):
		animation_player.play(animation)
		current_animation = animation

func get_climbing_speed():
	return climbing_speed

#REGULAR JUMP HELPER FUNCTIONS:

func set_can_jump(value):
	cn_jump = value

func can_jump():
	return cn_jump

func set_jumped(value):
	jumped = value

func has_jumped():
	return jumped

func get_jump_height():
	return jump_height
	
func get_jump_decelleration():
	return get_gravity_vector()

#Not entirely sure about the implementation, the .y disturbs me.
func get_max_jump_time():
	return sqrt(get_jump_height()/(get_jump_decelleration().y/2))

func get_starting_jump_velocity():
	return -get_jump_decelleration()*get_max_jump_time()
	
func get_current_jump_velocity(time):
	return get_starting_jump_velocity()+get_jump_decelleration()*time
	
func set_time_jumping(new_time):
	time_jumping = new_time
	
func get_time_jumping():
	return time_jumping

#DOUBLE JUMP HELPER FUNCTIONS:

func set_can_double_jump(value):
	cn_double_jump = value

func can_double_jump():
	return cn_double_jump

func set_double_jumped(value):
	double_jumped = value

func has_double_jumped():
	return double_jumped

func get_double_jump_height():
	return double_jump_height

func get_max_double_jump_time():
	return sqrt(get_double_jump_height()/(get_double_jump_decelleration().y/2))

func get_starting_double_jump_velocity():
	return get_double_jump_decelleration()*get_max_double_jump_time()*-1

func get_current_double_jump_velocity(time):
	return get_starting_double_jump_velocity()+get_double_jump_decelleration()*time
	
func set_time_double_jumping(new_time):
	time_double_jumping = new_time

func get_time_double_jumping():
	return time_double_jumping

#WALL JUMPING HELPER FUNCTIONS:
	
func set_can_wall_slide(value):
	cn_wall_slide = value

func can_wall_slide():
	return cn_wall_slide
	
func set_can_wall_jump(value):
	cn_wall_jump = value
	
func can_wall_jump():
	return cn_wall_jump	
	
func set_wall_jumped(value):
	wall_jumped = value
	
func get_wall_jump_length():
	return wall_jump_length

func get_wall_jump_height():
	return wall_jump_height
	
func get_max_wall_jump_time():
	return sqrt(get_wall_jump_height()/(get_jump_decelleration().y/2))

func get_min_wall_jump_time():
	var tmin = -get_starting_wall_jump_velocity().y/((get_gravity_vector().y/2)*(1+(get_starting_wall_jump_velocity().x/get_movement_speed())*(get_starting_wall_jump_velocity().x/get_movement_speed())))
	if(tmin > get_max_wall_jump_time()):
		print("ERROR: jumping height too damn high!")
		return tmin
	else:
		return tmin

func get_starting_wall_jump_velocity():
	return Vector2(get_wall_jump_length()/get_max_wall_jump_time(), -get_wall_jump_height()/get_max_wall_jump_time() - get_max_wall_jump_time()*get_gravity_vector().y/2)

func get_current_wall_jump_velocity(time):
	return get_starting_wall_jump_velocity()+get_jump_decelleration()*time

func get_double_jump_decelleration():
	return get_gravity_vector()

func set_time_wall_jumping(new_time):
	time_wall_jumping = new_time
	
func get_time_wall_jumping():
	return time_wall_jumping

#PUSHED HELPER FUNCTIONS:

func get_time_pushed():
	return time_pushed

func set_time_pushed(value):
	time_pushed = value

func get_push_speed():
	return push_speed

func set_push_speed(value):
	push_speed = value

func get_push_time():
	return push_time

func set_push_time(value):
	push_time = value

func get_push_time_extended():
	return push_time_extended

func set_push_time_extended(value):
	push_time_extended = value

################################################

func set_current_state(state):
	if(state != get_current_state()):
		var old_state = get_current_state()
		
		leave_state(get_current_state(), state)
		enter_state(state, old_state)
		current_state = state

func get_current_state():
	return current_state

func enter_state(state, old_state):
	pass
func leave_state(state, new_state):
	pass
func process_state(state, delta):
	pass
	
func _fixed_process(delta):
	process_state(get_current_state(), delta)

func push():
	pass
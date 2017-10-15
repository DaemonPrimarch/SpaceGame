
extends "res://scripts/entity.gd"

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")

onready var animation_player = get_node("AnimationPlayer")

enum STATE {REGULAR_JUMPING, DOUBLE_JUMPING, WALL_JUMPING, WALL_SLIDING, GROUNDED, FALLING, CLIMBING, CRAWLING}

var current_state = STATE.GROUNDED

var current_animation = "idle"

var original_gravity_enabled = false

var time_jumping = 0
var jumped = false

var time_wall_jumping = 0

var time_double_jumping = 0
var double_jumped = false

var first_frame_crawling = false

var wall_jump_direction = 0

export var jump_height = 64 * 4
export var double_jump_height = 64 * 2
export var climbing_speed = 64 * 4
export var crawl_speed = 64 * 2
export var wall_jump_height = 64 * 2
export var wall_jump_length = 64 * 4

func _ready():
	set_fixed_process(true)

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

func get_wall_jump_length():
	return wall_jump_length

func get_wall_jump_height():
	return wall_jump_height

func has_jumped():
	return jumped

func has_double_jumped():
	return double_jumped

func get_jump_height():
	return jump_height

func get_jump_decelleration():
	return get_gravity_vector()

#Not entirely sure about the implementation, the .y disturbs me.
func get_max_jump_time():
	return sqrt(get_jump_height()/(get_jump_decelleration().y/2))
	
func get_max_wall_jump_time():
	return sqrt(get_wall_jump_height()/(get_jump_decelleration().y/2))

func get_min_wall_jump_time():
	var tmin = -get_starting_wall_jump_velocity().y/((get_gravity_vector().y/2)*(1+(get_starting_wall_jump_velocity().x/get_movement_speed())*(get_starting_wall_jump_velocity().x/get_movement_speed())))
	if(tmin > get_max_wall_jump_time()):
		#rounding error fixer
		print("fall_wall")
		return 0.25 + sqrt(-get_starting_wall_jump_velocity().y*get_max_wall_jump_time()/((get_gravity_vector().y/2)*(1+(get_starting_wall_jump_velocity().x/get_movement_speed())*(get_starting_wall_jump_velocity().x/get_movement_speed()))))
	else:
		return tmin

func get_starting_wall_jump_velocity():
	return Vector2(get_wall_jump_length()/get_max_wall_jump_time(), -get_wall_jump_height()/get_max_wall_jump_time() - get_max_wall_jump_time()*get_gravity_vector().y/2)
	
func get_starting_jump_velocity():
	return get_jump_decelleration()*get_max_jump_time()*-1

func get_current_jump_velocity():
	return get_starting_jump_velocity()+get_jump_decelleration()*time_jumping

func get_current_wall_jump_velocity():
	return get_starting_wall_jump_velocity()+get_jump_decelleration()*time_wall_jumping

func get_double_jump_height():
	return double_jump_height

func get_double_jump_decelleration():
	return get_gravity_vector()
	
func get_max_double_jump_time():
	return sqrt(get_double_jump_height()/(get_double_jump_decelleration().y/2))

func get_starting_double_jump_velocity():
	return get_double_jump_decelleration()*get_max_double_jump_time()*-1

func get_current_double_jump_velocity():
	return get_starting_double_jump_velocity()+get_double_jump_decelleration()*time_double_jumping

func get_current_state():
	return current_state

func set_current_state(state):
	if(state != get_current_state()):
		leave_state(get_current_state())
		enter_state(state)
		current_state = state
		
func enter_state(state):
	pass
func leave_state(state):
	pass
func process_state(state, delta):
	pass
		
func _fixed_process(delta):
	process_state(get_current_state(), delta)
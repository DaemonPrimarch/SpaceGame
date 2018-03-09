extends "res://scripts/state_handler.gd"

export var starting_wall_slide_speed = 64 setget set_starting_wall_slide_speed,get_starting_wall_slide_speed
export var wall_slide_acceleration = 2*64 setget set_wall_slide_acceleration, get_wall_slide_acceleration
export var max_wall_slide_speed = 4*64 setget set_max_wall_slide_speed, get_max_wall_slide_speed

func set_starting_wall_slide_speed(val):
	starting_wall_slide_speed = val
	
func get_starting_wall_slide_speed():
	return starting_wall_slide_speed

func set_wall_slide_acceleration(val):
	wall_slide_acceleration = val

func get_wall_slide_acceleration():
	return wall_slide_acceleration

func set_max_wall_slide_speed(val):
	max_wall_slide_speed = val

func get_max_wall_slide_speed():
	return max_wall_slide_speed

func get_handled_state():
	return "WALL_SLIDING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_velocity(Vector2(0,get_starting_wall_slide_speed()))
	
func leave_state(new_state):
	.leave_state(new_state)
	
	
func can_enter():
	return .can_enter() and not get_parent().is_inside_helper_area("no_wall_slide") and get_parent().can_wall_jump()
	
func can_continue():
	get_parent().wall_slide_detector_up.force_raycast_update()
	return get_parent().wall_slide_detector_up.is_colliding() and get_parent().can_wall_slide_on_node(get_parent().wall_slide_detector_up.get_collider())
	
func process_state(delta):
	.process_state(delta)
	
	if(not can_continue()):
		get_parent().set_state("FALLING")
	elif(Input.is_action_just_pressed("jump") and get_parent().can_wall_jump()):
		get_parent().set_state("WALL_JUMPING")
	else:
		pass
	
	if(get_parent().get_velocity().y < get_max_wall_slide_speed()):
		get_parent().set_velocity(get_parent().get_velocity() + Vector2(0,get_wall_slide_acceleration() * delta))
	
	var vertical_collision_info = get_parent().move_and_collide(get_parent().get_velocity() * Vector2(0,1) * delta)
	
	if(vertical_collision_info != null):
		get_parent().set_state("STANDING")


func _ready():
	set_no_gravity(true)
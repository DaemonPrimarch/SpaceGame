extends "res://scripts/state_handler.gd"

export var double_jump_height = 64 * 2 setget set_double_jump_height, get_double_jump_height

func get_double_jump_height():
	return double_jump_height

func set_double_jump_height(val):
	double_jump_height = val

func get_handled_state():
	return "WALL_JUMPING"
	
func _ready():
	set_no_gravity(true)

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_flippedH(not get_parent().is_flippedH())
	get_parent().set_gravity_enabled(false)
			
	get_parent().set_velocity(Vector2())
			
	get_parent().animation_player.play("jump")
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(not Input.is_action_pressed("jump") or get_timer() > 4):
		get_parent().set_state(get_parent().STATES.FALLING)
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state(get_parent().STATES.CLIMBING)
	else:
		get_parent().move_and_collide(get_parent().get_gravity_vector() * -1 * delta)
				
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
					
		var collision_info = get_parent().move_and_collide(Vector2(1,0) * get_parent().get_direction() * delta  * get_parent().get_movement_speed())
				
		if(collision_info != null):
			get_parent().set_state(get_parent().STATES.WALL_SLIDING)
			get_parent().set_wall_slide_side(get_parent().get_direction().x)
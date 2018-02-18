extends "res://scripts/state_handler.gd"

func _ready():
	pass
	
func get_handled_state():
	return "WALKING"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_grounded()):
		get_parent().set_state(get_parent().STATES.FALLING)
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state(get_parent().STATES.CLIMBING)
	elif(Input.is_action_just_pressed("jump") and get_parent().can_jump()):
		get_parent().set_state(get_parent().STATES.REGULAR_JUMPING)
	elif(Input.is_action_pressed("play_left") or Input.is_action_pressed("play_right")):
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
					
		get_parent().move_and_collide_slope(Vector2(1,0) * delta * get_parent().get_direction() * get_parent().get_movement_speed())
	else:
		get_parent().set_state(get_parent().STATES.STANDING)
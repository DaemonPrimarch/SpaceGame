extends "res://addons/state_handler/state_handler.gd"

var wall_jump_direction = Vector2()
var wall_jumped = false
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
	if(previous_state == "WALL_JUMPING"):
		wall_jumped = true
		wall_jump_direction = get_parent().get_direction()
	else:
		wall_jumped = false
		wall_jump_direction = Vector2()
	
	get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
	
	get_parent().animation_player.play("fall")
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)

	
	if(get_parent().is_grounded()):
		get_parent().set_state("STANDING")
	elif(get_parent().is_action_just_pressed("jump") and get_parent().can_enter_state("DOUBLE_JUMPING")):
		get_parent().set_state("DOUBLE_JUMPING")
	elif(get_parent().is_action_pressed("play_up") and get_parent().get_node("ladder_manager").is_inside_ladder() and get_parent().can_enter_state("CLIMBING")):
		get_parent().set_state("CLIMBING")
	elif((get_parent().is_action_pressed("play_left") and wall_jump_direction.x == -1) or (get_parent().is_action_pressed("play_right") and wall_jump_direction.x == 1)):
		var collision_info = get_parent().apply_velocity_x(delta)
		
		if(collision_info != null):
			if(get_parent().can_enter_state("WALL_SLIDING")):
				get_parent().set_state("WALL_SLIDING")
			else:
				get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))
	else:
		wall_jump_direction = Vector2()

		if(get_parent().is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
			get_parent().set_velocity(Vector2(get_parent().get_movement_speed(),get_parent().get_velocity().y))
		elif(get_parent().is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
			get_parent().set_velocity(Vector2(get_parent().get_movement_speed(),get_parent().get_velocity().y))
		else:
			get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))
			
		var collision_info = get_parent().apply_velocity_x(delta)
				
		if(collision_info != null):
			if(get_parent().can_enter_state("WALL_SLIDING")):
				get_parent().set_state("WALL_SLIDING")
			else:
				get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))
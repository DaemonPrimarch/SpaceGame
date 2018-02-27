extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "STANDING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().double_jumped = false
	
	get_parent().animation_player.play("idle")

func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_grounded()):
		get_parent().set_state("FALLING")
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	elif(Input.is_action_just_pressed("jump") and get_parent().can_jump()):
		get_parent().set_state("REGULAR_JUMPING")
	elif(Input.is_action_pressed("play_left") or Input.is_action_pressed("play_right")):
		get_parent().set_state("WALKING")
	elif(Input.is_action_pressed("play_down")):
		get_parent().set_state("CROUCHING")
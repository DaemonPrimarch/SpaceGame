extends "res://addons/state_handler/state_handler.gd"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_velocity(Vector2())
	
	get_parent().get_handler("DOUBLE_JUMPING").double_jumped = false
	
	get_parent().animation_player.play("idle")

func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_grounded()):
		get_parent().set_state("FALLING")
	elif(get_parent().is_action_pressed("play_down") and get_parent().get_node("ladder_manager").is_inside_ladder_top_area()):
		get_parent().set_ladder(get_parent().get_ladder_top())
		
		get_parent().position += Vector2(0, 10)
		
		get_parent().set_state("CLIMBING")
	elif(((get_parent().is_action_pressed("play_up") and get_parent().get_node("ladder_manager").is_inside_ladder()) or get_parent().get_node("ladder_manager").is_inside_walled_ladder()) and get_parent().can_enter_state("CLIMBING")):
		get_parent().set_state("CLIMBING")
	elif(get_parent().track_manager.is_on_track() and get_parent().can_enter_state("ON_TRACK")):
		get_parent().set_state("ON_TRACK")
	elif(get_parent().is_action_just_pressed("jump") and get_parent().can_enter_state("REGULAR_JUMPING")):
		get_parent().set_state("REGULAR_JUMPING")
	elif(get_parent().is_action_pressed("play_left") or get_parent().is_action_pressed("play_right")):
		get_parent().set_state("WALKING")
	elif(get_parent().is_action_pressed("play_down")):
		get_parent().set_state("CROUCHING")

func leave_state(new):
	.leave_state(new)
	
	get_parent().animation_player.stop()

func _init():
	pass
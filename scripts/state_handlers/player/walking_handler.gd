extends "res://scripts/state_handler.gd"

func _ready():
	pass
	
func get_handled_state():
	return "WALKING"
	
func enter_state(previous_state):
	.enter_state(previous_state)	
	get_parent().animation_player.play("run")
	
func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_grounded()):
		get_parent().set_state("FALLING")
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	elif(Input.is_action_just_pressed("jump") and get_parent().can_jump()):
		get_parent().set_state("REGULAR_JUMPING")
	elif(Input.is_action_pressed("play_left") or Input.is_action_pressed("play_right")):
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
					
		if(get_parent().move_and_collide(Vector2(1,0) * delta * get_parent().get_direction() * get_parent().get_movement_speed()) != null):
			if(not get_parent().get_node("crawl_detector_up").is_colliding() and not get_parent().get_node("crawl_detector_up").is_colliding()):
				get_parent().set_state("CRAWLING")
	else:
		get_parent().set_state("STANDING")
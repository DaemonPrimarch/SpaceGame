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
	elif(get_parent().is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	elif(get_parent().is_action_just_pressed("jump") and get_parent().can_enter_state("REGULAR_JUMPING")):
		get_parent().set_state("REGULAR_JUMPING")
	elif(get_parent().is_action_pressed("play_left") or get_parent().is_action_pressed("play_right")):
		if(get_parent().is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(get_parent().is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
			
		var collision = get_parent().move_and_collide_slope(Vector2(1,0) * delta * get_parent().get_direction() * get_parent().get_movement_speed())
					
		if(collision):
			if(get_parent().can_enter_state("CRAWLING") and get_parent().get_handler("CRAWLING").can_crawl_under(collision.collider)):
				get_parent().set_state("CRAWLING")
	else:
		get_parent().set_state("STANDING")
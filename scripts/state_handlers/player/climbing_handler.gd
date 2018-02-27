extends "res://scripts/state_handler.gd"

func _ready():
	set_no_gravity(true)

func get_handled_state():
	return "CLIMBING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().get_ladder().snap_to(get_parent())
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(Input.is_action_just_pressed("jump")):
		get_parent().set_state("REGULAR_JUMPING")
	elif(not get_parent().is_inside_ladder()):
		get_parent().set_state("FALLING")
	else:
		var dir = 0
				
		if(Input.is_action_pressed("play_up")):
			dir = -1
		elif(Input.is_action_pressed("play_down")):
			dir = 1
			
		get_parent().move_and_collide(Vector2(0, dir) * get_parent().get_climbing_speed() * delta)
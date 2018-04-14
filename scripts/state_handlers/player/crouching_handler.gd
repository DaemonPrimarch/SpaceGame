extends "res://scripts/state_handler.gd"

func _ready():
	get_node("crouch_leave_detector_left").add_exception(get_parent())
	get_node("crouch_leave_detector_right").add_exception(get_parent())
func get_handled_state():
	return "CROUCHING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	$AnimationPlayer.play("crouch_start")
	
#	get_parent().set_scale(get_parent().get_scale() * Vector2(1,0.5))
#	get_parent().position += Vector2(0, 16)
	
func leave_state(new_state):
	.leave_state(new_state)
	
	$AnimationPlayer.play("crouch_stop")
#	get_parent().set_scale(get_parent().get_scale() * Vector2(1,2))
#
#	get_parent().position -= Vector2(0, 16)
	
func process_state(delta):
	.process_state(delta)
	
	if(not Input.is_action_pressed("play_down") and not get_node("crouch_leave_detector_left").is_colliding() and not get_node("crouch_leave_detector_right").is_colliding()):
		get_parent().set_state("STANDING")
	else:
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
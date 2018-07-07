extends "res://addons/state_handler/state_handler.gd"

func _ready():
	get_node("crouch_leave_detector_left").add_exception(get_parent())
	get_node("crouch_leave_detector_right").add_exception(get_parent())

func enter_state(previous_state):
	.enter_state(previous_state)
	
	$AnimationPlayer.play("crouch_start")
	get_parent().get_node("AnimationPlayer").stop()
	
func leave_state(new_state):
	.leave_state(new_state)
	
	$AnimationPlayer.play("crouch_stop")

func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_action_pressed("play_down") and not get_node("crouch_leave_detector_left").is_colliding() and not get_node("crouch_leave_detector_right").is_colliding()):
		get_parent().set_state("STANDING")
	else:
		if(get_parent().is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(get_parent().is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
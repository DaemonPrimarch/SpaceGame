extends "res://addons/state_handler/state_handler.gd"

export var stunned_time = 5

func enter_state(previous_state):
	.enter_state(previous_state)
	print("ik ben er geraakt")
	get_parent().get_node("eye_black").modulate = Color(0,0,0)
	get_parent().get_node("TemporarySprite").get_node("Sprite").modulate = Color(0,255,0)
	
func leave_state(new_state):
	.leave_state(new_state)
	get_parent().get_node("TemporarySprite").get_node("Sprite").modulate = Color(255,255,0)
	
func process_state(delta):
	.process_state(delta)
	
	if(get_timer() > stunned_time):
		get_parent().set_flippedH(not get_parent().is_flippedH())
		get_parent().set_state("IDLE")


extends "res://addons/state_handler/state_handler.gd"

func enter_state(previous_state):
	get_parent().set_velocity(Vector2(get_parent().get_velocity().x, 0))
		
func process_state(delta):
	if(get_parent().track_manager.is_on_track()):
		get_parent().set_state("ON_TRACK")
	elif(get_parent().is_grounded()):
		get_parent().set_state("STANDING")
	elif(not get_parent().is_action_pressed("jump") and get_parent().get_velocity().y < 0):
		get_parent().set_velocity(Vector2(get_parent().get_velocity().x, 0))
#	elif(get_parent().is_action_pressed("play_left")):
#		get_parent().set_velocity(get_parent().get_velocity() - Vector2(delta * 64 * 3, 0))
#	elif(get_parent().is_action_pressed("play_right")):
#		get_parent().set_velocity(get_parent().get_velocity() + Vector2(delta * 64 * 3, 0))
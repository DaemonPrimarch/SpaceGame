extends "res://scripts/managers/track_manager.gd"

func _ready():
	get_parent().connect("state_left", self, "player_state_left")
	
func player_state_left(state, new_state):
	if((state == "ON_TRACK" and new_state != "TRACK_JUMPING") or(state == "TRACK_JUMPING" and not new_state == "ON_TRACK") and not is_on_track()):
		remove_track_position()
		
var prev_position
var position_set = false

func set_track(track):
	.set_track(track)
	
	if(not track == null):
		apply_track_position()
		
		if(get_track().applies_fast_camera_offset):
			position_set = true
		else:
			position_set = false

func apply_track_position():
	if(get_track().applies_fast_camera_offset):
		prev_position = get_parent().get_node("ExtendedCamera2D").position
		
		get_parent().get_node("ExtendedCamera2D").move_at_speed_to(get_track().fast_camera_offset, get_track().get_speed())
	
func remove_track_position():
	print("REMOVED!")
	
	if(position_set):
		print("VERY REMOVED")
		get_parent().get_node("ExtendedCamera2D").move_to(prev_position, 1)

	
	
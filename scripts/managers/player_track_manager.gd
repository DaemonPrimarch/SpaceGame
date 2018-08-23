extends "res://scripts/managers/track_manager.gd"

func _ready():
	get_parent().connect("state_left", self, "player_state_left")
	
func player_state_left(state, new_state):
	if((state == "ON_TRACK" and new_state != "TRACK_JUMPING") or(state == "TRACK_JUMPING" and not new_state == "ON_TRACK") and not is_on_track()):
		remove_track_position()
		
var prev_position
var position_set = false
var exited = true

func set_track(track):
	.set_track(track)
	
	apply_track_position()
		
	if(get_track().applies_fast_camera_offset):
		position_set = true
	else:
		position_set = false
			
	track.connect("direction_changed", self, "apply_track_position")

func remove_track(track):
	track.disconnect("direction_changed", self, "apply_track_position")
	
	.remove_track(track)

func apply_track_position():
	if(get_track().applies_fast_camera_offset):
		if(exited):
			prev_position = get_parent().get_node("ExtendedCamera2D").position
			exited = false
		get_parent().get_node("ExtendedCamera2D").move_at_speed_to(Vector2(get_track().get_fast_camera_offset().x, prev_position.y), get_track().get_speed())
	
func remove_track_position():
	if(position_set):
		get_parent().get_node("ExtendedCamera2D").move_to(prev_position, 1)
		
	
	
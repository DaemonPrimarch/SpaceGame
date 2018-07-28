extends Node

signal track_changed()

var track = null

func _ready():
	get_parent().add_to_group("handles_track")
	
	get_parent().connect("collided_with_ground", self, "node_collided_with_ground")
	
func node_collided_with_ground(ground):
	if(not is_on_track() and ground.is_in_group("track")):
		ground.connect_node(get_parent())
	
func set_track(p_track):	
	var prev = track
	
	track = p_track
	
	if(p_track != null):
		emit_signal("track_changed")
	
func is_on_track():
	return track != null

func get_track():
	return track
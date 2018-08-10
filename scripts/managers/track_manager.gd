extends Node

signal track_changed()

var tracks = []

func _ready():
	get_parent().add_to_group("handles_track")
	
	get_parent().connect("collided_with_ground", self, "node_collided_with_ground")
	get_parent().connect("warped", self, "clear_tracks")
	
func node_collided_with_ground(ground):
	if(not is_on_track() and ground.is_in_group("track")):
		ground.connect_node(get_parent())
		
func clear_tracks():
	tracks = []
	
func set_track(p_track):
	tracks.push_front(p_track)
	if(tracks.size() >= 2):
		emit_signal("track_changed")

func remove_track(p_track):
	var i = tracks.find(p_track)
	
	if(i >= 0):
		tracks.remove(i)
	
		if(get_track() and i == 0):
			emit_signal("track_changed")

func is_on_track():
	return tracks.size() != 0

func get_track():
	if(not tracks.size()):
		return null
	else:
		return tracks[0]
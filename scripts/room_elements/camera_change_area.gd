extends Area2D

export var one_way = true
export var changes_offset = true
export var offset = Vector2()
export var changes_zoom = true
export var zoom = 1
export var transition_time = 1

func _on_camera_change_area_body_entered(body):
	if(body.is_in_group("player") and body.has_camera()):
		if(changes_offset):
			body.get_camera().move_offset_to(offset, transition_time)
		if(changes_zoom):
			body.get_camera().zoom_to(zoom, transition_time)

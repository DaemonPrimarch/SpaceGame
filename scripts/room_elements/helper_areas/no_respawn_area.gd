extends Area2D

func _on_no_respawn_area_body_entered( body ):
	if(body.has_method("set_in_no_respawn_area")):
		body.set_in_no_respawn_area(true)


func _on_no_respawn_area_body_exited( body ):
	if(body.has_method("set_in_no_respawn_area")):
		body.set_in_no_respawn_area(false)

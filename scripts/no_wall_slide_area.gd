extends Area2D

func _on_no_wall_slide_area_body_entered( body ):
	if(body.is_in_group("player")):
		body.set_in_no_wall_slide_area(true)


func _on_no_wall_slide_area_body_exited( body ):
	if(body.is_in_group("player")):
		body.set_in_no_wall_slide_area(false)

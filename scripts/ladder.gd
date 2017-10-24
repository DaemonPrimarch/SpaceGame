extends Area2D

func _on_ladder_body_enter( body ):
	if(body.is_in_group("player")):
		print("entered ladder")
		body.set_ladder(self)


func _on_ladder_body_exit( body ):
	if(body.is_in_group("player")):
		print("left_ladded")
		body.set_ladder(null)



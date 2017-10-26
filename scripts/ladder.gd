extends Area2D

signal snapped_to_ladder

func _on_ladder_body_enter( body ):
	print("ENTERED")
	if(body.is_in_group("player")):
		body.set_ladder(self)


func _on_ladder_body_exit( body ):
	if(body.is_in_group("player")):
		body.set_ladder(null)

func snap_to_ladder(character):
	emit_signal("snapped_to_ladder", character)

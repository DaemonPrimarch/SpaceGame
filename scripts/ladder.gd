extends Area2D

signal snapped_to_ladder

enum TYPES {FRONTAL, LEFT, RIGHT}

func get_type():
	return TYPES.FRONTAL

func _on_ladder_body_enter( body ):
	if(body.is_in_group("player")):
		body.set_ladder(self)

func _on_ladder_body_exit( body ):
	if(body.is_in_group("player")):
		body.set_ladder(null)

func snap_to_ladder(character):
	emit_signal("snapped_to_ladder", character)

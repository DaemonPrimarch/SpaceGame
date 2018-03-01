tool

extends "res://scripts/room_elements/ladder.gd"



func _on_top_area_body_entered( body ):
	if(body.has_method("set_top_ladder_area")):
		body.set_top_ladder_area(self)


func _on_top_area_body_exited( body ):
	if(body.has_method("set_top_ladder_area")):
		body.set_top_ladder_area(null)

func snap_to(player):
	player.position.x = position.x
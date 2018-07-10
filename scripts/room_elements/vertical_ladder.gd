tool

extends "res://scripts/room_elements/ladder.gd"



func _on_top_area_body_entered( body ):
	if(body.is_in_group("handles_ladder")):
		body.get_node("ladder_manager").set_ladder_top_area(self)


func _on_top_area_body_exited( body ):
	if(body.is_in_group("handles_ladder")):
		body.get_node("ladder_manager").set_ladder_top_area(null)

func snap_to(player):
	player.position.x = position.x
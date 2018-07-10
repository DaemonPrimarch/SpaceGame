tool

extends "ladder.gd"

onready var pol_col = get_node("Area2D/CollisionPolygon2D")

func snap_to(player):
	if(is_flippedH()):
		player.position.x += (global_position.x + 32 - player.get_AABB().position.x)
	else:
		player.position.x += (global_position.x + 32 - player.get_AABB().end.x)
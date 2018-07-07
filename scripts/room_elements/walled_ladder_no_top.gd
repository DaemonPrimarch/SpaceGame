tool

extends "res://scripts/room_elements/ladder.gd"

onready var pol_col = get_node("Area2D/CollisionPolygon2D")

func snap_to(player):
	if(is_flippedH()):
		player.position.x = position.x + player.get_AABB().position.x + player.get_AABB().size.x - 32
	else:
		player.position.x = position.x - player.get_AABB().position.x - player.get_AABB().size.x + 32
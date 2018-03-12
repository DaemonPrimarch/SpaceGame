tool

extends "res://scripts/room_elements/ladder.gd"

onready var pol_col = get_node("Area2D/CollisionPolygon2D")

func snap_to(player):
	
	print(player.get_AABB())
	
	if(is_flippedH()):
		print("flipped_ladder")
		player.position.x = position.x + player.get_AABB().position.x + player.get_AABB().size.x - 32
	else:
		player.position.x = position.x - player.get_AABB().position.x - player.get_AABB().size.x + 32
extends "res://scripts/ladder.gd"

func snap_to_ladder(character):
	character.move(Vector2(get_global_pos().x - character.get_global_pos().x, 0))
	
	.snap_to_ladder(character)
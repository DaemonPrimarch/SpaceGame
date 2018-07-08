extends Node2D

signal bullet_hit(bullet)

func _ready():
	get_parent().add_to_group("handles_bullet_hit")
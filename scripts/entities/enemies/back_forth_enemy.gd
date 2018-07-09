tool

extends "res://scripts/entities/enemies/enemy.gd"

func _init():
	add_state("BACK_FORTH")

func crush():
	destroy()
tool
extends "res://scripts/entities/enemies/enemy.gd"

func _init():
	add_state("IDLE")
	add_state("AIR_BLASTING")

func _on_bullet_hit_manager_bullet_hit(bullet):
	set_state("AIR_BLASTING")
tool

extends "res://scripts/entity.gd"

func _ready():
	pass

func _on_bullet_hit(bullet):
	damage(bullet.get_damage())
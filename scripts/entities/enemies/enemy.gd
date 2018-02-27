tool

extends "res://scripts/entities/entity.gd"

export var damage = 1 setget set_damage, get_damage

func set_damage(value):
	damage = value

func get_damage():
	return damage

func _ready():
	pass

func _on_bullet_hit(bullet):
	damage(bullet.get_damage())

func _on_object_hit(object):
	if(object.is_in_group("player")):
		object.damage(get_damage())
extends "res://scripts/entity.gd"
# class member variables go here, for example:
export var damage = 5 setget set_damage,get_damage

func _ready():
	pass

func get_damage():
	return damage

func set_damage(value):
	damage = value
extends "res://scripts/entity.gd"
# class member variables go here, for example:
export var damage = 5 setget set_damage,get_damage

func _ready():
	connect("hit_by_bullet", self, "on_bullet_hit")

func get_damage():
	return damage

func set_damage(value):
	damage = value

func on_bullet_hit(bullet):
	damage(bullet.get_damage())
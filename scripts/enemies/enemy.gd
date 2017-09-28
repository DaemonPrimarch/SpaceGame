extends "res://scripts/entity.gd"
# class member variables go here, for example:
export var movement_speed = 64 setget set_movement_speed,get_movement_speed
export var damage = 5 setget set_damage,get_damage

func _ready():
	connect("hit_by_bullet", self, "on_bullet_hit")

func get_movement_speed():
	return movement_speed

func set_movement_speed(value):
	movement_speed = value

func get_damage():
	return damage

func set_damage(value):
	damage = value

func on_bullet_hit(bullet):
	damage(bullet.get_damage())
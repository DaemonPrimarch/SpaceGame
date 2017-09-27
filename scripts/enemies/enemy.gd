extends "res://scripts/entity.gd"

# class member variables go here, for example:
export var movement_speed = 64 setget set_movement_speed,get_movement_speed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_movement_speed():
	return movement_speed

func set_movement_speed(value):
	movement_speed = value

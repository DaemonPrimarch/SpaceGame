tool

extends "res://scripts/regular_warp_tile.gd"

var previous_layers

func _ready():
	previous_layers = get_node("KinematicBody2D").get_collision_layer()
	
func _on_warp_tile_activated():
	print("ACTIVATED")
	get_node("KinematicBody2D").set_collision_layer(previous_layers)

func _on_warp_tile_deactivated():
	print("DEACTIVATED")
	
	get_node("KinematicBody2D").set_collision_layer(0)
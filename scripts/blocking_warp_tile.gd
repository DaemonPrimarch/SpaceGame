tool

extends "res://scripts/regular_warp_tile.gd"

var previous_layers = 0

func _ready():
	previous_layers = get_node("KinematicBody2D").get_collision_layer()
	
func _on_warp_tile_activated():
	get_node("KinematicBody2D").set_collision_layer(0)


func _on_warp_tile_deactivated():
	if(previous_layers != 0):
		get_node("KinematicBody2D").set_collision_layer(previous_layers)
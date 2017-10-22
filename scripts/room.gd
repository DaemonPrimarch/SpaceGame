extends Node2D

signal player_enter

export var camera_zoom = Vector2(1,1)

func get_camera_zoom():
	return camera_zoom
	
func set_player_zoom(player):
	player.get_node("camera").set_zoom(get_camera_zoom())
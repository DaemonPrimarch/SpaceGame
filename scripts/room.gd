extends Node2D

signal player_enter(player)

var loaded

export var camera_zoom = Vector2(1,1)

func _ready():
	pass

func get_camera_zoom():
	return camera_zoom
	
func set_player_zoom(player):
	player.get_node("camera").set_zoom(get_camera_zoom())

func _on_test_player_existance_timer_timeout():
	if(not loaded):
		var new_player = preload("res://nodes/player.tscn").instance()
		new_player.set_pos(get_node("test_player_spawn_point").get_pos())
		add_child(new_player)
		new_player.set_name("test_player")
		emit_signal("player_enter", new_player)

func _on_room_player_enter(player):
	loaded = true

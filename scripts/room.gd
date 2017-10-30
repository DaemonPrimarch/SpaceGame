extends Node2D

signal player_enter

var loaded

export var camera_zoom = Vector2(1,1)

func _ready():
	get_node("test_player").set_fixed_process(false)
	get_node("test_player").set_process_input(false)
	get_node("test_player").set_process(false)
	get_node("test_player").set_hidden(true)

func get_camera_zoom():
	return camera_zoom
	
func set_player_zoom(player):
	player.get_node("camera").set_zoom(get_camera_zoom())

func _on_test_player_existance_timer_timeout():
	if(loaded):
		get_node("test_player").queue_free()
	else:
		get_node("test_player").set_fixed_process(true)
		get_node("test_player").set_process_input(true)
		get_node("test_player").set_process(true)
		get_node("test_player").set_hidden(false)
		emit_signal("player_enter", get_node("test_player"))


func _on_room_player_enter(player):
	loaded = true

tool

extends Node2D

signal player_enter(player)

var loaded

export var camera_zoom = Vector2(1,1)
export(PackedScene) var test_player

func _ready():
	pass

func get_camera_zoom():
	return camera_zoom
	
func set_player_zoom(player):
	player.get_node("camera").set_zoom(get_camera_zoom())

func _on_test_player_existance_timer_timeout():
	if(not loaded):
		var new_player
		if(test_player == null):
			new_player = preload("res://nodes/player.tscn").instance()
		else:
			new_player = test_player.instance()
		new_player.set_pos(get_node("test_player_spawn_point").get_pos())
		add_child(new_player)
		new_player.set_name("test_player")
		emit_signal("player_enter", new_player)

func _on_room_player_enter(player):
	loaded = true
	
func get_used_rect():
	var terrains = get_tree().get_nodes_in_group("terrain")
	var terrain_found = false
	
	var posX = []
	var posY = []
	var m_posX = []
	var m_posY = []
	var rect
	
	if(terrains.size() >= 1):
		for terrain in terrains:
			if(terrain extends TileMap):
				terrain_found = true
				
				posX.append((terrain.get_used_rect().pos.x*terrain.get_cell_size().x + terrain.get_global_pos().x))
				posY.append((terrain.get_used_rect().pos.y*terrain.get_cell_size().y + terrain.get_global_pos().y))
				m_posX.append((terrain.get_used_rect().pos.x*terrain.get_cell_size().x + terrain.get_global_pos().x + terrain.get_used_rect().size.x * terrain.get_cell_size().x))
				m_posY.append((terrain.get_used_rect().pos.y*terrain.get_cell_size().y + terrain.get_global_pos().y + terrain.get_used_rect().size.y * terrain.get_cell_size().y))
	if(terrain_found):
		rect = Rect2(Vector2(min_arr(posX), min_arr(posY)), Vector2(max_arr(m_posX), max_arr(m_posY)))
	else:
		rect = Rect2()
	
	return rect
	
func min_arr(arr):
    var min_val = arr[0]

    for i in range(1, arr.size()):
        min_val = min(min_val, arr[i])

    return min_val
	
func max_arr(arr):
    var min_val = arr[0]

    for i in range(1, arr.size()):
        min_val = max(min_val, arr[i])

    return min_val
	
tool

extends Node2D

signal player_entered(player)
signal room_lit
signal room_darkened

export var dark = true setget set_dark, is_dark 
export var dark_color = Color(0,0,0)
export var auto_generate_camera_container = true

func _ready():
	if(Engine.editor_hint and auto_generate_camera_container):
		generate_camera_container()

func set_dark(val):
	dark = val
	
	if(not val):
		call_deferred("emit_signal","room_lit")
	else:
		call_deferred("emit_signal","room_darkened")

func is_dark():
	return dark

func _on_room_room_darkened():
	get_node("CanvasModulate").color = dark_color

func _on_room_room_lit():
	get_node("CanvasModulate").color = Color(1,1,1)

func generate_camera_container():
	var min_point = Vector2(10000, 10000)
	
	for tile in get_node("terrain").get_used_cells():
		if(tile.x < min_point.x):
			min_point = tile
	
	var scrolling_point = min_point
	var polygon = []
	var terrain = get_node("terrain")
	var rect = terrain.get_used_rect()
	
	polygon.push_back(rect.position * terrain.cell_size)
	polygon.push_back((rect.position + rect.size * Vector2(0, 1)) * terrain.cell_size)
	polygon.push_back((rect.position + rect.size) * terrain.cell_size)
	polygon.push_back((rect.position + rect.size * Vector2(1, 0)) * terrain.cell_size)
	
	get_node("camera_container").polygon = polygon
tool

extends Node2D

signal player_entered(player)
signal room_lit
signal room_darkened

export var dark = true setget set_dark, is_dark 
export var dark_color = Color(0,0,0)

func _ready():
	pass

func set_dark(val):
	dark = val
	
	if(not val):
		emit_signal("room_lit")
	else:
		emit_signal("room_darkened")

func is_dark():
	return dark

func _on_room_room_darkened():
	get_node("CanvasModulate").color = dark_color

func _on_room_room_lit():
	get_node("CanvasModulate").color = Color(1,1,1)


func set_active():
	pass # replace with function body

extends Node2D

var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_bullet_switch_switch_on():
	player.get_save_data()["goo_key"] = true


func _on_bullet_switch_switch_off():
	if(player != null):
		player.get_save_data()["goo_key"] = false


func _on_room_player_enter():
	player = get_parent().get_node("player")

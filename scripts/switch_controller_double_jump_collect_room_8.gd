extends Node2D

var theplayer

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_bullet_switch_switch_on():
	theplayer.get_save_data()["goo_key"] = true


func _on_bullet_switch_switch_off():
	if(theplayer != null):
		theplayer.get_save_data()["goo_key"] = false


func _on_room_player_enter(player):
	theplayer = player

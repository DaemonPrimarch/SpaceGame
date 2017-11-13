extends Node2D

var theplayer
onready var map = get_node("TileMap")
onready var goo = get_node("goo")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_bullet_switch_switch_on():
	theplayer.get_save_data()["goo_key"] = true
	map.set_collision_layer(0)
	map.set_hidden(true)
	goo.set_active(false)


func _on_bullet_switch_switch_off():
	if(theplayer != null):
		theplayer.get_save_data()["goo_key"] = false


func _on_room_player_enter(player):
	theplayer = player
	if(player.get_save_data().has("goo_key") and player.get_save_data()["goo_key"]):
		map.set_collision_layer(0)
		map.set_hidden(true)

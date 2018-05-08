extends Area2D

export var one_time = false;
var player

signal player_entered
signal platform_entered

func _on_area_enter(body):
	if(body.is_in_group("player")):
		player = body
		emit_signal("player_entered")
	if(body.is_in_group("platform")):
		emit_signal("platform_entered")

func give_key(key):
	player.add_to_inventory(key)
	if(one_time):
		queue_free()

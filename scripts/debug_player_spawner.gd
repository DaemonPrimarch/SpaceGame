extends Position2D

export(PackedScene) var player
export var enabled = true

func _ready():
	if(enabled):
		call_deferred("load_player")

func load_player():
	if(get_node("/root/ROOM_MANAGER").is_room_loaded(get_parent())):
		self.queue_free()
	else:
		print("Added debug Player!!!")
		
		get_node("/root/ROOM_MANAGER").add_room_as_loaded(get_parent())
		
		var new_player = player.instance()
		
		new_player.set_position(get_position())
		
		get_parent().add_child(new_player)
		
		new_player.emit_signal("room_entered")
		get_parent().emit_signal("player_entered", new_player)
		
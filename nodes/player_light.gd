extends Light2D

func _ready():
	get_parent().connect("room_entered", self, "_on_player_room_entered")

func _on_player_room_entered():
	if(get_node("/root/ROOM_MANAGER").get_room_of_node(self).is_dark()):
		enabled = true
	else:
		enabled = false
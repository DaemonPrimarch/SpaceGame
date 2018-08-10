extends Light2D

func set_enabled(val):
	enabled = val

func set_color(new_color):
	color = new_color

func _ready():
	set_enabled(enabled)
	
	if(not Engine.editor_hint):
		get_parent().connect("room_entered", self, "_on_player_room_entered")
	
	if(get_node("/root/ROOM_MANAGER").get_room_of_node(self).is_dark()):
		enabled = true
	else:
		enabled = false
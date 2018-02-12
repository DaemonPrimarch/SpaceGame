extends "res://scripts/room.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	ROOM_MANAGER.add_room_as_loaded(self)

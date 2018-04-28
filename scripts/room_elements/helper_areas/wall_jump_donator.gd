extends "res://scripts/room_elements/helper_areas/push_button_area.gd"

func _ready():
	connect("confirmed", self, "on_confirmed")

func on_confirmed(body):
	get_node("/root/DIALOG_SYSTEM").queue_message("walljump unlocked")

	SAVE_MANAGER.set_property("player/wall_jump_enabled", true)
	
	self.queue_free()

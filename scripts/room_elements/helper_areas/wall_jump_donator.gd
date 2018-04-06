extends "res://scripts/room_elements/helper_areas/push_button_area.gd"

func _ready():
	connect("confirmed", self, "on_confirmed")

func on_confirmed(body):
	body.get_handler("WALL_SLIDING").set_enabled(true)
	get_node("/root/DIALOG_SYSTEM").queue_message("walljump unlocked")
	self.queue_free()

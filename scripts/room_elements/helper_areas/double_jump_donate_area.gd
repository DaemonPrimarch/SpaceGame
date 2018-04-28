extends "res://scripts/room_elements/helper_areas/push_button_area.gd"

func _ready():
	connect("confirmed", self, "on_confirmed")

func on_confirmed(body):
	body.get_handler("DOUBLE_JUMPING").set_enabled(true)
	SAVE_MANAGER.set_property("player/double_jump_enabled", true)
	get_node("/root/DIALOG_SYSTEM").queue_message("Double jump unlocked")

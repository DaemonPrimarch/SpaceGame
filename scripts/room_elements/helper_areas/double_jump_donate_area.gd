extends "res://scripts/room_elements/helper_areas/push_button_area.gd"

func _ready():
	connect("confirmed", self, "on_confirmed")

func on_confirmed(body):
	body.enable_double_jump()
	get_node("/root/DIALOG_SYSTEM").queue_message("Double jump unlocked")

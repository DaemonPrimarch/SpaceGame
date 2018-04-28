extends "res://scripts/room_elements/helper_areas/push_button_area.gd"

func _ready():
	connect("confirmed", self, "on_confirmed")

func on_confirmed(body):
	SAVE_MANAGER.set_property("player/weapon_enabled", true)
	get_node("/root/DIALOG_SYSTEM").queue_message("gun unlocked")
	self.queue_free()

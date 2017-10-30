extends "res://scripts/trigger.gd"

func on_body_enter(body):
	if(body.is_in_group("player")):
		emit_signal("triggered")
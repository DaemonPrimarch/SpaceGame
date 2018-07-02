tool
extends Area2D

export var offset = Vector2()
export var time   = 0

func _ready():
	connect("body_entered", self, "_on_body_enter")

func _on_body_enter(body):
	if(body.is_in_group("carries_camera")):
		for child in body.get_children():
			if(child.is_in_group("extended_camera")):
				child.move_offset_to(offset, time)
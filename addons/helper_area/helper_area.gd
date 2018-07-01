tool
extends Area2D

export var type = "undefine"

func _ready():
	connect("body_entered", self, "_on_helper_area_body_entered")
	connect("body_exited", self, "_on_helper_area_body_exited")

func get_type():
	return type

func _on_helper_area_body_entered( body ):
	if(body.is_in_group("entity")):
		body.set_inside_helper_area(get_type(), true)

func _on_helper_area_body_exited( body ):
	if(body.is_in_group("entity")):
		body.set_inside_helper_area(get_type(), false)

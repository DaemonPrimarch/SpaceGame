extends Node2D



func _on_light_area_body_entered(body):
	if(body.is_in_group("light_detecting")):
		body.emit_signal("light_entered", self)


func _on_light_area_body_exited(body):
	if(body.is_in_group("light_detecting")):
		body.emit_signal("light_exited", self)

extends Area2D

func _on_area_enter(body, key):
	if(body.is_in_group("player")):
		body.add_to_inventory(key)
	queue_free()

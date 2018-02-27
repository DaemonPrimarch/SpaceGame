extends StaticBody2D

func _on_bullet_hit(bullet):
	destroy()
	
func destroy():
	queue_free()
extends StaticBody2D

signal toggle

func _on_bullet_hit(bullet):
	emit_signal("toggle")
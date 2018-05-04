extends StaticBody2D

signal toggle

export var enabled = true

func _on_bullet_hit(bullet):
	if(enabled):
		emit_signal("toggle")
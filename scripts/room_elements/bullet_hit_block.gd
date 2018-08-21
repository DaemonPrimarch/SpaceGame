extends StaticBody2D

signal triggered

export var enabled = true

func _on_bullet_hit(bullet):
	if(enabled):
		emit_signal("triggered")
		$ExtendedAnimationPlayer.play("triggered")
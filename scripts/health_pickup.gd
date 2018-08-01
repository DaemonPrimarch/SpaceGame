extends Area2D

var health = 1

func _ready():
	connect("body_entered", self, "_on_body_entered")

func set_health(val):
	health = val

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.set_HP(body.get_HP() + health)
		self.queue_free()
		
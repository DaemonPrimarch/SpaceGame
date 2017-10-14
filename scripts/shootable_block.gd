extends StaticBody2D

signal hit_by_bullet

func _ready():
	connect("hit_by_bullet", self, "on_bullet_hit")

func on_bullet_hit(bullet):
	queue_free()

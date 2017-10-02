extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal hit_by_bullet

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("hit_by_bullet", self, "on_bullet_hit")

func on_bullet_hit(bullet):
	destroy()

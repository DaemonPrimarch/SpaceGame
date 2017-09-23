extends KinematicBody2D

signal collision

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("collision", self, "on_collision")

#Moves the object by an amount, returns wether it collided
func move(direction):
	.move(direction)
	
	if(is_colliding()):
		emit_signal("collision", get_collider())
		get_collider().emit_signal("collision", get_collider())
		return true
	else:
		return false

func on_collision(body):
	print("Collsion with: ", body)
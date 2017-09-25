extends KinematicBody2D

signal collision

func _ready():
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
		
func move_no_collision(direction):
	set_pos(get_pos() + direction)

func on_collision(body):
	pass

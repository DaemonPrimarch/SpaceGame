extends StaticBody2D

signal collision

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("collision",self,"on_collision")

func on_collision(collision_info):
	if(collision_info.get_collider().is_in_group("player")):
		destroy()

func destroy():
	self.queue_free()

#Change to collides with betterKinematicBody2D later. (also in the originating script!)
func is_betterKinematicBody2D():
	return true

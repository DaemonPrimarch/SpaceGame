extends Area2D

signal collision

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func destroy():
	self.queue_free()

#Change to collides with betterKinematicBody2D later. (also in the originating script!)
func is_betterKinematicBody2D():
	return true


func _on_StaticBody2D_body_enter( body ):
	if(body.is_in_group("player")):
		destroy()

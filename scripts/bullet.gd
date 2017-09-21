extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Timer_timeout():
	self.queue_free()


func _on_bullet_body_enter( body ):
	if(body.is_in_group("destructable_by_bullet")):
		body.destroy()
	self.queue_free()

extends RigidBody2D

var damage = 5 setget set_damage,get_damage

func _ready():
	pass
	
func get_damage():
	return damage

func set_damage(value):
	damage = value

func _on_Timer_timeout():
	destroy()

func _on_bullet_body_enter( body ):
	if(body.has_method("on_bullet_hit")):
		body.on_bullet_hit(self)
	
	set_hidden(true)
	#destroy()

func destroy():
	self.queue_free()

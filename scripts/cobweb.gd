extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var cobweb_timer = get_node("cobweb_timer")


func _on_Area2D_body_enter( body ):
	if(body.has_method("on_cobweb_enter")):
		body.on_cobweb_enter(self)
	
	if(body.is_in_group("bullet")):
		destroy()
	
	if(body.is_in_group("player")):
		body.set_gravity_vector(body.get_gravity_vector()/2)
		body.set_movement_speed(body.get_movement_speed()/2)

func _on_Area2D_body_exit( body ):
	if(body.has_method("on_cobweb_leave")):
		body.on_cobweb_leave(self)
		
	if(body.is_in_group("player")):
		body.set_gravity_vector(body.get_gravity_vector()*2)
		body.set_movement_speed(body.get_movement_speed()*2)

func destroy():
	self.queue_free()


func _on_cobweb_timer_timeout():
	destroy()

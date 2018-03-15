extends Area2D

export var velocity = Vector2(64 * 4,0) setget set_velocity, get_velocity

export var damage = 10

func set_velocity(v):
	velocity = v

func get_velocity():
	return velocity

func _physics_process(delta):
	position += get_velocity().rotated(get_rotation()) * delta

func get_damage():
	return damage

func destroy():
	queue_free()

func decay_timer_timeout():
	destroy()

func on_body_entered( body ):
	if(body.has_method("_on_bullet_hit")):
		body._on_bullet_hit(self)
	
	destroy()
	
func on_area_entered( area ):
	if(area.has_method("_on_bullet_hit")):
		area._on_bullet_hit(self)

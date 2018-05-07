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
		#DEPRECATED
		body._on_bullet_hit(self)
	
	if(body.is_in_group("bullet_detecting")):
		body.emit_signal("bullet_hit", self)
	
	destroy()
	
func on_area_entered( area ):
	if(area.has_method("_on_bullet_hit")):
		#DEPRECATED
		area._on_bullet_hit(self)
	
	if(area.is_in_group("bullet_detecting")):
		area.emit_signal("bullet_hit", self)

func _ready():
	get_node("Light2D").enabled = (get_node("/root/ROOM_MANAGER").get_room_of_node(self).is_dark())
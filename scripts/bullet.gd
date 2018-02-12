extends Area2D

export var velocity = Vector2(64 * 4,0) setget set_velocity, get_velocity

func set_velocity(v):
	velocity = v

func get_velocity():
	return velocity
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	set_position(get_position() + get_velocity().rotated(get_rotation()) * delta)

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
	
	destroy()

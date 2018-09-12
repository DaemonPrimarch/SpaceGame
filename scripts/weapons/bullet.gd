extends Area2D

export var velocity = Vector2(64 * 4,0) setget set_velocity, get_velocity

export var damage = 10

var destroyed = false

func set_velocity(v):
	velocity = v

func get_velocity():
	return velocity

func _physics_process(delta):
	process_move(delta)

func process_move(delta):
	position += get_velocity().rotated(get_rotation()) * delta
	
func get_damage():
	return damage

func destroy():
	destroyed = true
	
	queue_free()

func decay_timer_timeout():
	destroy()

func on_body_entered( body ):
	if(body.is_in_group("handles_bullet_hit") and not destroyed):
		body.get_node("bullet_hit_manager").emit_signal("bullet_hit", self)
	
	destroy()
	
func on_area_entered( area ):
	if(area.is_in_group("handles_bullet_hit") and not destroyed):
		area.get_node("bullet_hit_manager").emit_signal("bullet_hit", self)
		destroy()

func _ready():
	pass
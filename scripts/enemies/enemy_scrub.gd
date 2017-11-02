extends "res://scripts/enemies/enemy.gd"

onready var front_detector = get_node("FrontGroundDetector")
export var stompable = true

func _ready():
	set_process(true)
	set_fixed_process(true)
	
func _fixed_process(delta):
	var movement_direction = 1
	if(is_flippedH()):
		movement_direction = -1
	if(move(Vector2(movement_direction*get_movement_speed()*delta,0)).has_collision()):
		set_flippedH(!is_flippedH())
	if(!front_detector.is_colliding()):
		set_flippedH(!is_flippedH())

func destroy():
	if(not is_destroyed()):
		destroyed = true
		get_node("AnimationPlayer").play("Death")
		set_layer_mask(0)

func _on_AnimationPlayer_finished():
	if(is_destroyed()):
		self.queue_free()

func is_stompable():
	return stompable

func on_collision_with_player(info):
	if(is_stompable() and get_node("head_area").overlaps_body(info.get_collider())):
		destroy()
	else:
		.on_collision_with_player(info)
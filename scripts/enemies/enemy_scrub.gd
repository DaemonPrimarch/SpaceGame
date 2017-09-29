extends "res://scripts/enemies/enemy.gd"

onready var front_detector = get_node("FrontGroundDetector")

func _ready():
	set_process(true)
	set_fixed_process(true)

	connect("collision",self,"on_collision")
	
	
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
		print("Destroyed")
		destroyed = true
		get_node("AnimationPlayer").play("Death")
	#

func _on_AnimationPlayer_finished():
	if(is_destroyed()):
		self.queue_free()

func on_collision(collision_info):
	if(collision_info.get_collider().is_in_group("player")):
		if(get_node("head_area").overlaps_body(collision_info.get_collider())):
			print("DESTROYEEE")
			destroy()
		else:
			collision_info.get_collider().damage(5)
			collision_info.get_collider().set_invulnerable(true)
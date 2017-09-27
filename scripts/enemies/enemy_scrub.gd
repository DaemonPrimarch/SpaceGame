extends "res://scripts/enemies/enemy.gd"

onready var front_detector = get_node("FrontGroundDetector")

func _ready():
	set_process(true)
	set_fixed_process(true)
	connect("hit_by_bullet",self,"on_bullet_hit")
	connect("collision",self,"on_collision")
	
	
func _fixed_process(delta):
	var movement_direction = 1
	if(is_flippedH()):
		movement_direction = -1
	if(move(Vector2(movement_direction*get_movement_speed*delta,0))):
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

func on_bullet_hit(bullet):
	self.damage(10)

func on_collision(body):
	if(body.is_in_group("player")):
		if(get_node("head_area").overlaps_body(body)):
			destroy()
		else:
			body.damage(5)
			body.set_invulnerable(true)

extends KinematicBody2D

var destroyed = false
var movement_direction = 1

onready var right_detector = get_node("RightGroundDetector")
onready var left_detector = get_node("LeftGroundDetector")
onready var sprite = get_node("Sprite")

func _ready():
	set_process(true)
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	if(movement_direction == 1 and (!right_detector.is_colliding() or test_move(Vector2(1,0)))):
		movement_direction *= -1
		sprite.set_flip_h(false)
	if(movement_direction == -1 and (!left_detector.is_colliding() or test_move(Vector2(-1,0)))):
		movement_direction *= -1
		sprite.set_flip_h(true)
	
	move(Vector2(2,0) * movement_direction)
	move(Vector2(0,2))

func destroy():
	if(not is_destroyed()):
		print("Destroyed")
		destroyed = true
		get_node("AnimationPlayer").play("Death")
	#

func is_destroyed():
	return destroyed

func _on_AnimationPlayer_finished():
	if(is_destroyed()):
		self.queue_free()

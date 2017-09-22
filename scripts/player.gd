
extends "res://scripts/Entity.gd"

####
export var max_HP = 10
export var hp = 10

export var walk_speed = 300

export var jump_speed = 98 *2
export var max_jump_time = 2

var original_gravity_enabled = gravity_enabled

func set_HP(hp):
	self.hp = hp
	
func get_HP():
	return self.hp

func damage(amount):
	var new_HP = get_HP() - amount
	
	if(new_HP <= 0):
		self.destroy()
	else:
		set_HP(new_HP)



#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")

onready var animation_player = get_node("AnimationPlayer")

var animation = "idle"
var shooting = false
var walking = false

var time_jumping = 0
var jumping = false

func is_jumping():
	return jumping
	
func start_jump():
	set_gravity_enabled(false)
	jumping = true
	time_jumping = 0

func stop_jump():
	set_gravity_enabled(original_gravity_enabled)
	jumping = false



func _fixed_process(delta):	
	var new_animation = "idle"
	if(Input.is_action_pressed("jump")):
		if(not is_jumping() and is_on_ground()):
			start_jump()
		
		if(is_jumping()):
			new_animation = "jumping"
			move(Vector2(0, -jump_speed * delta))
			time_jumping += delta
			
			if(time_jumping >= max_jump_time):
				stop_jump()
	elif(is_jumping()):
		stop_jump()
		
	if((not is_on_ground())and (not is_jumping())):
		new_animation = "falling"
	
	if(Input.is_action_pressed("play_left") and not is_warping()):
		set_flippedH(true)
		move(Vector2(- walk_speed * delta, 0))
		
		if(is_on_ground()):
			new_animation = "run"
	elif(Input.is_action_pressed("play_right") and not is_warping()):
		set_flippedH(false)
		move(Vector2(walk_speed * delta, 0))
		if(is_on_ground()):
			new_animation = "run"

	if(Input.is_action_pressed("shoot")):
		if(new_animation == "falling"):
			new_animation = "falling_weapon"
		elif(new_animation == "jumping"):
			new_animation = "jumping_weapon"
		elif(new_animation == "run"):
			new_animation = "run_weapon"
		elif(new_animation == "idle"):
			new_animation = "standing_weapon_ready"
	
	if(new_animation != animation):
		animation_player.play(new_animation)
		animation = new_animation

	
	#increment counters
	
	
	
	
	
func _ready():
	set_fixed_process(true)


func _on_shoot_countdown_timeout():
	shooting = false

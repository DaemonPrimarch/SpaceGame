extends "entity.gd"

signal HP_changed

signal invulnerable_started()
signal invulnerable_stopped()

export var HP = 100 setget set_HP, get_HP
export var max_HP = 100 setget set_max_HP, get_max_HP

export var invulnerability_time = 1.0 setget set_invulnerability_time, get_invulnerability_time
var invulnerability_timer
var mask_save
var invulnerable = false

func _ready():
	set_physics_process(not Engine.is_editor_hint())
		
	if(not Engine.is_editor_hint()):
		connect("room_entered", get_node("/root/GUI").HP_bar_handler, "add_HP_bar", [self])
		
		init_invulnerability_timer()

func init_invulnerability_timer():
	invulnerability_timer = Timer.new()
	
	invulnerability_timer.name = "invulnerable_timer"
	invulnerability_timer.wait_time = get_invulnerability_time()
	
	invulnerability_timer.connect("timeout",self,"_on_invulnerability_timer_timeout") 
	add_child(invulnerability_timer)

func get_HP():
	return HP

func set_HP(hp):
	if(hp <= get_max_HP()):
		HP = hp
		
		emit_signal("HP_changed")
		
		if(hp <= 0):
			destroy()
	else:
		HP = get_max_HP()
		emit_signal("HP_changed")
	
func get_max_HP():
	return max_HP

func set_max_HP(max_hp):
	max_HP = max_hp

func damage(d):
	if(not invulnerable):
		set_HP(get_HP() - d)
		invulnerability_timer.start()
		set_invulnerable(true)

func set_invulnerability_time(value):
	invulnerability_time = value

func get_invulnerability_time():
	return invulnerability_time

func _on_invulnerability_timer_timeout():
	set_invulnerable(false)
	invulnerability_timer.stop()

func is_invulnerable():
	return invulnerable

func set_invulnerable(value):
	invulnerable = value
	if(value):
		mask_save = collision_mask
		collision_mask = 0
		set_collision_mask_bit(0,1)
		
		emit_signal("invulnerable_started")
	else:
		collision_mask = mask_save
		
		emit_signal("invulnerable_stopped")
	
func damage_push(object):
	#DEPRECATED
	if(can_be_pushed and not invulnerable):
		var direction
		if(object.position.x > position.x):
			direction = -1
		else:
			direction = 1
		push_direction = direction
		is_pushed = true
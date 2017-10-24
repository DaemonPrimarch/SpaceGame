extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var damage = 1 setget set_damage,get_damage
export var has_timer = false

func set_damage(value):
	damage = value

func get_damage():
	return damage

func has_timer():
	return has_timer

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if(has_timer()):
		start_timer()

func _fixed_process(delta):
	for object in get_overlapping_bodies():
		if(object.is_in_group("player")):
			object.damage(get_damage())
			object.set_invulnerable(true)

func _on_area_body_enter( body ):
	if(body.is_in_group("player")):
		set_fixed_process(true)

func _on_area_body_exit( body ):
	if(body.is_in_group("player")):
		set_fixed_process(false)


func _on_Timer_timeout():
	set_hidden(not is_hidden())

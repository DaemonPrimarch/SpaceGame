tool

extends "res://scripts/entities/player/playable_character.gd"
onready var damage_timer = get_node("damage_timer")

func _ready():
	pass

func _physics_process(delta):
	pass

func damage(d):
	.damage(d)
	damage_timer.start()
	get_tree().set_pause(true)

func _on_damage_timer_timeout():
	damage_timer.stop()
	get_tree().set_pause(false)

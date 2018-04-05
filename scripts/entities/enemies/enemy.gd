tool

extends "res://scripts/entities/living_entity.gd"

export var damage = 1 setget set_damage, get_damage

onready var health_pickup = preload("res://nodes/health_pickup.tscn")

func set_damage(value):
	damage = value

func get_damage():
	return damage

func _ready():
	pass

func _on_bullet_hit(bullet):
	damage(bullet.get_damage())

func _on_object_hit(object):
	if(object.is_in_group("player")):
		object.damage(get_damage())

func destroy():
	#instantiate HP pickups
	randomize()
	var inti = randi()%11+1
	if(inti > 5 ):
		var drop = health_pickup.instance()
		drop.set_name("drop_from_" + self.name)
		get_parent().add_child(drop)
		drop.global_position = self.global_position
		drop.health = randi()%11+1
	self.queue_free()
tool

extends "res://addons/entities/living_entity.gd"

export var damage = 1 setget set_damage, get_damage

export(float, 0,1) var hp_drop_chance = 0.5

onready var health_pickup = preload("res://nodes/health_pickup.tscn")

func set_damage(value):
	damage = value

func get_damage():
	return damage

func _ready():
	bullet_hit_manager.connect("bullet_hit", self, "_on_bullet_hit")

func get_HP_drop_chance():
	return hp_drop_chance

func _on_bullet_hit(bullet):
	damage(bullet.get_damage())

func _on_object_hit(object):
	if(object.is_in_group("player")):
		object.damage(get_damage())
		
func generate_drops():
	#instantiate HP pickups
	randomize()

	if(rand_range(0,1) < get_HP_drop_chance()):
		var drop = health_pickup.instance()
		drop.set_name("drop_from_" + name)
		get_node("/root/ROOM_MANAGER").get_room_of_node(self).add_child(drop)
		drop.global_position = global_position
		drop.health = randi()%11+1

func destroy():
	generate_drops()
	queue_free()
extends "res://scripts/entity.gd"
# class member variables go here, for example:
export var damage = 5 setget set_damage,get_damage

func _ready():
	connect("collision", self, "on_enemy_collision")

func get_damage():
	return damage

func set_damage(value):
	damage = value
	
func on_enemy_collision(info):
	if(info.get_collider().is_in_group("player")):
		on_collision_with_player(info)

func on_collision_with_player(info):
	info.get_collider().damage(get_damage())
	info.get_collider().set_invulnerable(true)
tool

extends "res://scripts/entities/enemies/enemy.gd"

export var explosion_radius = (5 * 64)
export var fuse_lit = false
export var fuse_time = 5

func _init():
	add_state("BACK_FORTH")

func crush():
	destroy()

func _ready():
	if(fuse_lit && not Engine.editor_hint):
		$fuse_tween.interpolate_property($TemporarySprite/Sprite, "modulate", Color(1,1,0), Color(1,0,0), fuse_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$fuse_tween.start()
func explode():
	var explosion = preload("res://nodes/explosion.tscn").instance()
	explosion.global_position = global_position
	explosion.radius = explosion_radius

	get_node("/root/ROOM_MANAGER").get_room_of_node(self).add_child(explosion)
	
	explosion.call_deferred("explode")

func destroy():
	explode()
	.destroy()

func _on_fuse_tween_tween_completed(object, key):
	destroy()

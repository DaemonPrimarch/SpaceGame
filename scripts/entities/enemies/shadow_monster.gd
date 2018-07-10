tool

extends "res://scripts/entities/enemies/enemy.gd"

export var eyes_visible= true setget set_eyes_visible

func _init():
	add_state("BODY_INVISIBLE")
	add_state("SILLOUETTE_VISIBLE")
	add_state("SILLOUETTE_ATTACK")
	add_state("FULL_VISIBLE")
	
func set_eyes_visible(val):
	if(is_inside_tree()):
		$eye1.enabled = val
		$eye2.enabled = val
		
	eyes_visible = val
	
func get_player():
	return get_parent().get_node("player")

func attack_player(player):
	get_handler("SILLOUETTE_ATTACK").set_player_attacking(player)
	set_state("SILLOUETTE_ATTACK")
	
func _on_shadow_monster_light_entered(source):
#	if(not attacking):
#		visible = false
	pass


func _on_shadow_monster_light_exited(source):
#	visible = true
	pass


func _on_attack_tween_completed(object, key):
	queue_free()
	
	get_player().damage(get_damage())

tool

extends "res://scripts/entities/enemies/enemy.gd"

export var attack_duration = 0.2
export var eyes_visible= true setget set_eyes_visible

var attacking = false

func _init():
	add_state("BODY_INVISIBLE")
	add_state("SILLOUETTE_VISIBLE")
	add_state("FULL_VISIBLE")
	
func set_eyes_visible(val):
	if(is_inside_tree()):
		$eye1.enabled = val
		$eye2.enabled = val
		
	eyes_visible = val
	
func get_player():
	return get_parent().get_node("player")

func attack_player():	
	var play = get_player()
	attacking = true
	
	if(play):
		$attack.interpolate_property(self, "position", position, play.position, attack_duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$attack.start()
	
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

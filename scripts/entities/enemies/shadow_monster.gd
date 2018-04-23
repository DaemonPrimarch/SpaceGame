extends "res://scripts/entities/enemies/enemy.gd"

export var attack_duration = 0.2
export var eyes_enabled = true setget set_eyes_enabled

var attacking = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_eyes_enabled(val):
	if(is_inside_tree()):
		$eye1.enabled = val
		$eye2.enabled = val
	
func get_player():
	for play in get_tree().get_nodes_in_group("player"):
		return play
	
	return null

func attack_player():	
	var play = get_player()
	attacking = true
	
	if(play):
		$attack.interpolate_property(self, "position", position, play.position, attack_duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$attack.start()
	
func _on_shadow_monster_light_entered(source):
	print("ROEMI")
	if(not attacking):
		visible = false


func _on_shadow_monster_light_exited(source):
	visible = true


func _on_attack_tween_completed(object, key):
	queue_free()
	
	get_player().damage(get_damage())

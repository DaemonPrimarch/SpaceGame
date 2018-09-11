extends Node2D

export var damage_terrain = true
export var damage_entities = true
export var damage = 10
export var radius = 32 * 10
export var explosion_duration = 0.3

func explode():
	$Tween.start()
	

func _ready():
	$Tween.interpolate_property($Area2D, "scale", Vector2(0.05,0.05), Vector2(1,1)/32*radius, explosion_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)

func _on_Area2D_body_entered(body):
	if(damage_terrain and body.is_in_group("terrain")):
		body.explode_around(global_position, radius/64)
	if(damage_entities and body.is_in_group("living_entity")):
		body.damage(damage)

func _on_Tween_tween_completed(object, key):
	queue_free()

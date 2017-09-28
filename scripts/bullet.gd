extends RigidBody2D

signal hit_by_bullet
const entity_class = preload("res://scripts/entity.gd")

var damage = 5 setget set_damage,get_damage

func _ready():
	pass

func get_damage():
	return damage

func set_damage(value):
	damage = value

func _on_Timer_timeout():
	destroy()


func _on_bullet_body_enter( body ):
	if(body extends entity_class):
		body.emit_signal("hit_by_bullet",self)
	destroy()

func destroy():
	self.queue_free()

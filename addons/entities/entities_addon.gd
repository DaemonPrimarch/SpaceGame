tool
extends EditorPlugin

func _ready():
	add_custom_type("Entity", "KinematicBody2D", preload("entity.gd"), preload("entity.svg"))
	add_custom_type("LivingEntity", "KinematicBody2D", preload("living_entity.gd"), preload("entity.svg"))
func _exit_tree():
	remove_custom_type("Entity")
	remove_custom_type("LivingEntity")
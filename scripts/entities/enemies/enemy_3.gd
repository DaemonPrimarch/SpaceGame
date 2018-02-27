extends "res://scripts/entities/enemies/enemy.gd"

# class member variables go here, for example:
# var a = 2
# var b = \"textvar\"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	get_parent().set_offset(get_parent().get_offset() + (get_movement_speed()*delta))


func _on_object_hit( body ):
	pass # replace with function body


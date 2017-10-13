extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _fixed_process(delta):
	for object in get_overlapping_bodies():
		if(object.is_in_group("player")):
			object.damage(5)
			object.set_invulnerable(true)

func _on_spike_body_enter( body ):
	if(body.is_in_group("player")):
		print("start")
		set_fixed_process(true)

func _on_spike_body_exit( body ):
	if(body.is_in_group("player")):
		print("stop")
		set_fixed_process(false)

extends Area2D

export var offset = Vector2()
export var time = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_camera_offset_mover_body_entered( body ):
	if(body.is_in_group("player")):
		body.get_node("camera2").move_offset_to(offset, time)

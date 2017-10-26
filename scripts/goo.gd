extends "res://scripts/hazard_area.gd"

# class member variables go here, for example:
export var turn_off = false 

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _fixed_process(delta):
	for object in get_overlapping_bodies():
		if(object.is_in_group("player")):
			object.damage(get_damage())
			object.set_invulnerable(true)

func _on_goo_body_enter( body ):
	if(not is_hidden()):
		if(body.is_in_group("player")):
			if(pushes()):
				if(not body.is_invulnerable()):
					body.damage(get_damage())
				body.set_invulnerable(true)
				body.push(get_push_time(), get_push_time_extended(),Vector2(get_push_speed_x(),get_push_speed_y()))
			else:
				set_fixed_process(true)


func _on_goo_body_exit( body ):
	if(body.is_in_group("player")):
		set_fixed_process(false)


func _on_room_player_enter():
	if(turn_off):
		if(get_parent().get_node("player").get_save_data().has("goo_key") and get_parent().get_node("player").get_save_data()["goo_key"]):
			set_hidden(true)

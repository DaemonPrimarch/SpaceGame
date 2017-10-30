extends "res://scripts/hazard_area.gd"

export var speed1 = 64*2
export var height1 = 20
export var speed2 = 64*2
export var height2 = 20

var start = false
var current_y_pos

func start():
	start = true
	current_y_pos = get_pos().y
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Goo Alert!!!"]))

func stop():
	start = false
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Stabilized."]))

func _fixed_process(delta):
	._fixed_process(delta)
	if(start):
		if(get_pos().y > current_y_pos - height1*64):
			set_pos(get_pos() + Vector2(0,-1*speed1*delta))
		elif(get_pos().y > current_y_pos - height2*64):
			set_pos(get_pos() + Vector2(0,-1*speed2*delta))
		else:
			stop()

func _on_room_player_enter(player):
	if(player.get_save_data().has("goo_key_2") and player.get_save_data()["goo_key_2"] == true):
		set_pos(get_pos() - Vector2(0,height2 * 64))
	else:
		get_parent().get_node("TileMap").set_collision_layer(0)
		get_parent().get_node("TileMap").set_hidden(true)